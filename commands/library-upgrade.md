# Safely upgrade project dependencies

## 概要
プロジェクトの依存ライブラリを安全にアップグレードします。各ライブラリを個別にアップグレードし、テストを実行して安定性を確保します。

## 使用方法
```
/library-upgrade
```

## 実行内容
1. **アップグレード可能なライブラリの調査**
   - `npm outdated` または `yarn outdated` を実行
   - Major/Minor/Patch更新を分類してリスト化

2. **新規ブランチの作成**
   - mainブランチから `chore/library-upgrade-YYYYMMDD` ブランチを作成

3. **個別アップグレードの実施**
   - 各ライブラリを1つずつアップグレード
   - アップグレード後に以下を実行：
     - `npm run typecheck` (存在する場合)
     - `npm test` (存在する場合)
     - `npm run build` (存在する場合)
   - 問題なければコミット

4. **アップグレード結果の報告**
   - 成功/失敗したアップグレードをまとめて報告

## 出力形式
```
## 📦 ライブラリアップグレード分析

### アップグレード可能なライブラリ

#### 🔴 Major Updates (破壊的変更の可能性)
- react: 17.0.2 → 18.2.0
  - ⚠️ React 18の新機能と破壊的変更に注意
- typescript: 4.9.5 → 5.3.3
  - ⚠️ 新しい型チェックによりエラーが発生する可能性

#### 🟠 Minor Updates
- @types/node: 18.11.9 → 18.19.10
- next: 13.4.0 → 13.5.6

#### 🟢 Patch Updates  
- prettier: 2.8.1 → 2.8.8
- eslint: 8.30.0 → 8.30.1

### アップグレード実行結果
✅ prettier: 2.8.1 → 2.8.8 (成功)
✅ eslint: 8.30.0 → 8.30.1 (成功)
❌ react: 17.0.2 → 18.2.0 (失敗: テストエラー)
```

## よくある使用シーン

### 定期的なメンテナンス
```bash
# 月次でのライブラリ更新
/library-upgrade

# セキュリティアップデートの確認と適用
/library-upgrade
```

### 新機能開発前の準備
```bash
# プロジェクト開始前に最新版にアップデート
/library-upgrade

# 特定のライブラリの新機能を使いたい時
/library-upgrade
```

### セキュリティ対応
```bash
# npm auditで脆弱性が報告された後
/library-upgrade

# Dependabotからのアラート対応
/library-upgrade
```

### 大規模アップデート計画
```bash
# メジャーバージョンアップの影響調査
/library-upgrade

# 段階的なアップグレード戦略の立案
/library-upgrade
```

## 関連コマンド

- `/task` - アップグレード作業の計画と実行
- `/code-review` - アップグレード後のコード変更確認
- `/discussion` - メジャーアップデートの是非を議論
- `/claude-learnings` - アップグレードで得た知見の記録

## 注意事項
- **Major Updates**: 破壊的変更を含む可能性があるため、CHANGELOG.mdやマイグレーションガイドを必ず確認
- **依存関係の競合**: 複数のライブラリが相互に依存している場合は、まとめてアップグレードが必要な場合がある
- **ロックファイル**: package-lock.jsonやyarn.lockの変更も必ずコミットに含める
- **テスト環境**: CI/CDパイプラインでの動作確認も推奨