#!/bin/bash

echo "=== 检查全局 node_modules ==="
echo ""

# 函数：检查并显示 node_modules 目录
check_node_modules() {
    local path=$1
    local tool_name=$2
    if [ -d "$path" ]; then
        local count=$(ls -1 "$path" 2>/dev/null | wc -l | tr -d ' ')
        local size=$(du -sh "$path" 2>/dev/null | cut -f1)
        echo "  ✓ $tool_name: $path"
        echo "    包数量: $count"
        echo "    大小: $size"
        if [ "$count" -gt 0 ] && [ "$count" -lt 20 ]; then
            echo "    包列表:"
            ls -1 "$path" 2>/dev/null | sed 's/^/      - /'
        fi
        return 0
    else
        echo "  ✗ $tool_name: 目录不存在"
        return 1
    fi
}

# 1. 使用 npm 命令检查当前全局 node_modules
echo "1. 当前 npm 全局 node_modules 路径："
if command -v npm &> /dev/null; then
    NPM_GLOBAL_ROOT=$(npm root -g 2>/dev/null)
    if [ -n "$NPM_GLOBAL_ROOT" ]; then
        echo "  npm root -g: $NPM_GLOBAL_ROOT"
        check_node_modules "$NPM_GLOBAL_ROOT" "当前 npm 全局"
        echo ""

        # 列出全局安装的包
        echo "  全局安装的包："
        npm list -g --depth=0 2>/dev/null | tail -n +2 | sed 's/^/    /' || echo "    无法列出"
    else
        echo "  无法获取 npm 全局路径"
    fi
else
    echo "  npm 未安装或不在 PATH 中"
fi
echo ""

# 2. 检查 nvm 的全局 node_modules
echo "2. 检查 nvm 的全局 node_modules："
if [ -d "$HOME/.nvm" ]; then
    NVM_DIR=${NVM_DIR:-$HOME/.nvm}
    if [ -d "$NVM_DIR/versions/node" ]; then
        for version_dir in "$NVM_DIR/versions/node"/*; do
            if [ -d "$version_dir" ]; then
                version=$(basename "$version_dir")
                node_modules_path="$version_dir/lib/node_modules"
                if [ -d "$node_modules_path" ]; then
                    echo "  版本 $version:"
                    check_node_modules "$node_modules_path" "nvm ($version)"
                fi
            fi
        done
    fi
else
    echo "  nvm 未安装"
fi
echo ""

# 3. 检查 Homebrew 的全局 node_modules
echo "3. 检查 Homebrew 的全局 node_modules："
if command -v brew &> /dev/null; then
    # 检查 Intel Mac 路径
    BREW_PREFIX_INTEL="/usr/local"
    # 检查 Apple Silicon Mac 路径
    BREW_PREFIX_ARM="/opt/homebrew"

    for prefix in "$BREW_PREFIX_INTEL" "$BREW_PREFIX_ARM"; do
        node_modules_path="$prefix/lib/node_modules"
        if [ -d "$node_modules_path" ]; then
            check_node_modules "$node_modules_path" "Homebrew ($prefix)"
        fi
    done

    # 检查 Homebrew 安装的 node 版本的 lib/node_modules
    BREW_NODE=$(brew --prefix node 2>/dev/null)
    if [ -n "$BREW_NODE" ] && [ -d "$BREW_NODE" ]; then
        # Homebrew 的 node 通常在 Cellar 中，lib 在版本目录下
        for node_version_dir in "$BREW_NODE"/*/lib/node_modules; do
            if [ -d "$node_version_dir" ] 2>/dev/null; then
                check_node_modules "$node_version_dir" "Homebrew Node.js"
            fi
        done
        # 或者直接在 /usr/local/lib/node_modules
        if [ -d "/usr/local/lib/node_modules" ]; then
            check_node_modules "/usr/local/lib/node_modules" "Homebrew (系统级)"
        fi
        if [ -d "/opt/homebrew/lib/node_modules" ]; then
            check_node_modules "/opt/homebrew/lib/node_modules" "Homebrew (系统级)"
        fi
    fi
else
    echo "  Homebrew 未安装"
fi
echo ""

