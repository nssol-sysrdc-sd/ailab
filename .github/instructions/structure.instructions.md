---
applyTo: "**/*"
---

# リポジトリ構造

このファイルは生成AIへの指示を効率化させるためのリポジトリ全体構造の説明です。

```
ailab/
├── .git/
├── .github/
│   ├── copilot-instructions.md
│   ├── instructions/
│   │   └── structure.instructions.md  # このファイル
│   ├── reviews/
│   │   ├── get_pr_result.sh           # PRの情報と差分を取得するスクリプト
│   │   └── install_pr_review.sh
│   └── workflows/
├── .gitignore
├── .mcp.json
├── .vscode/
├── CLAUDE.md
├── docs/
│   ├── copilot/
│   │   ├── claude-code-actions-issue-update.png
│   │   ├── claude-code-actions.md
│   │   ├── instructions-tools.md
│   │   └── instructions.md
│   ├── product/
│   │   └── prd.md
│   └── report/
│       └── Monthly-202506.md
└── terraform/
    ├── environment/
    │   ├── main.tf
    │   └── provider.tf
    └── modules/
        ├── bedrock/
        │   ├── logging.tf
        │   ├── outputs.tf
        │   ├── policy.tf
        │   └── variables.tf
        └── iam/
            ├── main.tf
            ├── outputs.tf
            └── variables.tf
```

## 主要ディレクトリの説明

- `.github/`: GitHub関連の設定ファイルやワークフローを格納
  - `reviews/`: PRレビュー自動化のためのスクリプト
  - `workflows/`: GitHub Actionsのワークフロー定義
- `docs/`: プロジェクトに関するドキュメント
  - `copilot/`: GitHub Copilotに関する資料
  - `product/`: 製品仕様に関するドキュメント
  - `report/`: 月次レポートなど
- `terraform/`: Terraformコードを格納
  - `environment/`: 環境固有の設定
  - `modules/`: 再利用可能なTerraformモジュール

