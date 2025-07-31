# Claude Code カスタムコマンド一覧

このディレクトリには、Claude Code で使用できるカスタムコマンドが含まれています。各コマンドは特定のタスクを効率化するために設計されています。

## 📋 コマンド一覧

### 🎯 基本コマンド

#### `/task` - タスク実行プロンプト生成
新規タスクや既存作業の再実行のためのプロンプトを生成します。
```bash
/task ユーザー認証機能を実装してください
/task --redo より良いエラーハンドリングで再実装
```

#### `/claude-config` - Claude設定管理
Claude Codeの設定ファイル（CLAUDE.md）を更新・管理します。
```bash
/claude-config コードレビューガイドを追加
```

#### `/claude-learnings` - 開発知見の抽出と記録
開発中に得られた知見を適切なCLAUDE.mdファイルに反映させます。
```bash
/claude-learnings "API実装パターン"
/claude-learnings "エラーハンドリング, バリデーション"
```

### 🔍 コードレビュー・分析

#### `/code-review` - 包括的コードレビュー
変更されたファイルに対して詳細なコードレビューを実行します。
```bash
/code-review
/code-review --focus security
```

#### `/code-review-suggest` - 改善提案付きレビュー
コードレビューに加えて、具体的な改善案を提示します。
```bash
/code-review-suggest
```

#### `/code-duplicate` - 重複コード検出
プロジェクト内の重複コードを検出し、リファクタリング案を提示します。
```bash
/code-duplicate
/code-duplicate --threshold 0.7
```

### 🔧 Git操作支援

#### `/smart-rebase` - インテリジェントrebase
指定したブランチに対して、コンフリクトを考慮したrebaseを実行します。
```bash
/smart-rebase main
/smart-rebase --interactive feature/target-branch
```

#### `/squash-commits` - コミット整理
複数のコミットを論理的にまとめて整理します。
```bash
/squash-commits
/squash-commits --keep-messages
```

#### `/difit` - ブラウザでdiff表示
現在のブランチと派生元ブランチの差分をブラウザ上で視覚的に確認します。
```bash
/difit
/difit main
```

### 📦 依存関係管理

#### `/library-upgrade` - ライブラリアップグレード支援
プロジェクトの依存関係を分析し、安全なアップグレードパスを提案します。
```bash
/library-upgrade
/library-upgrade --check react
```

### 💬 コミュニケーション

#### `/discussion` - ディスカッションモード
技術的な議論や設計相談を行うための対話モードを開始します。
```bash
/discussion アーキテクチャ設計について相談したい
```

## 🔄 典型的なワークフロー

### 新機能開発フロー
```bash
# 1. タスクの計画
/task ユーザー認証機能を実装

# 2. 実装作業...

# 3. コードレビュー
/code-review

# 4. 改善提案の確認
/code-review-suggest

# 5. 学んだことを記録
/claude-learnings "認証実装パターン"
```

### Git操作フロー
```bash
# 1. 作業完了後、コミットを整理
/squash-commits

# 2. mainブランチの最新変更を取り込み
/smart-rebase main

# 3. 最終レビュー
/code-review
```

### 設定管理フロー
```bash
# 1. プロジェクト固有の設定を確認
/claude-config

# 2. 新しい規約を追加
/claude-config 新しいコーディング規約を追加

# 3. 開発中の知見を記録
/claude-learnings
```

## 🎯 使い分けガイド

### 「どのコマンドを使うべき？」

| 状況 | 推奨コマンド | 理由 |
|------|------------|------|
| 新しいタスクを始める | `/task` | 実装計画を立てて、ブランチ戦略を決定 |
| コードの品質を確認したい | `/code-review` | 包括的なレビューを実行 |
| 具体的な改善案が欲しい | `/code-review-suggest` | 実装可能な提案を取得 |
| 似たようなコードが多い | `/code-duplicate` | 重複を検出してDRY原則を適用 |
| コミット履歴を整理したい | `/squash-commits` | 論理的な単位でコミットをまとめる |
| 最新のmainを取り込みたい | `/smart-rebase` | コンフリクトを考慮したrebase |
| 差分を視覚的に確認したい | `/difit` | ブラウザで見やすく差分表示 |
| 設定を変更したい | `/claude-config` | CLAUDE.mdファイルを適切に更新 |
| 学んだことを記録したい | `/claude-learnings` | 知見を体系的に文書化 |
| 技術的な相談がしたい | `/discussion` | 対話形式で設計を検討 |

## 💡 Tips

### 効率的な使い方

1. **コマンドの組み合わせ**: 複数のコマンドを組み合わせて使用することで、より効果的なワークフローを構築できます。

2. **定期的な実行**: `/code-review` や `/code-duplicate` は定期的に実行することで、コード品質を維持できます。

3. **知見の蓄積**: `/claude-learnings` を活用して、プロジェクト固有の知識を継続的に文書化しましょう。

### よくある質問

**Q: `/code-review` と `/code-review-suggest` の違いは？**
A: `/code-review` は問題点の指摘に焦点を当て、`/code-review-suggest` は具体的な改善コードを提示します。

**Q: いつ `/smart-rebase` を使うべき？**
A: 機能ブランチで長期間作業した後、mainブランチの変更を取り込む際に使用します。

**Q: `/claude-config` と `/claude-learnings` の使い分けは？**
A: `/claude-config` は設定の明示的な変更、`/claude-learnings` は開発中に得た知見の自動抽出に使用します。

## 📚 詳細情報

各コマンドの詳細な使用方法については、それぞれのドキュメントファイルを参照してください。