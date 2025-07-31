# Organize commits into logical units

現在のブランチのコミットを意味のある単位に整理し直します。派生元ブランチを自動検出し、そのブランチからの差分を分析して論理的な単位でコミットを再構成します。

## 使用方法
```
/squash-commits [target-branch]
```

- `target-branch`: 比較対象のブランチ（省略時: 自動検出、検出できない場合はmain）

## 実行手順

1. **作業ディレクトリの確認**
   - 未コミットの変更がないか確認
   - ある場合は先にコミットを促す、または自動でコミット

2. **派生元ブランチの自動検出**
   - 現在のブランチがどのブランチから派生したかを検出
   - デフォルトではローカルのmainブランチを使用
   - 明示的に指定された場合のみリモートブランチとのmerge-baseを計算
   - 最も近い共通祖先を持つブランチを派生元として選択
   - 検出結果をユーザーに表示

3. **現在の状態を確認**
   - 現在のブランチ名を取得
   - 検出した派生元ブランチとの差分を確認
   - 変更されたファイルの一覧を取得

4. **squash対象の確認（重要）**
   - **以下の情報を明示的にユーザーに提示**:
     - 現在のブランチ名
     - 派生元ブランチ名
     - squash対象となるコミット数
     - 変更されるファイルの一覧（`git diff --name-only`）
     - 各ファイルの変更行数（`git diff --stat`）
   - **ユーザーに確認を求める**:
     - 「これらの変更を[派生元ブランチ]からの差分としてsquashしますか？」
     - 間違いがある場合は中止して、正しいブランチを指定するよう促す

5. **コミット履歴を分析**
   - 各コミットの変更内容を確認
   - 論理的なグループに分類

6. **シンプルな3ステップで再構成**
   - **Step 1: Reset** - `git reset --soft <派生元>` でコミットを解除（変更は保持）
   - **Step 2: Add** - `git add` で必要なファイルをステージング
   - **Step 3: Commit** - `git commit` で新しいコミットを作成
   - rebaseやcherry-pickは使用せず、このシンプルなフローで処理

## コミット分類の基準

### 1. **基盤・依存関係**
   - パッケージの追加・更新（package.json, package-lock.json）
   - 設定ファイルの変更
   - 開発環境の設定

### 2. **データモデル層**
   - データベーススキーマ（schema.ts）
   - 型定義（types/*.ts）
   - バリデーション関数
   - マイグレーション

### 3. **ビジネスロジック層**
   - Service クラス（services/*.ts）
   - Transaction クラス（transactions/*.ts）
   - ユーティリティ関数（utils/*.ts）
   - 複雑なビジネスルール

### 4. **API層**
   - Server Actions（actions/*.ts）
   - API ルート（api/*/route.ts）
   - 認証・認可の実装

### 5. **UI基盤**
   - 汎用UIコンポーネント（components/ui/*.tsx）
   - 共通スタイル
   - テーマ設定

### 6. **機能UI**
   - 機能固有のコンポーネント（components/features/*.tsx）
   - カスタムフック（hooks/*.ts）
   - 状態管理

### 7. **統合・ページ**
   - ページコンポーネント（app/**/page.tsx）
   - レイアウトの更新
   - 既存コードへの統合

### 8. **改善・修正**
   - バグ修正
   - パフォーマンス改善
   - リファクタリング
   - エラーハンドリングの改善

## コミットメッセージの規則

```
<type>: <subject>

<body>

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Type
- `feat`: 新機能
- `fix`: バグ修正
- `refactor`: リファクタリング
- `perf`: パフォーマンス改善
- `style`: コードスタイルの変更
- `docs`: ドキュメントの変更
- `test`: テストの追加・修正
- `chore`: ビルドプロセスや補助ツールの変更

### Subject
- 50文字以内
- 現在形・命令形で記述
- 最初の文字は小文字（日本語の場合は除く）

### Body
- 変更の詳細を箇条書きで記述
- なぜ変更したかを説明
- 72文字で改行

## 実行例

```bash
# 未コミットの変更を確認
git status

# 未コミットの変更がある場合は先にコミット
git add .
git commit -m "wip: 作業中の変更を一時コミット"

# 現在のブランチの確認
git branch --show-current
# 出力例: feature/add-new-feature

# 派生元ブランチの検出（デフォルト: ローカルのmain）
# ローカルのmainブランチとのmerge-baseを計算
git merge-base HEAD main

# --remoteオプション使用時のみリモートブランチを確認
# for branch in $(git branch -r | grep -v HEAD); do
#   echo "$branch: $(git merge-base HEAD $branch)"
# done

# squash対象の確認（重要）
# 現在のブランチ: feature/add-new-feature
# 派生元ブランチ: feature/parent-branch
# squash対象のコミット数を確認
git rev-list --count feature/parent-branch..HEAD

# 変更されるファイルを確認
git diff --name-only feature/parent-branch...HEAD

