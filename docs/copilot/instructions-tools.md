# GitHub Copilot Chat の Instructions ファイルとツールの連携に関する挙動調査

## 調査概要

GitHub Copilot Chat における Instructions ファイルの挙動について調査する。

## 検証日時

2025 年 5 月 24 日
VSCode v1.100

### 調査項目

1. `applyTo` glob パターン: 適用ファイルの決定方法
2. ファイル参照機能: 他ファイルの参照・読み込みトリガーの可否と方法
3. 複数ファイル読み込み: グローバル、ローカル、ファイルタイプ特化型の同時存在時の挙動
4. ツール利用指示: Instructions ファイル内からの特定ツール（例: `read_file`）の利用指示
5. 制限と回避策: VS Code v1.100 における自動連鎖読み込みの制限と対処法

## 設定環境

### VSCode 設定 (.vscode/settings.json の想定)

```json
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    "~/Library/Application Support/Code/User/prompts": true
  }
}
```

### 検証用のファイル

検証後のファイルを記述している。ファイルを読み込み指示は read_file ツール以外にも、GitHub Copilot で使用することが可能な #file 構文も検証を実施している。

`.github/instructions/java.test.instructions.md`

```markdown
---
applyTo: "**/*Test.java"
---

【必須処理】このインストラクションが適用された場合、必ず以下を実行してください：

1. read_file ツールを使用して test.basics.md を読み込む
2. 読み込んだテスト原則をテスト実装に適用する

ファイルパス: ./.github/instructions/test.basics.md
```

`.github/instructions/test.basics.md`

```markdown
このファイルを読み込んだ場合、読み込んだことをユーザーに知らせるために「installing local test principles ...」と回答してください
```

## 実験結果

### 1. `applyTo` glob パターンの挙動

基本動作

- glob パターンで instruction ファイルの適用対象を制御
- パターンは対象ファイルのパス全体で評価

パターン別の動作

| パターン概要 | 設定内容                       | 反映結果                                       |
| ------------ | ------------------------------ | ---------------------------------------------- |
| 複数種別混在 | `"**/*.test.ts,**/*Test.java"` | `SampleTest.java` に適用されない               |
| 単一パターン | `"**/*Test.java"`              | `SampleTest.java` に正常適用                   |
| 包括パターン | `"**/*Test*.java"`             | ファイル名に「Test」含む Java ファイルにマッチ |

推奨事項

- 単一のファイル種別に特化したパターンが確実
- 複数種別混在よりも個別の instruction ファイル作成を推奨

### 2. Instruction ファイルからの他ファイル参照とツール利用

`#file:` 構文

- 記述方法: `#file:./relative/path/to/another.md`
- 動作: 他ファイルの内容を読み込みトリガー
- 仕組み: Copilot が内部的にファイル内容を取得してコンテキストに追加

`read_file` ツールの明示指示

- instruction 内でエージェントにツール使用を指示可能
- エージェントは指示に従ってツールを実行

ツール呼び出しの遅延

- 重要: ツール実行完了後に内容読み込み
- 自動的な内容アタッチは行われない
- 1 回分の遅延が発生
- 即座の参照が必要な場合は直接記述を推奨

モジュール化のメリットと注意点

メリット

- 共通部分の別ファイル切り出しが可能
- 再利用性の向上
- 保守性の向上（変更箇所の集約）

注意点

- ツール実行完了後に内容読み込みされる
- 実行タイミングを考慮した設計が重要
- 即座の参照が必要な場合は直接記述を推奨

## 結論

### ファイル適用制御

- `applyTo` glob パターンで柔軟な適用対象制御が可能
- 単一パターンの方が確実性が高い

### ファイル参照・モジュール化

- `#file:` 構文による他ファイル内容の読み込み可能
- `read_file` ツール指示でエージェントに明示的なファイル読み込みを指示可能
- 指示のモジュール化と共通化が実現可能

### 複数ファイル読み込み

- 条件に合致する複数の instruction ファイルが同時読み込み
- 競合しない範囲で全ての指示が適用

### VS Code v1.100 の制限

- instruction ファイル間の自動連鎖読み込み機能は限定的
- 複雑なルールセットは以下の方法で管理
  - ファイル内での指示集約
  - `#file:` 構文による内容参照
  - ツール呼び出しによる動的読み込み
