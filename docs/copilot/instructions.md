# GitHub Copilot Chat の Instructions 設定の挙動観察

## 調査概要

GitHub Copilot Chat における Instructions ファイルの重複読み込み挙動について調査を実施した。
特に、同じ名前のインストラクションファイルが複数の場所に配置された場合の動作を検証。

## 検証日時

2025 年 5 月 24 日
VSCode v1.100

## 設定環境

### VSCode 設定 (.vscode/settings.json)

```json
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    "~/Library/Application Support/Code/User/prompts": true
  }
}
```

### 対象ファイル

- **グローバル**: `~/Library/Application Support/Code/User/prompts/personal.instructions.md`
- **ローカル**: `.github/instructions/personal.instructions.md` (※ファイル名の typo あり)

## 実験結果

### 1. 読み込み確認メッセージ

両方のファイルに以下の通知メッセージを設定:

- グローバル: `installing global personality ...`
- ローカル: `installing local personality ...`

### 2. 観察された挙動

Copilot Chat 起動時に以下のメッセージが表示:

```
installing global personality ... installing local personality ...
```

### 3. 結論

- **両方の Instructions ファイルが読み込まれている**
- 「どちらか一方だけが有効」ではなく、**両方が合成されて適用される**
- 通知メッセージも両方実行される

## トークン消費への影響

- 同じ内容のインストラクションファイルが複数存在する場合、両方の内容がプロンプトに含まれる
- 重複した内容分だけトークン消費が増加する可能性がある
- 無駄なトークン消費を避けるには、重複ファイルの削除またはリネームが推奨

## 推奨運用方法

### パターン 1: 完全分離

- グローバル: 全プロジェクト共通のベース設定
- ローカル: プロジェクト固有の追加設定
- ファイル名を変えて重複を避ける

### パターン 2: 単一利用

- グローバルまたはローカルのどちらか一方のみを使用
- 不要な方のファイルを削除またはリネーム

## 注意点

- 同名ファイルでも両方読み込まれるため、意図しない重複適用に注意
- 設定の優先順位は存在するが、完全に上書きされるわけではない
- デバッグ時は通知メッセージで読み込み状況を確認可能

## 参考文献

- https://code.visualstudio.com/updates/v1_100
- https://code.visualstudio.com/docs/copilot/copilot-customization#_custom-instructions
- https://code.visualstudio.com/blogs/2025/02/24/introducing-copilot-agent-mode
