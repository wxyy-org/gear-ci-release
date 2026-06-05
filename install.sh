#!/bin/bash
set -euo pipefail

REPO="wxyy-org/gear-ci-release"
BINARY_NAME="gear-ci"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

info() { printf "\033[1;34m%s\033[0m\n" "$*" >&2; }
error() { printf "\033[1;31m%s\033[0m\n" "$*" >&2; exit 1; }

detect_platform() {
    local os arch
    case "$(uname -s)" in
        Linux*)  os="linux" ;;
        Darwin*) os="darwin" ;;
        CYGWIN*|MINGW*|MSYS*)
            error "Windows 不支持此安装方式。请从 https://github.com/${REPO}/releases 手动下载 .exe 文件。"
            ;;
        *) error "不支持的操作系统: $(uname -s)" ;;
    esac
    case "$(uname -m)" in
        x86_64|amd64)  arch="amd64" ;;
        arm64|aarch64) arch="arm64" ;;
        *) error "不支持的架构: $(uname -m)" ;;
    esac
    echo "${os}-${arch}"
}

get_version() {
    if [ -n "${VERSION:-}" ]; then
        echo "$VERSION"
        return
    fi
    info "正在获取最新版本..."
    curl -sSf "https://api.github.com/repos/${REPO}/releases/latest" \
        | grep '"tag_name"' \
        | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/' \
        || error "无法获取最新版本，请检查网络或手动指定 VERSION 环境变量"
}

main() {
    local platform version filename tmp_dir
    platform=$(detect_platform)
    version=$(get_version)

    [ -z "$version" ] && error "未找到任何 Release"

    filename="${BINARY_NAME}-${platform}"
    download_url="https://github.com/${REPO}/releases/download/${version}/${filename}"

    info "正在下载 ${BINARY_NAME} ${version} (${platform})..."
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    curl -sSfL "$download_url" -o "${tmp_dir}/${BINARY_NAME}" \
        || error "下载失败，请检查版本 ${version} 是否存在: ${download_url}"

    chmod +x "${tmp_dir}/${BINARY_NAME}"

    if [ ! -w "$INSTALL_DIR" ] 2>/dev/null; then
        info "需要 sudo 权限安装到 ${INSTALL_DIR}"
        sudo mv "${tmp_dir}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
    else
        mv "${tmp_dir}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
    fi

    info "✓ ${BINARY_NAME} ${version} 已安装到 ${INSTALL_DIR}/${BINARY_NAME}"
    "${INSTALL_DIR}/${BINARY_NAME}" --version
}

main "$@"
