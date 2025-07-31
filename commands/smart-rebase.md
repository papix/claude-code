# Smart Rebase - Intelligent rebase helper with conflict resolution

指定したブランチ（デフォルト: main）をrebaseし、コンフリクトが発生した場合はインタラクティブに解決をサポートします。

## 使用方法
```
/smart-rebase [target-branch]
```

- `target-branch`: rebase先のブランチ名（省略時: main）

## 機能

### 1. 事前チェック
- 未コミットの変更がないか確認
- rebase対象ブランチとの差分を表示
- コンフリクトの可能性があるファイルを事前に検出・表示

### 2. インタラクティブなコンフリクト解決
コンフリクトが発生した場合、各ファイルについて以下の選択肢を提示：
- **ours**: 現在のブランチの変更を採用
- **theirs**: rebase先ブランチの変更を採用
- **manual**: 手動で解決（エディタで編集）
- **abort**: rebaseを中止

### 3. 安全な強制push
- リモートにpush済みのブランチの場合、`--force-with-lease`オプションを提案
- 自動pushは行わず、実行コマンドを表示

## 実行手順

1. **作業前の確認**
   ```bash
   # 未コミットの変更を確認
   git status --porcelain
   ```

2. **rebase対象の確認**
   ```bash
   # 現在のブランチ
   git branch --show-current
   
   # rebase対象ブランチの最新化
   git fetch origin <target-branch>
   
   # 差分の確認
   git log --oneline <target-branch>..HEAD
   ```

3. **コンフリクト予測**
   ```bash
   # マージベースの取得
   merge_base=$(git merge-base HEAD <target-branch>)
   
   # 潜在的なコンフリクトファイルを検出
   git diff --name-only $merge_base HEAD > our_files
   git diff --name-only $merge_base <target-branch> > their_files
   comm -12 <(sort our_files) <(sort their_files)
   ```

4. **rebase実行**
   ```bash
   git rebase <target-branch>
   ```

5. **コンフリクト解決ループ**
   ```bash
   while [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ]; do
     # コンフリクトファイルを取得
     conflicts=$(git diff --name-only --diff-filter=U)
     
     if [ -n "$conflicts" ]; then
       for file in $conflicts; do
         echo "コンフリクト: $file"
         echo "解決方法を選択してください:"
         echo "1) ours - 現在のブランチの変更を使用"
         echo "2) theirs - ${target_branch}の変更を使用"
         echo "3) manual - 手動で解決"
         echo "4) abort - rebaseを中止"
         
         # ユーザーの選択に応じて処理
         case $choice in
           1) git checkout --ours "$file" && git add "$file" ;;
           2) git checkout --theirs "$file" && git add "$file" ;;
           3) echo "エディタで $file を編集してください" ;;
           4) git rebase --abort && exit ;;
         esac
       done
       
       # 全てのコンフリクトが解決されたら継続
       if [ -z "$(git diff --name-only --diff-filter=U)" ]; then
         git rebase --continue
       fi
     fi
   done
   ```

6. **完了処理**
   ```bash
   # push済みかチェック
   if git rev-parse --verify origin/$(git branch --show-current) >/dev/null 2>&1; then
     echo "⚠️  このブランチはリモートにpush済みです"
     echo "以下のコマンドで安全にforce pushできます:"
     echo "git push --force-with-lease origin $(git branch --show-current)"
   fi
   ```

## エラーハンドリング

### 未コミットの変更がある場合
```bash
echo "未コミットの変更があります。以下のいずれかを実行してください:"
echo "1. git stash      # 変更を一時保存"
echo "2. git commit -am # 変更をコミット"
echo "3. git reset --hard # 変更を破棄（注意）"
```

### 複雑なコンフリクトの場合
```bash
echo "複雑なコンフリクトが発生しました。手動での解決が必要です:"
echo ""
echo "1. コンフリクトマーカーを確認:"
echo "   <<<<<<< HEAD"
echo "   (現在のブランチの内容)"
echo "   ======="
echo "   (rebase先の内容)"
echo "   >>>>>>> <commit>"
echo ""
echo "2. ファイルを編集してコンフリクトを解決"
echo "3. git add <file> で解決済みとマーク"
echo "4. git rebase --continue で継続"
echo ""
echo "中止する場合: git rebase --abort"
```

## 使用例

### 基本的な使用
```bash
# mainブランチをrebase
/smart-rebase

# 特定のブランチをrebase
/smart-rebase feature/base-branch
```

### コンフリクト解決の例
```
🔍 コンフリクトの可能性を検出中...

潜在的なコンフリクトファイル:
- src/components/App.tsx
- src/utils/helpers.ts

rebaseを開始しますか？ (y/n): y

⚠️  コンフリクト発生: src/components/App.tsx

解決方法を選択してください:
1) ours - 現在のブランチの変更を使用
2) theirs - mainの変更を使用  
3) manual - 手動で解決
4) abort - rebaseを中止

選択 (1-4): 2
✅ src/components/App.tsx をmainの内容で解決しました
```

## よくある使用シーン

### 長期開発ブランチの更新
```bash
# feature branchで長期間作業後、最新のmainを取り込む
/smart-rebase

# 別のfeature branchの変更を取り込む
/smart-rebase feature/base-feature
```

### プルリクエスト作成前の整理
```bash
# mainの最新変更を取り込んでからPR作成
/smart-rebase main

# コンフリクトを事前に解決してレビューしやすくする
/smart-rebase
```

### 複数人での開発時
```bash
# チームメンバーの変更を取り込む
/smart-rebase feature/team-branch

# 統合ブランチの最新状態に合わせる
/smart-rebase develop
```

### hotfix適用後の更新
```bash
# 緊急修正がmainに入った後、作業中のブランチを更新
/smart-rebase main

# リリースブランチの変更を取り込む
/smart-rebase release/v1.2.0
```

## 関連コマンド

- `/squash-commits` - rebase前にコミット履歴を整理
- `/code-review` - rebase後の変更内容を確認
- `/task` - コンフリクト解決のタスクを作成
- `/claude-learnings` - rebaseで得た知見を記録

## 注意事項

- **共有ブランチでの使用は避ける**: 他の開発者と共有しているブランチでrebaseを行うと問題が発生する可能性があります
- **force pushの影響**: `--force-with-lease`は比較的安全ですが、それでも他の開発者の作業に影響する可能性があります
- **バックアップ**: 重要な変更がある場合は、rebase前にブランチのバックアップを作成することを推奨
  ```bash
  git branch backup/$(git branch --show-current)-$(date +%Y%m%d)
  ```

## トラブルシューティング

### rebaseが中断された場合
```bash
# 状態を確認
git status

# 継続する場合
git rebase --continue

# 中止する場合
git rebase --abort
```

### 間違えてforce pushした場合
```bash
# reflogから復元
git reflog
git reset --hard <commit-hash>
```