# EduTech Pro - 次世代オンライン学習プラットフォーム

検証のためにドメイン駆動開発でプロダクトを作成しながら、GitHub Copilot の機能を活用していく。
このファイルでは、上記目的のためのプロダクト要件定義書（PRD）を示す。

---

## 🎯 プロジェクト概要

### ビジョン

EduTech Pro は、教育機関と企業向けの包括的なオンライン学習プラットフォームです。従来の一方向的な学習から、個別最適化された適応型学習体験への転換を目指します。

### ビジネス目標

- 学習完了率を現在の業界平均 15%から 60%以上に向上
- 企業研修市場でのシェア獲得（3 年で 10%）
- 教育機関向け SaaS として年間経常収益（ARR）$100M の達成

### 主要な差別化要因

1. AI 駆動の個別学習パス最適化
2. リアルタイムのスキル評価と認定
3. 企業の人材開発システムとのシームレスな統合
4. グローバル認証機関との連携

---

## 👥 ステークホルダー

### 主要ユーザー

1. **学習者（Learner）**

   - 個人学習者：スキルアップを目指す社会人
   - 企業所属学習者：企業研修の一環として利用
   - 学生：大学や専門学校の正規課程として利用

2. **講師・コンテンツ作成者（Instructor）**

   - 個人講師：フリーランスの専門家
   - 企業内講師：社内研修担当者
   - 教育機関講師：大学教授、専門学校講師

3. **管理者（Administrator）**

   - 企業研修管理者：従業員の学習進捗を管理
   - 教育機関管理者：カリキュラム管理、成績管理
   - プラットフォーム管理者：システム全体の運用

4. **外部システム**
   - 認証機関：修了証の検証、認定
   - 決済プロバイダー：Stripe、PayPal 等
   - 企業 HR システム：SAP SuccessFactors、Workday 等

---

## 📋 機能要件

### 1. アカウント・認証管理

**学習者登録**

- 個人アカウント：メールアドレス、ソーシャルログイン（Google、LinkedIn）対応
- 企業アカウント：シングルサインオン（SSO）、SAML 2.0 対応
- 教育機関アカウント：学籍番号との連携、LTI（Learning Tools Interoperability）対応

**認証要件**

- 二要素認証（2FA）必須（企業・教育機関アカウント）
- パスワードポリシー：最低 12 文字、複雑性要件
- セッション管理：非アクティブ 30 分でタイムアウト

### 2. コース管理

**コース作成**

- コース基本情報：タイトル、説明、学習目標、前提知識、想定学習時間
- モジュール構成：階層構造（コース > セクション > レッスン）
- コンテンツタイプ：動画、テキスト、インタラクティブ演習、ダウンロード資料
- 公開設定：下書き、レビュー中、公開、アーカイブ

**コース公開プロセス**

1. 講師がコースを作成し、レビュー申請
2. 品質保証チームが内容をレビュー（最低 3 営業日）
3. 必要に応じて修正要求
4. 承認後、指定日時に自動公開
5. 公開後も定期的な品質監査（3 ヶ月ごと）

**前提条件管理**

- 必須前提コース：特定コースの修了が必要
- 推奨前提知識：スキルレベルの提示
- 診断テスト：前提知識の確認テスト

### 3. 学習体験

**受講登録**

- 個人購入：クレジットカード、PayPal、銀行振込
- 企業一括購入：請求書払い、年間契約
- 無料体験：各コース最初の 2 レッスンまで

**学習進捗管理**

- レッスン完了条件：動画は 80%以上視聴、演習は正解率 70%以上
- 進捗の自動保存：5 秒ごと
- 複数デバイス間での進捗同期

**適応型学習**

- 学習速度の分析：平均視聴速度、繰り返し視聴箇所
- 理解度の推定：演習の正答率、回答時間
- 個別最適化：追加演習の提案、スキップ可能セクションの提示

### 4. 評価・課題管理

**課題タイプ**

- 自動採点課題：選択式、穴埋め、コーディング課題
- 手動採点課題：レポート、プロジェクト成果物
- ピアレビュー課題：相互評価（最低 3 名）

**提出管理**

- 提出期限：厳格期限と猶予期限（自動 10%減点）
- 再提出：最大 3 回まで（最高得点を採用）
- 剽窃チェック：Turnitin との連携

**成績計算**

- 重み付け：出席点 10%、課題 40%、中間試験 20%、期末試験 30%
- 成績カーブ：相対評価オプション
- 追試・再試験：1 回まで可能（上限 80 点）

