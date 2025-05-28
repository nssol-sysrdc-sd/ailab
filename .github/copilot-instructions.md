# システムインストラクション（開始プロンプト）

このセクションでは、システムインストラクションとして「/review」コマンドの動作を定義します。

## /review <language> <prNumber>

### 言語オプション

- `java`: Java コードのレビュー
 - `tf`: Terraform コードのレビュー

### 動作フロー

1. ユーザーが `/review [language] [prNumber]` コマンドを入力すると、レビュープロセスが開始します

2. まずは `.github/reviews` ディレクトリ全体をリストアップし、存在しているファイルを確認します

3. システムは `.github/reviews/get_pr_result.sh <prNumber>` を実行し、PR情報と差分内容を取得します
   - PR内容は `.github/reviews/pr_content.md` に保存されます

4. システムは `.github/reviews/pr_content.md` ファイルを参照し、PR情報と差分内容を取得します

5. PR情報と差分内容を確認した後、必要に応じてソースコードを探索してレビューに必要なファイルを読み込みます

6. 指定された言語に基づいて、対応するコーディングプラクティスとレビューペルソナを適用します
   - レビューペルソナは常に `.github/reviews/reviewer.md` を参照する
   - 言語に `java` が指定された場合は `.github/reviews/coding_practice_java.md` を参照する
   - 言語に `tf` が指定された場合は `.github/reviews/coding_practice_tf.md` を参照する

7. 包括的なコードレビューを実行します
   - 必要に応じて、ソースコードを探索してレビューに必要なファイルを読み込む
   - レビュー結果は `.github/reviews/result_<prNumber>.md` というファイルを作成し、下記内容を記載する
     - レビューのサマリー（良い点と改善点）
     - 詳細な所見（優先度別）
     - 提案された改善案とコード例（必要に応じて）
     - 総合評価と次のステップの提案
   - レビュー結果は作成したファイルにのみ配置し、チャットの返信ではファイルを作成したことのみを通知する

8. レビューは常に「コードの全体的な健全性を向上させる」という目標を念頭に置き、完璧さではなく継続的な改善を重視します

### 実行例

ユーザー: `/review java 123`
→ Javaコードレビュープラクティスとレビューペルソナを適用し `.github/reviews/pr_content.md` のJavaコードをレビュー

ユーザー: `/review tf 123`
→ Terraform AWSプロバイダーのコードレビュープラクティスとレビューペルソナを適用し `.github/reviews/pr_content.md` のTerraformコードをレビュー