# 変更の統計を確認
git diff --stat feature/parent-branch...HEAD

# ユーザーに確認を求める

# 派生元ブランチとの差分を確認
git diff --stat feature/parent-branch...HEAD

# コミット履歴を確認
git log --oneline feature/parent-branch..HEAD

# 派生元ブランチまでsoft reset（全ての変更をステージングエリアに保持）
git reset --soft $(git merge-base HEAD feature/parent-branch)

# シンプルな方法で再コミット
# 方法1: 全てを1つのコミットにまとめる場合
git add .
git commit -m "feat: <description>"

# 方法2: 論理的な単位で分割する場合
# ステージングエリアから一旦全て外す
git reset

# ファイルを選択してadd & commit
git add src/types/*.ts
git commit -m "feat: 型定義を追加"

git add src/lib/services/*.ts
git commit -m "feat: サービス層を実装"

git add src/components/**
git commit -m "feat: UIコンポーネントを実装"
```

## 派生元ブランチの検出ロジック

1. **デフォルト動作**
   - ローカルのmainブランチを派生元として使用
   - `git merge-base HEAD main`で共通祖先を特定

2. **明示的な指定時の動作**
   - `--remote`オプションまたは明示的なブランチ指定時のみリモートブランチを確認
   - `git branch -r`で全リモートブランチを取得
   - 各ブランチと現在のHEADとの`merge-base`を計算
   - 共通祖先のコミット日時を比較

3. **派生元の判定**
   - 最も新しい共通祖先を持つブランチを派生元として選択
   - ただし、現在のブランチ自身は除外
   - mainブランチよりも新しい共通祖先を持つブランチを優先

4. **フォールバック**
   - 適切な派生元が見つからない場合はローカルのmainを使用
   - ユーザーが明示的にtarget-branchを指定した場合はそれを優先

## よくある使用シーン

### PR作成前のコミット整理
```bash
# WIPコミットを論理的な単位にまとめる
/squash-commits

# 特定のfeatureブランチからの差分で整理
/squash-commits feature/base-branch
```

### 長期開発後の履歴整理
```bash
# 数十個のコミットを意味のある単位に整理
/squash-commits --interactive

# 派生元を自動検出して整理
/squash-commits --remote
```

### レビューフィードバック後の整理
```bash
# レビューで指摘された修正コミットをまとめる
/squash-commits

# 修正前の計画を確認
/squash-commits --dry-run
```

### チーム開発での履歴整理
```bash
# 統合ブランチからの差分で整理
/squash-commits develop

# mainへのマージ前に履歴をクリーンに
/squash-commits main
```

## 関連コマンド

- `/smart-rebase` - コミット整理後のrebase作業
- `/code-review` - 整理後のコード確認
- `/task` - コミット整理のタスク計画
- `/claude-learnings` - 効果的なコミット整理パターンの記録

## 注意事項

- **未コミットの変更は先に処理**: 作業中の変更は必ず先にコミットしてから整理を開始
- **作業前に必ず現在の状態を保存**: `git stash` や別ブランチへのバックアップを推奨
- **プッシュ済みのコミットは整理しない**: 他の開発者に影響を与える可能性があります
- **コンフリクトに注意**: マージコミットが含まれる場合は特に注意が必要
- **大きな変更は段階的に**: 一度に多くのコミットを整理すると複雑になります

## オプション

### デフォルトモード
ローカルのmainブランチとの差分確認後、ユーザーの承認を得てからsquashを実行：
```
/squash-commits
```

### リモートブランチモード（--remote）
リモートブランチを含めて派生元を自動検出：
```
/squash-commits --remote
```

### 自動モード（--auto）
確認なしで自動的にコミットを実行（従来の動作）：
```
/squash-commits --auto
```

### インタラクティブモード（--interactive）
各コミットごとに詳細な確認を求めながら進める：
```
/squash-commits --interactive
```

### ドライラン
実際の変更を行わず、計画のみを表示：
```
/squash-commits --dry-run
```

### 特定の範囲のみ
特定のコミット範囲のみを整理：
```
/squash-commits --range <start>..<end>
```

### 派生元の手動指定
自動検出を使わず、明示的に派生元を指定：
```
/squash-commits feature/parent-branch
```

### 派生元検出をスキップ
mainブランチからの差分で整理（従来の動作）：
```
/squash-commits --from-main
```

## 実行モード

### デフォルト動作
- squash対象の差分を明示的に表示
- ユーザーの確認を得てから実行
- 誤ったブランチでの実行を防止

### 自動モード（--auto）
- コミットメッセージを自動生成
- 確認なしでコミットを実行
- より効率的な作業フロー（従来の動作）

### インタラクティブモード（--interactive）
- squash対象の確認に加えて、各コミットでも確認を求める
- コミットメッセージの編集が可能
- より慎重な作業に適している