### 5. 修了証・認定管理

**修了条件**

- 全レッスンの完了（完了率 100%）
- 総合成績 70%以上
- 最終プロジェクトの合格

**修了証発行**

- デジタル修了証：ブロックチェーン検証可能
- 印刷用 PDF：セキュリティ透かし入り
- 第三者検証：固有 URL、QR コード

**外部認定連携**

- 業界認定：CompTIA、AWS、Google 等
- 大学単位：提携大学での単位認定
- 継続教育単位（CEU）：専門資格の更新要件

### 6. 支払い・サブスクリプション

**価格モデル**

- 個人向け：コース単体購入（$49-$499）、月額サブスクリプション（$29/月）
- 企業向け：席数ライセンス（$99/席/年）、使い放題プラン
- 教育機関向け：FTE 学生数ベース、カスタム価格

**動的価格設定**

- 早期割引：公開後 7 日間は 20%オフ
- バンドル割引：3 コース以上で 15%オフ
- 地域別価格：購買力平価に基づく調整
- ロイヤリティ割引：年間$1000 以上購入で翌年 10%オフ

**支払い処理**

- 自動更新：サブスクリプションの自動更新
- 返金ポリシー：購入後 30 日間（進捗率 25%未満）
- 分割払い：6 回まで（金利なし）

### 7. コミュニケーション・サポート

**学習者サポート**

- Q&A フォーラム：コースごと、講師と他の学習者が回答
- 1 対 1 メンタリング：プレミアムプランのみ、月 2 回 30 分
- AI チャットボット：24 時間対応、基本的な質問に回答

**通知システム**

- 期限リマインダー：3 日前、1 日前、当日
- 新コンテンツ通知：フォロー中の講師の新コース
- 成績通知：課題採点完了、修了証発行

---

## 🔧 ビジネスルールと制約

### コース公開ルール

1. 最低 3 時間の学習コンテンツが必要
2. 各モジュールに最低 1 つの確認テストが必須
3. 全体の 60%以上が動画コンテンツである必要がある
4. 最終更新から 1 年以上経過したコースは自動的にアーカイブ

### 受講制限

1. 同時受講可能コース数：
   - 無料プラン：1 コース
   - 基本プラン：3 コース
   - プレミアムプラン：無制限
2. 前提条件を満たさない場合は受講登録不可
3. 企業アカウントは管理者の承認が必要

### 成績・評価ルール

1. 課題の提出期限後は自動的に 0 点
2. 不正行為（剽窃等）が発覚した場合、コース失格
3. 評価に対する異議申し立ては 7 日以内

### 修了証発行ルール

1. 有効期限：発行から 2 年間（更新試験で延長可能）
2. 発行手数料：$25（初回は無料）
3. 不正取得が判明した場合、即座に無効化

### データ保持ポリシー

1. 学習履歴：最終アクセスから 5 年間保持
2. 提出課題：コース終了後 1 年間保持
3. 個人情報：アカウント削除要求から 30 日後に完全削除

---

## 🌍 国際化・ローカライゼーション要件

### 対応言語

- 第 1 フェーズ：英語、日本語、中国語（簡体字）
- 第 2 フェーズ：スペイン語、フランス語、ドイツ語
- コンテンツ言語と UI は独立して設定可能

### 地域別対応

- 通貨：USD、EUR、JPY、CNY（リアルタイムレート変換）
- 日付形式：ISO 8601 準拠、地域別表示
- タイムゾーン：学習者の現地時間で期限管理

### 法規制対応

- GDPR（EU）：明示的な同意、データポータビリティ
- CCPA（カリフォルニア）：販売オプトアウト
- PIPL（中国）：データローカライゼーション
- FERPA（米国教育）：学生記録の保護

---

## 📊 非機能要件

### パフォーマンス

- ページロード時間：3 秒以内（90 パーセンタイル）
- 動画開始時間：クリックから 5 秒以内
- 同時接続数：10 万ユーザー以上
- API 応答時間：200ms 以内（95 パーセンタイル）

### 可用性

- SLA：99.9%（月間 43 分以内のダウンタイム）
- 計画メンテナンス：月 1 回、最大 2 時間（事前通知）
- 災害復旧：RPO 1 時間、RTO 4 時間

### スケーラビリティ

- 水平スケーリング：負荷に応じた自動スケール
- データ成長：年間 100TB 増加に対応
- 将来の拡張：1000 万ユーザー、10 万コースまで

