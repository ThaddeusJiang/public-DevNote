#!/bin/bash

echo "=== 检查 Node.js 安装路径 ==="
echo ""

# 1. 检查当前使用的 node
echo "1. 当前使用的 node 路径："
which node 2>/dev/null || echo "  未找到 node 命令"
echo ""

# 2. 检查当前 node 版本
echo "2. 当前 node 版本："
node --version 2>/dev/null || echo "  无法获取版本"
echo ""

# 3. 检查 nvm
echo "3. 检查 nvm："
if [ -d "$HOME/.nvm" ]; then
    echo "  nvm 目录存在: $HOME/.nvm"
    if [ -f "$HOME/.nvm/versions/node" ]; then
        echo "  已安装的版本："
        ls -1 "$HOME/.nvm/versions/node" 2>/dev/null | sed 's/^/    /'
    fi
    if [ -n "$NVM_DIR" ]; then
        echo "  NVM_DIR: $NVM_DIR"
    fi
else
    echo "  nvm 未安装"
fi
echo ""

# 4. 检查 Homebrew
echo "4. 检查 Homebrew："
if command -v brew &> /dev/null; then
    echo "  Homebrew 已安装"
    BREW_NODE=$(brew --prefix node 2>/dev/null)
    if [ -n "$BREW_NODE" ]; then
        echo "  Node.js 路径: $BREW_NODE"
    fi
    echo "  已安装的 node 相关包："
    brew list | grep -E "node|npm" | sed 's/^/    /' || echo "    无"
else
    echo "  Homebrew 未安装"
fi
echo ""

# 5. 检查 n
echo "5. 检查 n："
if command -v n &> /dev/null; then
    echo "  n 已安装"
    N_PREFIX=${N_PREFIX:-/usr/local}
    if [ -d "$N_PREFIX/n/versions/node" ]; then
        echo "  n 安装目录: $N_PREFIX/n/versions/node"
        echo "  已安装的版本："
        ls -1 "$N_PREFIX/n/versions/node" 2>/dev/null | sed 's/^/    /'
    fi
    echo "  N_PREFIX: $N_PREFIX"
else
    echo "  n 未安装"
fi
echo ""

# 6. 检查 Volta
echo "6. 检查 Volta："
if command -v volta &> /dev/null; then
    echo "  Volta 已安装"
    VOLTA_HOME=${VOLTA_HOME:-$HOME/.volta}
    echo "  VOLTA_HOME: $VOLTA_HOME"
    if [ -d "$VOLTA_HOME/tools/node" ]; then
        echo "  已安装的版本："
        ls -1 "$VOLTA_HOME/tools/node" 2>/dev/null | sed 's/^/    /'
    fi
    volta list node 2>/dev/null | sed 's/^/    /' || echo "    无已安装版本"
else
    echo "  Volta 未安装"
fi
echo ""

# 7. 检查 mise (原 rtx)
echo "7. 检查 mise："
if command -v mise &> /dev/null; then
    echo "  mise 已安装"
    MISE_DATA_DIR=${MISE_DATA_DIR:-$HOME/.local/share/mise}
    echo "  MISE_DATA_DIR: $MISE_DATA_DIR"
    if [ -d "$MISE_DATA_DIR/installs/node" ]; then
        echo "  已安装的版本："
        ls -1 "$MISE_DATA_DIR/installs/node" 2>/dev/null | sed 's/^/    /'
    fi
    mise ls node 2>/dev/null | sed 's/^/    /' || echo "    无已安装版本"
else
    echo "  mise 未安装"
fi
echo ""

# 8. 检查 fnm (Fast Node Manager)
echo "8. 检查 fnm："
if command -v fnm &> /dev/null; then
    echo "  fnm 已安装"
    FNM_DIR=${FNM_DIR:-$HOME/.fnm}
    echo "  FNM_DIR: $FNM_DIR"
    if [ -d "$FNM_DIR/node-versions" ]; then
        echo "  已安装的版本："
        ls -1 "$FNM_DIR/node-versions" 2>/dev/null | sed 's/^/    /'
    fi
    fnm list 2>/dev/null | sed 's/^/    /' || echo "    无已安装版本"
else
    echo "  fnm 未安装"
fi
echo ""

# 9. 检查 asdf
echo "9. 检查 asdf："
if command -v asdf &> /dev/null; then
    echo "  asdf 已安装"
    ASDF_DATA_DIR=${ASDF_DATA_DIR:-$HOME/.asdf}
    echo "  ASDF_DATA_DIR: $ASDF_DATA_DIR"
    if [ -d "$ASDF_DATA_DIR/installs/nodejs" ]; then
        echo "  已安装的版本："
        ls -1 "$ASDF_DATA_DIR/installs/nodejs" 2>/dev/null | sed 's/^/    /'
    fi
    asdf list nodejs 2>/dev/null | sed 's/^/    /' || echo "    无已安装版本"
else
    echo "  asdf 未安装"
fi
echo ""

# 10. 查找所有可能的 node 可执行文件
echo "10. 系统范围内查找 node 可执行文件："
echo "  使用 find 命令查找（可能需要 sudo）："
echo "    find /usr/local /opt /home -name node -type f 2>/dev/null | head -20"
echo ""

# 11. 检查 PATH 中的 node
echo "11. PATH 中的所有 node 相关路径："
echo "$PATH" | tr ':' '\n' | grep -E "node|npm|nvm|volta|mise|fnm|asdf" | sed 's/^/    /' || echo "    无"
echo ""

# 12. 检查环境变量
echo "12. 相关环境变量："
env | grep -E "NODE|NVM|VOLTA|MISE|FNM|ASDF|N_PREFIX" | sed 's/^/    /' || echo "    无相关环境变量"
echo ""

echo "=== 检查完成 ==="
