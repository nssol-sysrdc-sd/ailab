# CLAUDE.md

あなたは日本語話者の開発者と協働するため、回答を日本語で記述してください。

## プロジェクト概要

このリポジトリは、生成 AI のさまざまな機能を検証することを目的にしており、下記の検証を行なっている

- GitHub Copilot を活用するときのベストプラクティス
- Claude Code を使用した CLI ベースでのエージェント活用
- Claude Code Actions を活用した自律エージェントの検証

## プロジェクト構成

このプロジェクトは Gradle マルチプロジェクト構成を採用しています。

### マルチプロジェクト構成

```
ailab-with-ddd/ (ルートプロジェクト)
└── apps/
    └── research/
        └── soap-service/ (サブプロジェクト)
```

`settings.gradle.kts` では以下のように設定されています。

```gradle-kotlin-dsl
rootProject.name = "ailab-with-ddd"

include(":soap-service")
project(":soap-service").projectDir = file("apps/research/soap-service")
```

### ビルドコマンド

```bash
# プロジェクト全体のビルド
./gradlew build

# プロジェクト全体のテスト
./gradlew test

# 特定のサブプロジェクトのビルド
./gradlew :apps:research:soap-service:build

# サブプロジェクトのSpring Bootアプリケーション起動
./gradlew :apps:research:soap-service:bootRun
```

## 開発ツール

### フロントエンドツール

フロントエンドの UI を開発する際は、遠慮を行わず、あなたの限界にチャレンジしてください。

### バックエンドツール

Java を使用してバックエンドのコードを記述する場合、テスト駆動開発に従ってください。
コード生成を行う場合は、常に対応するユニットテストを生成し、必ずテストが PASS することを確認して作業してください。

```bash
# Build the project (when Java code is added)
./gradlew build

# Clean build artifacts
./gradlew clean

# Run tests (when tests are added)
./gradlew test
```

### IaC ツール

Terraform のコードを生成・修正を行なった場合は、必ず以下のコマンドを実行して、コードが正しく動作することを確認してください。

```bash
# Initialize Terraform
cd terraform/environment
terraform init

# Plan infrastructure changes
terraform plan
```

## ドキュメント作成

開発を行う際に、タスク分解を行なってください。
最後のタスクに、必ずドキュメント修正タスクを追加し、 CLAUDE.md を修正してください。

### Markdown を記述する際の基本設定

#### 句点を使用しない

Markdown を記述する際は、1 文ごとに完結な説明をするようにし、文末には句点「。」を使用しないでください

#### 過剰な装飾をしない

例えば箇条書きを行う際は、ボールド指定による太文字指定は指示された時のみ行う

```markdown
NG パターン

- **重要な発見**: 説明文

OK パターン

- 重要な発見: 説明文
```