### セキュリティ

- 暗号化：転送時 TLS 1.3、保存時 AES-256
- 認証：OAuth 2.0、SAML 2.0
- 監査ログ：全ての重要操作を記録、1 年間保持
- ペネトレーションテスト：四半期ごと

---

## 📖 ドメイン用語集（ユビキタス言語）

| 用語                               | 定義                                                         | 例・補足                     |
| ---------------------------------- | ------------------------------------------------------------ | ---------------------------- |
| コース（Course）                   | 特定のトピックに関する構造化された学習コンテンツの集合       | 「Java による DDD 実践」など |
| モジュール（Module）               | コース内の大きな学習単位、通常は 1 週間分の学習量            | 「第 3 章：集約の設計」      |
| レッスン（Lesson）                 | モジュール内の最小学習単位、15-30 分で完了可能               | 「3.1 集約とは何か」         |
| 学習パス（Learning Path）          | 特定のスキル習得のために推奨される複数コースの順序付きリスト | 「フルスタック開発者への道」 |
| 受講登録（Enrollment）             | 学習者が特定のコースへのアクセス権を得ること                 | 有料/無料、個人/企業経由     |
| 進捗（Progress）                   | 学習者のコース内での完了状況                                 | 完了率、最終アクセス日時     |
| 課題（Assignment）                 | 学習者の理解度を評価するためのタスク                         | レポート、コーディング課題   |
| 提出物（Submission）               | 学習者が課題に対して提出した成果物                           | ソースコード、PDF ファイル   |
| 評価（Assessment）                 | 提出物に対する採点結果とフィードバック                       | 点数、コメント、ルーブリック |
| 修了証（Certificate）              | コース完了を証明するデジタル/物理的な証明書                  | 修了日、固有 ID、検証 URL    |
| サブスクリプション（Subscription） | 定期支払いによる継続的なアクセス権                           | 月額、年額、企業プラン       |
| ライセンス（License）              | 企業が購入する複数ユーザー向けのアクセス権                   | 100 席、使い放題             |
| 講師（Instructor）                 | コースコンテンツを作成し、学習者をサポートする人             | 個人、企業所属、教育機関     |
| 学習者（Learner）                  | コースを受講する人                                           | 個人、学生、企業研修生       |
| コホート（Cohort）                 | 同じ期間に同じコースを受講する学習者のグループ               | 2024 年春期入学組            |

---

## 🎯 DDD 実装課題

### あなたのタスク

1. **Event Storming の実施**

   - 上記の PRD を基に、ビッグピクチャー Event Storming を実施
   - 主要なドメインイベントを識別（最低 20 個）
   - イベントの時系列と因果関係を明確化

2. **境界づけられたコンテキストの識別**

   - Event Storming の結果から境界を発見
   - 各コンテキストの責任範囲を定義
   - Context Map を作成し、コンテキスト間の関係を図示

3. **集約の設計**

   - 各コンテキスト内の集約を識別
   - 集約のルート、エンティティ、値オブジェクトを定義
   - 不変条件とビジネスルールを明確化

4. **主要な集約の実装**

   - 最も複雑な 2 つの集約を選択
   - Java/TypeScript で実装（両方でも可）
   - ドメインイベントの発行を含む

5. **統合シナリオの設計**
   - 「学習者がコースを完了し修了証を取得する」シナリオ
   - 複数のコンテキストをまたがる処理フローを設計
   - 結果整合性とサーガパターンの適用

### 評価基準

- ドメインの深い理解が反映されているか
- 境界づけられたコンテキストが適切に分離されているか
- ビジネスルールが集約内に適切にカプセル化されているか
- ユビキタス言語が一貫して使用されているか
- 実装が DDD の原則に従っているか

### 提出物

1. Event Storming の成果物（写真またはデジタルボード）
2. Context Map（図とマークダウンでの説明）
3. 各コンテキストのドメインモデル図
4. 主要な集約の実装コード
5. 統合シナリオのシーケンス図とコード
6. 設計判断の根拠を説明したドキュメント（A4 3-5 ページ）

---

## 💡 ヒント

- PRD には意図的に曖昧な部分や矛盾が含まれています。これは実際のプロジェクトを模倣したものです
- ドメインエキスパートへの質問を想定し、仮説を立てて進めてください
- 最初から完璧を目指さず、イテレーティブに改善することを推奨します
- 他のチームメンバーとの議論を通じて、理解を深めてください
