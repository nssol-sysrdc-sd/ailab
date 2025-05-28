#!/bin/bash

# このスクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# PR番号とリポジトリを引数から取得する
PR_NUMBER=$1
REPO=$2

if [ -z "$PR_NUMBER" ]; then
  echo "Usage: $0 <PR_NUMBER> [OWNER/REPO]"
  exit 1
fi

# リポジトリ指定がある場合の引数を構築
REPO_ARG=""
if [ -n "$REPO" ]; then
  REPO_ARG="--repo $REPO"
fi

# レビュー実施用のディレクトリが必要なければ削除や変更が可能です
# 現在のカレントディレクトリを使用するように修正
# mkdir -p ~/projects/idauthgw/.shimokawa/reviews

# PRの情報を抽出する
PR_TITLE=$(gh pr view $PR_NUMBER $REPO_ARG --json title -q '.title')
PR_NUMBER=$(gh pr list $REPO_ARG --search "$PR_TITLE" --json number -q '.[].number')

# 一時ファイル用のディレクトリを作成
OUTPUT_DIR="${SCRIPT_DIR}"
TEMP_DIFF_FILE="${OUTPUT_DIR}/pr_diff.txt"
OUTPUT_FILE="${OUTPUT_DIR}/pr_content.md"

# PRの差分を取得
gh pr diff $PR_NUMBER $REPO_ARG > "$TEMP_DIFF_FILE"

# 差分とPR情報を1つのファイルにまとめる
{
  echo "# PRタイトル"
  echo "$PR_TITLE"
  echo ''
  echo "# PR番号"
  echo "$PR_NUMBER"
  echo ''
  if [ -n "$REPO" ]; then
    echo "# リポジトリ"
    echo "$REPO"
  fi
  echo ''
  echo "# 差分"
  echo '```diff'
  cat "$TEMP_DIFF_FILE"
  echo '```'
} > "$OUTPUT_FILE"

echo "PR情報と差分を $OUTPUT_FILE に保存しました"
rm -f "$TEMP_DIFF_FILE"