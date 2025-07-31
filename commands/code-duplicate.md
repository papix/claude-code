# Detect and refactor duplicate code

## 概要
TypeScriptプロジェクトのコード重複を検出し、リファクタリング計画を立案します。コードの保守性を向上させ、技術的負債を削減します。

## 使用方法
```
/code-duplicate [--threshold <number>] [--path <path>]
```
- `--threshold`: 類似度の閾値（0-100、デフォルト: 70）
- `--path`: 検査対象のパス（デフォルト: .）

## 実行内容
1. **重複検出の実行**
   - `similarity-ts` コマンドを使用してコード重複を検出
   - TypeScriptファイルの構造的な類似性を分析

2. **重複パターンの分類**
   - 完全一致: 100%同一のコード
   - 高類似度: 80%以上の類似性
   - 中類似度: 60-79%の類似性

3. **リファクタリング計画の作成**
   - 重複コードの共通化方法を提案
   - 優先順位付けとリスク評価

4. **実装手順の提示**
   - 新規ブランチ名の提案
   - 段階的なリファクタリング手順

## 出力形式
```
## 🔍 コード重複分析結果

### 検出された重複パターン

#### 🔴 完全一致 (100%)
1. **ファイル**: `src/utils/validation.ts` ↔ `src/helpers/validate.ts`
   - **行数**: 45-89 (44行)
   - **内容**: ユーザー入力検証ロジック
   - **影響度**: 高（2箇所で使用）

#### 🟠 高類似度 (85%)
1. **ファイル**: `src/services/userService.ts` ↔ `src/services/adminService.ts`
   - **類似箇所**: データ取得メソッド
   - **差異**: 権限チェックのみ

### リファクタリング計画

#### Phase 1: 共通ユーティリティの抽出
1. 検証ロジックを `src/utils/common/validation.ts` に統合
2. 既存ファイルからインポートに変更
3. テストの更新

#### Phase 2: サービス層の抽象化
1. 基底クラス `BaseService` の作成
2. 共通メソッドの移動
3. 継承による実装

### 推奨ブランチ名
`refactor/eliminate-code-duplication`

### 実行コマンド
```bash
git checkout -b refactor/eliminate-code-duplication
# Phase 1の実装...
```

### 期待される効果
- コード行数: -150行（約15%削減）
- 保守性: ⬆️ 大幅に向上
- テストカバレッジ: 変更なし
```

## よくある使用シーン

### 定期的なコード品質チェック
```bash
# プロジェクト全体の重複をチェック
/code-duplicate

# 高い閾値で完全一致に近い重複のみ検出
/code-duplicate --threshold 90
```

### 新機能実装前の確認
```bash
# 特定のディレクトリ内の重複を確認
/code-duplicate --path src/services

# 似たような実装がないか事前チェック
/code-duplicate --path src/utils --threshold 60
```

### リファクタリング計画立案
```bash
# リファクタリング対象の特定
/code-duplicate --threshold 70

# 影響範囲を限定して段階的に実施
/code-duplicate --path src/components
```

### コードレビュー時の活用
```bash
# PRで追加されたコードの重複チェック
/code-duplicate --path src/features/new-feature

# 既存コードとの類似性確認
/code-duplicate --threshold 80
```

## 関連コマンド

- `/code-review` - コード品質の総合的なレビュー
- `/code-review-suggest` - 重複コードの具体的な改善案
- `/task` - リファクタリングタスクの計画と実行
- `/claude-learnings` - リファクタリングで得た知見の記録

## ツール: similarity-ts

### 概要
[similarity](https://github.com/mizchi/similarity) - 高性能な重複コード検出ツール
- Abstract Syntax Tree (AST) を使用した正確な比較
- 関数や類似コードパターンの検出
- クロスファイル比較サポート
- AI向けの出力フォーマット
- ゼロコンフィグで動作

### インストール
```bash
# TypeScript/JavaScript用
cargo install similarity-ts
```

### 使用方法
```bash
# カレントディレクトリをスキャン
similarity-ts .

# 類似度の閾値を設定（0.0-1.0）
similarity-ts . --threshold 0.8

# 特定のディレクトリをスキャン
similarity-ts src --threshold 0.8

# コードを含めて出力
similarity-ts . --threshold 0.8 --print

# 最小行数を指定（デフォルト: 3）
similarity-ts . --min-lines 10

# 特定のディレクトリを除外
similarity-ts . --exclude node_modules --exclude .next
```

### 主なオプション
- `--threshold`: 類似度の閾値（0.0-1.0、デフォルト: 0.87）
- `--min-lines`: 検出対象の最小行数（デフォルト: 3）
- `--print`: 検出されたコードを出力に含める
- `--exclude`: 除外するディレクトリパターン
- `--extensions`: チェック対象の拡張子

## 注意事項
- **段階的実施**: 大規模なリファクタリングは段階的に実施
- **テストの確保**: リファクタリング前に十分なテストカバレッジを確保
- **チーム合意**: 大きな構造変更は事前にチームと相談
- **パフォーマンス**: 重複削除により若干のオーバーヘッドが発生する可能性
- **ブランチ戦略**: 必ず新規ブランチで作業し、小さなPRに分割