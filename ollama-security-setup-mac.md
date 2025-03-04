# Ollama 安全配置工具使用手册 (Linux/macOS)

## 目录
- [简介](#简介)
- [安装准备](#安装准备)
- [快速开始](#快速开始)
- [功能详解](#功能详解)
- [常见问题](#常见问题)
- [安全建议](#安全建议)
- [开源协议](#开源协议)

## 简介

Ollama 安全配置工具用于配置和管理 Linux/macOS 环境下的 Ollama 服务，提供安全配置、服务管理和监控功能。

### 系统要求
- Linux/macOS 系统
- Bash Shell
- 已安装 Ollama (https://ollama.ai/download)
- root/sudo 权限

### 文件说明
- `ollama-security-setup.sh`: 主配置脚本

## 安装准备

1. 下载配置脚本
2. 添加执行权限：
   ```bash
   chmod +x ollama-security-setup.sh
   ```
3. 确认已安装 Ollama
4. 确保有 root/sudo 权限

## 快速开始

1. 在终端中运行脚本：
   ```bash
   sudo ./ollama-security-setup.sh
   ```
2. 等待工具启动

工具启动后会显示主菜单：
```
====== Ollama Security Configuration Tool ======
====== Ollama 安全配置工具 ======

Basic Configuration (基础配置):
1. Configure Settings (配置设置)
2. Configure Firewall Rules (配置防火墙规则)
3. Security Check and Advice (安全检查和建议)

Service Management (服务管理):
4. Start Ollama and Select Model (启动 Ollama 并选择模型)
5. View Logs (查看日志)

Quick Actions (快捷操作):
6. Apply Basic Security Config (应用基础安全配置)
0. Exit (退出)
==============================
```

每个选项的中英文对照说明：
1. Configure Settings (配置设置)
   - 配置 Ollama 的访问方式和 IP 设置
   - Configure Ollama access mode and IP settings

2. Configure Firewall Rules (配置防火墙规则)
   - 设置系统防火墙规则保护 Ollama
   - Set up system firewall rules to protect Ollama

3. Security Check and Advice (安全检查和建议)
   - 检查系统安全状态并提供建议
   - Check system security status and provide advice

4. Start Ollama and Select Model (启动 Ollama 并选择模型)
   - 启动服务并选择要运行的 AI 模型
   - Start service and select AI model to run

5. View Logs (查看日志)
   - 查看运行日志和诊断问题
   - View running logs and diagnose issues

6. Apply Basic Security Config (应用基础安全配置)
   - 一键完成基础安全配置（选项 1-3）
   - One-click basic security configuration (Options 1-3)

## 功能详解

### 1. 配置设置 (Configure Settings)
选择"1"后显示：
```
===== Ollama Configuration =====
===== Ollama 配置 =====

Select Ollama access mode (请选择 Ollama 访问模式):
1. VPN Mode - Enter VPN IP (VPN 模式 - 输入 VPN IP)
2. Local Mode - Use 127.0.0.1 (本地模式 - 使用 127.0.0.1)
```

### 2. 防火墙规则 (Firewall Rules)
选择"2"后系统会：
```
===== Firewall Configuration =====
===== 防火墙配置 =====

[INFO] Configuring system firewall...
[信息] 配置系统防火墙...

[INFO] Setting firewall rules:
[信息] 设置防火墙规则:
* Only allow specified IP to access port 11434
* 只允许指定IP访问11434端口
```

### 3. 安全检查 (Security Check)
选择"3"后会进行：
```
===== Security Check =====
===== 安全检查 =====

[INFO] Checking system firewall...
[信息] 检查系统防火墙...

[INFO] Checking port status...
[信息] 检查端口状态...

[INFO] Checking Ollama installation...
[信息] 检查 Ollama 安装...
```

### 4. 启动服务 (Start Service)
选择"4"后显示：
```
===== Ollama Service Management =====
===== Ollama 服务管理 =====

[INFO] Starting Ollama service...
[信息] 启动 Ollama 服务...

[INFO] Getting model list...
[信息] 获取模型列表...

Available Models (可用模型):
----------------------------------------
No.   Name                Size      Modified
序号  名称                大小      修改时间
0     llama2             4.1GB     2024-02-20
1     mistral            4.1GB     2024-02-20
----------------------------------------

Select model number (请选择模型编号):
```

### 5. 日志查看 (View Logs)
选择"5"后提供：
```
===== Ollama Log Viewer =====
===== Ollama 日志查看 =====

[INFO] Available logs (可用日志):
1. Application logs (应用程序日志)
2. Server logs (服务器日志)
3. View config file (查看配置文件)
0. Return to main menu (返回主菜单)

Select log type [0-3] (选择日志类型 [0-3]):
```

### 6. 快速配置 (Quick Configuration)
选择"6"自动执行：
```
===== Apply Basic Configuration =====
===== 应用基础配置 =====

1. Configure access settings (配置访问设置)
2. Set firewall rules (设置防火墙规则)
3. Run security check (执行安全检查)
```

## 常见问题

### 权限问题
问题表现：
- 无法启动脚本
- 权限不足错误

解决方法：
1. 确保使用 sudo 运行
2. 检查文件权限
3. 验证用户权限

### 防火墙配置
问题表现：
- 规则未生效
- 访问被阻止

解决方法：
1. 检查系统防火墙状态
2. 验证规则配置
3. 测试端口访问

### 服务管理
问题表现：
- 服务启动失败
- 模型加载错误

解决方法：
1. 检查服务状态
2. 验证配置文件
3. 查看错误日志

## 安全建议

### 基本防护
1. 系统安全：
   - 及时更新系统
   - 开启防火墙
   - 限制访问权限

2. 配置安全：
   - 使用安全的 IP 设置
   - 定期更新规则
   - 监控访问日志

### 日常维护
1. 定期检查：
   - 查看系统日志
   - 测试服务状态
   - 验证安全配置

2. 更新维护：
   - 更新模型版本
   - 优化系统配置
   - 清理临时文件

## 技术支持

如果遇到问题：
1. 查看详细日志
2. 检查配置文件
3. 参考官方文档
4. 寻求社区帮助

## 免责声明

本工具仅用于配置和管理 Ollama 服务，使用者需要：
1. 遵守相关法律法规
2. 确保数据安全
3. 承担使用风险
4. 注意隐私保护

## 开源协议

本项目采用 MIT 许可证，由 [@richardsun-ai](https://github.com/richardsun-ai) 维护。  
完整条款请查看 [LICENSE](LICENSE) 文件。 