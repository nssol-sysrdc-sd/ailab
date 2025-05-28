#!/bin/bash

# インストール先のディレクトリを指定
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/get_pr_result.sh"

# インストール先ディレクトリが存在しないなら作成
if [ ! -d "$INSTALL_DIR" ]; then
  mkdir -p "$INSTALL_DIR"
  echo "インストールディレクトリ $INSTALL_DIR を作成しました"
fi

# コマンド名を定義
COMMAND_NAME="pr-review"

# シンボリックリンクの作成
ln -sf "$SCRIPT_PATH" "$INSTALL_DIR/$COMMAND_NAME"
chmod +x "$SCRIPT_PATH"

echo "インストールが完了しました"
echo "コマンド '$COMMAND_NAME' は $INSTALL_DIR にインストールされました"

# PATHに追加するための提案
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  echo ""
  echo "注意: $INSTALL_DIR はPATHに含まれていないようです"
  echo "以下の行をあなたの ~/.bashrc または ~/.bash_profile に追加してください:"
  echo ""
  echo "  export PATH=\$PATH:$INSTALL_DIR"
  echo ""
  echo "その後、新しいターミナルを開くか以下のコマンドを実行してください:"
  echo ""
  echo "  source ~/.bashrc  # または source ~/.bash_profile"
fi
