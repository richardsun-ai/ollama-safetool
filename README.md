# Ollama-Safetool

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)]()

Ollama安全配置管理工具，提供简便的安全设置和服务管理功能，帮助用户安全地部署和运行Ollama大语言模型。

## 项目概述

Ollama-Safetool是一个专为[Ollama](https://ollama.ai/)大语言模型应用设计的安全配置工具，帮助用户解决在部署和使用过程中的安全挑战。本工具通过自动化配置防火墙规则、管理网络设置、监控服务状态等功能，确保Ollama在安全的环境中运行。

## 主要功能

- **安全配置**: 自动设置防火墙规则，限制外部访问
- **服务管理**: 一键启动Ollama服务并选择模型
- **网络设置**: 配置VPN模式或本地模式，控制访问范围
- **安全检查**: 系统和安装环境的安全状态评估
- **日志监控**: 查看和分析运行日志
- **跨平台支持**: 适用于Windows、macOS和Linux系统

## 系统要求

### Windows
- Windows 10/11
- PowerShell 5.1或更高版本
- 已安装Ollama

### macOS/Linux
- macOS 10.15+或主流Linux发行版
- Bash环境
- 已安装Ollama
- root/sudo权限

## 安装说明

1. 克隆仓库或下载最新版本
   ```bash
   git clone https://github.com/richardsun-ai/ollama-safetool.git
   ```

2. 赋予脚本执行权限(macOS/Linux)
   ```bash
   chmod +x ollama-security-setup.sh
   ```

## 使用指南

### Windows
1. 双击运行 `start-ollama-security.bat`
2. 在UAC提示中选择"是"允许管理员权限
3. 按照菜单提示操作

### macOS/Linux
1. 打开终端，进入工具目录
2. 执行以下命令
   ```bash
   sudo ./ollama-security-setup.sh
   ```
3. 根据菜单选择所需功能

## 文件结构

```
ollama-safetool/
├── LICENSE                        # MIT许可证
├── README.md                      # 项目说明文档
├── VERSION.md                     # 版本历史
├── AUTHORS                        # 贡献者信息
├── ollama-security-setup.ps1      # Windows主脚本
├── start-ollama-security.bat      # Windows启动批处理
├── ollama-security-setup.sh       # macOS/Linux脚本
├── ollama-security-setup-mac.md   # macOS使用手册
└── ollama-security-setup-windows.md # Windows使用手册
```

## 功能详解

### 安全配置功能
- 防火墙规则设置：限制只有授权IP才能访问服务
- 环境变量配置：安全管理Ollama的运行环境
- 服务隔离：确保服务在安全的网络环境中运行

### 服务管理功能
- 服务启动与停止：便捷控制Ollama服务
- 模型选择与加载：一键启动所需AI模型
- 状态监控：实时查看服务运行状态

## 常见问题

**Q: 为什么需要管理员/root权限?**  
A: 配置防火墙和系统网络设置需要管理员级别权限。

**Q: 配置会影响其他应用吗?**  
A: 工具只会修改与Ollama相关的设置，不会影响其他应用。

**Q: 如何恢复默认设置?**  
A: 工具提供恢复选项，可以快速还原所有更改。

## 贡献指南

欢迎提交问题报告和功能建议!

1. Fork项目
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建Pull Request

## 开源协议

本项目采用MIT许可证 - 详情请查看[LICENSE](LICENSE)文件

## 联系方式

Richard Sun - [@richardsun-ai](https://github.com/richardsun-ai)

项目链接: [https://github.com/richardsun-ai/ollama-safetool](https://github.com/richardsun-ai/ollama-safetool) 