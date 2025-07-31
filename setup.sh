#!/bin/bash
# Claude commands と CLAUDE.md のシンボリックリンクをセットアップするスクリプト

# 色付き出力用の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# スクリプトのディレクトリを取得（リポジトリのルート）
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMMANDS_DIR="${SCRIPT_DIR}/commands"
CLAUDE_COMMANDS_PATH="$HOME/.claude/commands"
CLAUDE_MD_PATH="$HOME/.claude/CLAUDE.md"
CLAUDE_GLOBAL_MD_PATH="${SCRIPT_DIR}/CLAUDE.global.md"

echo -e "${BLUE}=== Claude セットアップスクリプト ===${NC}"
echo -e "${BLUE}リポジトリパス: ${SCRIPT_DIR}${NC}"
echo ""

# ~/.claude ディレクトリが存在しない場合は作成
if [ ! -d "$HOME/.claude" ]; then
    echo -e "${YELLOW}~/.claude ディレクトリが存在しません。作成します...${NC}"
    mkdir -p "$HOME/.claude"
    echo -e "${GREEN}✓ ~/.claude ディレクトリを作成しました${NC}"
fi

echo -e "${BLUE}[1/2] ~/.claude/commands のセットアップ${NC}"
echo ""

# ~/.claude/commands の状態を確認
if [ -L "$CLAUDE_COMMANDS_PATH" ]; then
    # シンボリックリンクの場合
    LINK_TARGET="$(readlink "$CLAUDE_COMMANDS_PATH")"
    if [ "$LINK_TARGET" = "$COMMANDS_DIR" ]; then
        echo -e "${GREEN}✓ すでに正しいシンボリックリンクが設定されています${NC}"
        echo -e "  リンク先: $LINK_TARGET"
    else
        echo -e "${YELLOW}⚠ シンボリックリンクが存在しますが、別の場所を指しています${NC}"
        echo -e "  現在のリンク先: $LINK_TARGET"
        echo -e "  期待するリンク先: $COMMANDS_DIR"
        echo ""
        read -p "既存のシンボリックリンクを更新しますか？ (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$CLAUDE_COMMANDS_PATH"
            ln -s "$COMMANDS_DIR" "$CLAUDE_COMMANDS_PATH"
            echo -e "${GREEN}✓ シンボリックリンクを更新しました${NC}"
        else
            echo -e "${YELLOW}処理を中断しました${NC}"
            exit 1
        fi
    fi
elif [ -d "$CLAUDE_COMMANDS_PATH" ]; then
    # ディレクトリの場合
    if [ -z "$(ls -A "$CLAUDE_COMMANDS_PATH")" ]; then
        # 空のディレクトリ
        echo -e "${YELLOW}~/.claude/commands は空のディレクトリです${NC}"
        echo "空のディレクトリを削除してシンボリックリンクを作成します..."
        rmdir "$CLAUDE_COMMANDS_PATH"
        ln -s "$COMMANDS_DIR" "$CLAUDE_COMMANDS_PATH"
        echo -e "${GREEN}✓ シンボリックリンクを作成しました${NC}"
    else
        # ファイルが存在するディレクトリ
        echo -e "${RED}✗ ~/.claude/commands にファイルが存在します${NC}"
        echo -e "${RED}  手動でバックアップを取ってから再度実行してください${NC}"
        echo ""
        echo "以下のファイルが見つかりました:"
        ls -la "$CLAUDE_COMMANDS_PATH"
        exit 1
    fi
elif [ -f "$CLAUDE_COMMANDS_PATH" ]; then
    # 通常のファイルの場合
    echo -e "${RED}✗ ~/.claude/commands は通常のファイルです${NC}"
    echo -e "${RED}  手動で確認してから再度実行してください${NC}"
    exit 1
else
    # 存在しない場合
    echo -e "${YELLOW}~/.claude/commands が存在しません${NC}"
    echo "シンボリックリンクを作成します..."
    ln -s "$COMMANDS_DIR" "$CLAUDE_COMMANDS_PATH"
    echo -e "${GREEN}✓ シンボリックリンクを作成しました${NC}"
fi

echo ""
echo -e "${BLUE}[2/2] ~/.claude/CLAUDE.md のセットアップ${NC}"
echo ""

# ~/.claude/CLAUDE.md の状態を確認
if [ -L "$CLAUDE_MD_PATH" ]; then
    # シンボリックリンクの場合
    LINK_TARGET="$(readlink "$CLAUDE_MD_PATH")"
    if [ "$LINK_TARGET" = "$CLAUDE_GLOBAL_MD_PATH" ]; then
        echo -e "${GREEN}✓ すでに正しいシンボリックリンクが設定されています${NC}"
        echo -e "  リンク先: $LINK_TARGET"
    else
        echo -e "${YELLOW}⚠ シンボリックリンクが存在しますが、別の場所を指しています${NC}"
        echo -e "  現在のリンク先: $LINK_TARGET"
        echo -e "  期待するリンク先: $CLAUDE_GLOBAL_MD_PATH"
        echo ""
        read -p "既存のシンボリックリンクを更新しますか？ (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$CLAUDE_MD_PATH"
            ln -s "$CLAUDE_GLOBAL_MD_PATH" "$CLAUDE_MD_PATH"
            echo -e "${GREEN}✓ シンボリックリンクを更新しました${NC}"
        else
            echo -e "${YELLOW}処理を中断しました${NC}"
            exit 1
        fi
    fi
elif [ -f "$CLAUDE_MD_PATH" ]; then
    # 通常のファイルの場合
    echo -e "${YELLOW}~/.claude/CLAUDE.md は通常のファイルです${NC}"
    
    # リポジトリ側のファイルが存在しない場合はコピー
    if [ ! -f "$CLAUDE_GLOBAL_MD_PATH" ]; then
        echo "リポジトリに CLAUDE.global.md をコピーします..."
        cp "$CLAUDE_MD_PATH" "$CLAUDE_GLOBAL_MD_PATH"
        echo -e "${GREEN}✓ CLAUDE.global.md を作成しました${NC}"
    fi
    
    # バックアップを作成
    BACKUP_PATH="${CLAUDE_MD_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "既存の CLAUDE.md をバックアップします..."
    mv "$CLAUDE_MD_PATH" "$BACKUP_PATH"
    echo -e "${GREEN}✓ バックアップを作成しました: $BACKUP_PATH${NC}"
    
    # シンボリックリンクを作成
    ln -s "$CLAUDE_GLOBAL_MD_PATH" "$CLAUDE_MD_PATH"
    echo -e "${GREEN}✓ シンボリックリンクを作成しました${NC}"
else
    # 存在しない場合
    if [ -f "$CLAUDE_GLOBAL_MD_PATH" ]; then
        echo -e "${YELLOW}~/.claude/CLAUDE.md が存在しません${NC}"
        echo "シンボリックリンクを作成します..."
        ln -s "$CLAUDE_GLOBAL_MD_PATH" "$CLAUDE_MD_PATH"
        echo -e "${GREEN}✓ シンボリックリンクを作成しました${NC}"
    else
        echo -e "${YELLOW}⚠ CLAUDE.global.md がリポジトリに存在しません${NC}"
        echo -e "${YELLOW}  ~/.claude/CLAUDE.md も存在しないため、スキップします${NC}"
    fi
fi

echo ""
echo -e "${GREEN}セットアップが完了しました！${NC}"
echo -e "Claude のコマンドは ${BLUE}${COMMANDS_DIR}${NC} で管理されています"
echo -e "Claude のグローバル設定は ${BLUE}${CLAUDE_GLOBAL_MD_PATH}${NC} で管理されています"