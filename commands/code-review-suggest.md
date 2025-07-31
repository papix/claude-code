# Suggest review focus points for current branch

現在のブランチ（mainブランチの場合は最新のコミット）をレビューする際に、重点的に確認すべきファイルやコード箇所を提案します。実際のコードスニペットも表示可能です。

## 使用方法
```
/review-suggest [--no-code]
```

### オプション
- `--no-code`: コードスニペットの表示を無効化（デフォルトは表示）

## 分析基準

### 1. 重要度の判定基準
- **セキュリティ関連**: 認証・認可、入力検証、データアクセス
- **ビジネスロジック**: トランザクション処理、状態管理、計算処理
- **データベース操作**: スキーマ変更、クエリパフォーマンス、データ整合性
- **外部連携**: API呼び出し、外部サービス連携
- **複雑な処理**: 条件分岐が多い、ループ処理、再帰処理

### 2. リスクレベル
- 🔴 **高リスク**: セキュリティ、データ破壊、サービス停止の可能性
- 🟠 **中リスク**: パフォーマンス劣化、エラー処理、UX影響
- 🟡 **低リスク**: コード品質、保守性、将来の拡張性

### 3. レビューポイントの分類
- **必須確認**: セキュリティ、データ整合性に関わる箇所
- **重点確認**: ビジネスロジック、エラーハンドリング
- **推奨確認**: コード品質、パフォーマンス最適化
- **参考確認**: スタイル、命名規則、ドキュメント

## 実行手順
1. 現在のブランチと変更ファイルを取得
2. 各ファイルの変更内容を分析
3. リスクレベルと重要度を評価
4. レビューポイントを整理して出力
5. オプションに応じてコードスニペットを表示

## 出力形式

```
## 🔍 レビュー重点確認ポイント

### 📊 変更概要
- ブランチ: feature/xxx
- 変更ファイル数: X個
- 追加行数: +XXX / 削除行数: -XXX

### 🔴 必須確認事項（高リスク）

#### 1. 認証・認可の実装
- **ファイル**: `src/actions/xxx.ts`
- **行番号**: L45-L52
- **確認ポイント**: 
  - 権限チェックが適切に実装されているか
  - 認証エラーの処理が統一されているか
- **想定リスク**: 不正アクセス、データ漏洩

**📝 変更コード:**
```typescript
// 変更前
const user = await auth();
if (!user) throw new Error("Unauthorized");

// 変更後
const session = await auth();
if (!session?.user) {
  throw new AuthError("認証が必要です");
}
const hasPermission = await checkPermission(session.user.id, resourceId);
if (!hasPermission) {
  throw new AuthError("権限がありません");
}
```

### 🟠 重点確認事項（中リスク）

#### 1. トランザクション処理
- **ファイル**: `src/lib/transactions/xxx.ts`
- **行番号**: L120-L145
- **確認ポイント**:
  - エラー時のロールバック処理
  - 同時実行時の競合状態

**📝 変更コード:**
```typescript
await db.transaction(async (tx) => {
  try {
    const result = await tx.update(conversations)
      .set({ status: 'processing' })
      .where(eq(conversations.id, conversationId));
    
    // 新規追加: 競合チェック
    if (result.rowCount === 0) {
      throw new ConflictError("対象の会話が見つからないか、既に処理中です");
    }
    
    await processConversation(tx, conversationId);
  } catch (error) {
    // ロールバックは自動的に行われる
    throw error;
  }
});
```
  
### 🟡 推奨確認事項（低リスク）

#### 1. パフォーマンス最適化
- **ファイル**: `src/lib/services/xxx.ts`
- **行番号**: L80-L95
- **確認ポイント**: N+1問題の可能性

**📝 変更コード:**
```typescript
// 潜在的なN+1問題
const conversations = await db.select().from(conversations);
for (const conv of conversations) {
  const users = await db.select()
    .from(conversationUsers)
    .where(eq(conversationUsers.conversationId, conv.id));
  conv.users = users;
}
```

### 💡 レビュー効率化のヒント
1. セキュリティ関連から確認を開始
2. データフローを追跡して整合性を確認
3. エッジケースとエラー処理を重点的に確認
4. コードスニペットで実際の変更内容を確認しながらレビュー

### ⚙️ コマンドオプション
- コードスニペットが不要な場合は `--no-code` オプションを使用してください
```

## よくある使用シーン

### コードレビュー後の改善
```bash
# /code-review で問題点を確認後
/code-review-suggest

# セキュリティ問題の具体的な修正案
/code-review-suggest --focus security
```

### リファクタリング作業
```bash
# パフォーマンス最適化の提案
/code-review-suggest --focus performance

# コードの可読性向上
/code-review-suggest --focus readability
```

### チーム開発での活用
```bash
# コーディング規約に沿った改善案
/code-review-suggest --focus best-practices

# 型安全性の向上
/code-review-suggest --focus type-safety
```

## 関連コマンド

- `/code-review` - 問題点の指摘（先に実行推奨）
- `/code-duplicate` - 重複コードの検出とリファクタリング
- `/task` - 提案された改善を実装するタスクの作成
- `/claude-learnings` - 改善パターンの記録

## 注意事項
- 提案されたコードはそのまま使用できるように作成されますが、必ずテストを行ってください
- 大規模なリファクタリングは段階的に実施することを推奨します
- コードのコンテキストを完全に理解できない場合は、安全側に倒した提案を行います