# 4. 检查 n 的全局 node_modules
echo "4. 检查 n 的全局 node_modules："
if command -v n &> /dev/null; then
    N_PREFIX=${N_PREFIX:-/usr/local}
    if [ -d "$N_PREFIX/n/versions/node" ]; then
        for version_dir in "$N_PREFIX/n/versions/node"/*; do
            if [ -d "$version_dir" ]; then
                version=$(basename "$version_dir")
                node_modules_path="$version_dir/lib/node_modules"
                if [ -d "$node_modules_path" ]; then
                    echo "  版本 $version:"
                    check_node_modules "$node_modules_path" "n ($version)"
                fi
            fi
        done
    fi
    # n 也可能在系统级路径
    if [ -d "/usr/local/lib/node_modules" ]; then
        check_node_modules "/usr/local/lib/node_modules" "n (系统级)"
    fi
else
    echo "  n 未安装"
fi
echo ""

# 5. 检查 Volta 的全局 node_modules
echo "5. 检查 Volta 的全局 node_modules："
if command -v volta &> /dev/null; then
    VOLTA_HOME=${VOLTA_HOME:-$HOME/.volta}
    if [ -d "$VOLTA_HOME/tools/node" ]; then
        for version_dir in "$VOLTA_HOME/tools/node"/*; do
            if [ -d "$version_dir" ]; then
                version=$(basename "$version_dir")
                node_modules_path="$version_dir/lib/node_modules"
                if [ -d "$node_modules_path" ]; then
                    echo "  版本 $version:"
                    check_node_modules "$node_modules_path" "Volta ($version)"
                fi
            fi
        done
    fi
else
    echo "  Volta 未安装"
fi
echo ""

# 6. 检查 mise 的全局 node_modules
echo "6. 检查 mise 的全局 node_modules："
if command -v mise &> /dev/null; then
    MISE_DATA_DIR=${MISE_DATA_DIR:-$HOME/.local/share/mise}
    if [ -d "$MISE_DATA_DIR/installs/node" ]; then
        for version_dir in "$MISE_DATA_DIR/installs/node"/*; do
            if [ -d "$version_dir" ]; then
                version=$(basename "$version_dir")
                node_modules_path="$version_dir/lib/node_modules"
                if [ -d "$node_modules_path" ]; then
                    echo "  版本 $version:"
                    check_node_modules "$node_modules_path" "mise ($version)"
                fi
            fi
        done
    fi
else
    echo "  mise 未安装"
fi
echo ""

# 7. 检查 fnm 的全局 node_modules
echo "7. 检查 fnm 的全局 node_modules："
if command -v fnm &> /dev/null; then
    FNM_DIR=${FNM_DIR:-$HOME/.fnm}
    if [ -d "$FNM_DIR/node-versions" ]; then
        for version_dir in "$FNM_DIR/node-versions"/*; do
            if [ -d "$version_dir" ]; then
                version=$(basename "$version_dir")
                node_modules_path="$version_dir/lib/node_modules"
                if [ -d "$node_modules_path" ]; then
                    echo "  版本 $version:"
                    check_node_modules "$node_modules_path" "fnm ($version)"
                fi
            fi
        done
    fi
else
    echo "  fnm 未安装"
fi
echo ""

# 8. 检查 asdf 的全局 node_modules
echo "8. 检查 asdf 的全局 node_modules："
if command -v asdf &> /dev/null; then
    ASDF_DATA_DIR=${ASDF_DATA_DIR:-$HOME/.asdf}
    if [ -d "$ASDF_DATA_DIR/installs/nodejs" ]; then
        for version_dir in "$ASDF_DATA_DIR/installs/nodejs"/*; do
            if [ -d "$version_dir" ]; then
                version=$(basename "$version_dir")
                node_modules_path="$version_dir/lib/node_modules"
                if [ -d "$node_modules_path" ]; then
                    echo "  版本 $version:"
                    check_node_modules "$node_modules_path" "asdf ($version)"
                fi
            fi
        done
    fi
else
    echo "  asdf 未安装"
fi
echo ""

# 9. 检查常见的系统级 node_modules 路径
echo "9. 检查常见的系统级 node_modules 路径："
SYSTEM_PATHS=(
    "/usr/local/lib/node_modules"
    "/usr/lib/node_modules"
    "/opt/homebrew/lib/node_modules"
    "/opt/node_modules"
)

for path in "${SYSTEM_PATHS[@]}"; do
    if [ -d "$path" ]; then
        check_node_modules "$path" "系统路径"
    fi
done
echo ""

# 10. 使用 npm 列出所有全局包（如果可用）
echo "10. 当前 npm 全局包列表："
if command -v npm &> /dev/null; then
    npm list -g --depth=0 2>/dev/null | head -20 || echo "  无法列出全局包"
else
    echo "  npm 未安装"
fi
echo ""

# 11. 查找所有 node_modules 目录（可能需要 sudo）
echo "11. 系统范围内查找 node_modules 目录："
echo "  提示：以下命令可能需要 sudo 权限"
echo "  find /usr/local /opt $HOME -type d -name node_modules 2>/dev/null | head -20"
echo ""

echo "=== 检查完成 ==="
echo ""
echo "提示："
echo "  - 使用 'npm list -g' 查看当前 npm 的全局包列表"
echo "  - 使用 'npm root -g' 查看当前 npm 的全局 node_modules 路径"
echo "  - 不同 Node.js 版本管理器可能有各自的全局 node_modules"
echo "  - 全局包通常安装在 <node安装路径>/lib/node_modules"
