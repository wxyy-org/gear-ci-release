# Gear CI Release

[![Release](https://img.shields.io/github/v/release/wxyy-org/gear-ci-release)](https://github.com/wxyy-org/gear-ci-release/releases)

Gear CI 的二进制发布仓库。此仓库由 [gear-ci](https://github.com/wxyy-org/gear-ci) 主仓自动同步，请勿手动修改。

## 安装

### Homebrew (macOS / Linux)

```bash
brew tap wxyy-org/gear-ci && brew install gear-ci
```

### 一键脚本

```bash
curl -sSL https://raw.githubusercontent.com/wxyy-org/gear-ci-release/main/install.sh | bash
```

指定版本：

```bash
VERSION=v2026.06.05.0 curl -sSL https://raw.githubusercontent.com/wxyy-org/gear-ci-release/main/install.sh | bash
```

### 手动下载

从 [Releases](https://github.com/wxyy-org/gear-ci-release/releases) 页面下载对应平台的二进制文件。

| 平台 | 文件名 |
|------|--------|
| macOS (Apple Silicon) | `gear-ci-darwin-arm64` |
| macOS (Intel) | `gear-ci-darwin-amd64` |
| Linux (x86_64) | `gear-ci-linux-amd64` |
| Windows | `gear-ci-windows-amd64.exe` |

```bash
# 示例：macOS Apple Silicon
chmod +x gear-ci-darwin-arm64
mv gear-ci-darwin-arm64 /usr/local/bin/gear-ci
```
