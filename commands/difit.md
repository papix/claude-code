# View diff with difit browser-based viewer

## 概要
現在のブランチと派生元ブランチの差分を[difit](https://github.com/yoshiko-pg/difit)でブラウザ上で視覚的に確認します。difitは差分を見やすく表示するWebベースのdiffビューアです。

## 使用方法
```
/difit [target-branch]
```
- `target-branch`: 比較対象のブランチ（省略時: 自動検出、デフォルトはmain）

## 実行内容
1. **現在のブランチを確認**
   - Gitリポジトリ内であることを確認
   - 現在のブランチ名を取得

2. **派生元ブランチの自動検出**
   - 指定がない場合、ローカルのmainブランチとの共通祖先を検出
   - 最も近い派生元を自動判定

3. **差分をdifitで表示**
   - `git diff 派生元..HEAD` の出力をdifitに渡す
   - ブラウザが自動的に開いて差分を表示

## 実行手順
```bash
# 現在のブランチを確認
current_branch=$(git branch --show-current)

# 派生元ブランチの検出（デフォルト: main）
if [ -z "$1" ]; then
    # 自動検出: mainとの共通祖先を見つける
    base_branch="main"
    merge_base=$(git merge-base HEAD $base_branch 2>/dev/null)
    
    if [ -z "$merge_base" ]; then
        echo "エラー: 派生元ブランチを検出できません"
        exit 1
    fi
else
    # 明示的に指定された場合
    base_branch="$1"
fi

# 差分を確認
diff_output=$(git diff ${base_branch}..HEAD)

if [ -z "$diff_output" ]; then
    echo "差分がありません（${base_branch}と同じ状態です）"
    exit 0
fi

# difitで差分を表示
echo "ブラウザで差分を表示します..."
echo "比較: ${base_branch}..${current_branch}"
git diff ${base_branch}..HEAD | npx difit
```

## よくある使用シーン

### コードレビュー前の確認
```bash
# mainブランチとの差分を視覚的に確認
/difit

# 特定のfeatureブランチとの差分を確認
/difit feature/base-branch
```

### プルリクエスト作成時
```bash
# PRで変更される内容を事前確認
/difit main

# developブランチへのPRの場合
/difit develop
```

### 作業内容の振り返り
```bash
# 今日の作業内容を確認
/difit

# 特定のブランチからの変更を確認
/difit feature/original-branch
```

### ペアプログラミング時の共有
```bash
# 変更内容をブラウザで共有
/difit

# 画面共有しながら差分を説明
/difit main
```

## 関連コマンド

- `/code-review` - 差分の詳細なコードレビュー
- `/squash-commits` - 差分確認後のコミット整理
- `/smart-rebase` - 派生元の最新変更を取り込む
- `/task` - 差分を基にした次のタスク計画

## 注意事項
- **npxで実行**: `npx difit`で実行されるため、事前のインストールは不要
- **初回実行時**: npxが必要なパッケージを自動的にダウンロード
- **大きな差分に注意**: 非常に大きな差分の場合、ブラウザのパフォーマンスに影響する可能性
- **バイナリファイルは非対応**: 画像などのバイナリファイルの差分は表示されません
- **インターネット接続**: 初回実行時はパッケージのダウンロードのため接続が必要