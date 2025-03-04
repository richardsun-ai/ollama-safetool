# Ollama 安全配置工具使用手册

## 目录
- [Ollama 安全配置工具使用手册](#ollama-安全配置工具使用手册)
  - [目录](#目录)
  - [简介](#简介)
    - [系统要求](#系统要求)
    - [文件说明](#文件说明)
  - [安装准备](#安装准备)
  - [快速开始](#快速开始)
  - [功能详解](#功能详解)
    - [1. 配置设置 (Configure Settings)](#1-配置设置-configure-settings)
  - [Available Models (可用模型):](#available-models-可用模型)
  - [1     mistral            4.1GB     2024-02-20](#1-----mistral------------41gb-----2024-02-20)

## 简介

Ollama 安全配置工具用于配置和管理 Windows 环境下的 Ollama 服务，提供安全配置、服务管理和监控功能。

### 系统要求
- Windows 10/11
- PowerShell 5.1 或更高版本
- 已安装 Ollama (https://ollama.ai/download)

### 文件说明
- `ollama-security-setup.ps1`: 主配置脚本
- `start-ollama-security.bat`: 启动批处理文件

## 安装准备

1. 下载配置工具包
2. 确保两个文件在同一目录
3. 确认已安装 Ollama
4. 确保有管理员权限

## 快速开始

1. 双击运行 `start-ollama-security.bat`
2. 在 UAC 弹窗中点击"是"
3. 等待工具启动

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
   - 设置 Windows 防火墙规则保护 Ollama
   - Set up Windows Firewall rules to protect Ollama

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

操作说明：
- VPN模式：需要输入VPN的IP地址
- 本地模式：自动配置为本地访问
- 修改后需要重启服务生效

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

配置过程：
- 自动创建名为"Ollama"的防火墙规则
- 限制只有配置的IP可以访问
- 自动验证规则是否生效
- 显示详细的配置结果

### 3. 安全检查 (Security Check)
选择"3"后会进行：
```
===== Security Check =====
===== 安全检查 =====

[INFO] Checking Windows Firewall...
[信息] 检查 Windows 防火墙...

[INFO] Checking port status...
[信息] 检查端口状态...

[INFO] Checking Ollama installation...
[信息] 检查 Ollama 安装...
```

检查内容：
- Windows 防火墙状态
- 11434端口占用情况
- Ollama 安装完整性
- 系统安全配置
- 提供具体改进建议

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

使用说明：
- 输入想要运行的模型序号
- 系统会在新窗口中启动该模型
- 如果没有模型，需要先使用 `ollama pull` 下载
- 等待模型完全加载后即可使用

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

查看选项：
1. 应用程序日志：
   - 查看最新50行
   - 筛选错误信息
   - 实时监控模式

2. 服务器日志：
   - 运行状态记录
   - 连接信息
   - 错误追踪

3. 配置文件：
   - 当前设置
   - 系统参数
   - 运行配置

### 6. 快速配置 (Quick Configuration)
选择"6"自动执行：
```
===== Apply Basic Configuration =====
===== 应用基础配置 =====

1. Configure access settings (配置访问设置)
2. Set firewall rules (设置防火墙规则)
3. Run security check (执行安全检查)
```

适用场景：
- 首次使用工具
- 需要重置配置
- 快速部署服务

执行过程：
1. 自动设置基础配置
2. 配置防火墙规则
3. 验证所有设置
4. 显示配置报告

## 常见问题

### 启动失败
问题表现：
- 工具无法启动
- 出现权限错误
- 系统报错

解决方法：
1. 权限问题：
   - 右键选择"以管理员身份运行"
   - 检查用户权限设置
   - 暂时关闭安全软件

2. 文件问题：
   - 确认文件完整性
   - 检查文件位置
   - 重新下载工具

3. 系统问题：
   - 确认系统版本兼容
   - 更新 PowerShell
   - 检查系统环境

### 连接问题
问题表现：
- 无法访问服务
- 模型启动失败
- 连接超时

解决方法：
1. 网络配置：
   - 检查 IP 设置
   - 验证防火墙规则
   - 测试网络连接

2. 端口问题：
   - 检查11434端口占用
   - 确认防火墙允许
   - 尝试重启服务

3. VPN相关：
   - 确认VPN连接状态
   - 验证IP地址正确
   - 检查VPN路由

### 模型运行失败
问题表现：
- 模型无法启动
- 运行时报错
- 性能问题

解决方法：
1. 模型问题：
   - 确认模型已下载
   - 检查模型完整性
   - 重新下载模型

2. 资源问题：
   - 检查内存使用
   - 确认硬盘空间
   - 观察CPU负载

3. 配置问题：
   - 查看错误日志
   - 验证配置正确
   - 重置服务配置

## 安全建议

### 基本防护
1. 系统安全：
   - 及时更新Windows系统
   - 开启系统防火墙
   - 使用防病毒软件

2. 配置安全：
   - 定期更改访问设置
   - 及时更新防火墙规则
   - 监控异常访问

3. 运行安全：
   - 定期检查日志
   - 监控系统资源
   - 及时处理异常

### 访问控制
1. 本地使用：
   - 使用127.0.0.1
   - 限制外部访问
   - 定期检查连接

2. VPN使用：
   - 使用固定IP
   - 加强访问控制
   - 监控连接状态

### 日常维护
1. 定期检查：
   - 查看运行日志
   - 测试服务状态
   - 验证安全配置

2. 更新维护：
   - 更新模型版本
   - 优化系统配置
   - 清理临时文件

3. 备份建议：
   - 备份重要配置
   - 保存自定义设置
   - 记录修改历史

## 技术支持

如果遇到无法解决的问题：
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

本项目采用 MIT 许可证，完整条款如下：

```text
MIT License

Copyright (c) 2025 Richard Sun (GitHub: @richardsun-ai)

特此免费授予任何获得本软件及相关文档文件（以下简称"软件"）副本的人士，
无限制地处理软件的权限，包括但不限于使用、复制、修改、合并、发布、分发、再许可和/或销售软件的副本...

完整条款请查看 LICENSE 文件。
```

