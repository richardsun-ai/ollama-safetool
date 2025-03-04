# Ollama Security Configuration Tool User Guide (Linux/macOS)

## Table of Contents
- [Introduction](#introduction)
- [Installation Preparation](#installation-preparation)
- [Quick Start](#quick-start)
- [Feature Details](#feature-details)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Security Recommendations](#security-recommendations)
- [Open Source License](#open-source-license)

## Introduction

The Ollama Security Configuration Tool is used to configure and manage the Ollama service in Linux/macOS environments, providing security configuration, service management, and monitoring functions.

### System Requirements
- Linux/macOS system
- Bash Shell
- Ollama installed (https://ollama.ai/download)
- root/sudo privileges

### File Description
- `ollama-security-setup-en.sh`: Main configuration script (English version)

## Installation Preparation

1. Download the configuration script
2. Add execution permission:
   ```bash
   chmod +x ollama-security-setup-en.sh
   ```
3. Confirm Ollama is installed
4. Ensure you have root/sudo privileges

## Quick Start

1. Run the script in terminal:
   ```bash
   sudo ./ollama-security-setup-en.sh
   ```
2. Wait for the tool to start

After the tool starts, the main menu will display:
```
====== Ollama Security Configuration Tool ======
Basic Configuration:
1. Set Environment Variables
2. Configure Firewall Rules
3. Security Check and Advice

Service Management:
4. Start Ollama and Select Model
5. View Logs

Quick Actions:
6. Apply Basic Security Configuration (Options 1-3)
0. Exit
==============================
```

Description of each option:
1. Set Environment Variables
   - Configure Ollama's access method and IP settings

2. Configure Firewall Rules
   - Set up system firewall rules to protect Ollama

3. Security Check and Advice
   - Check system security status and provide advice

4. Start Ollama and Select Model
   - Start service and select AI model to run

5. View Logs
   - View running logs and diagnose issues

6. Apply Basic Security Configuration
   - One-click basic security configuration (Options 1-3)

## Feature Details

### 1. Configure Settings
After selecting "1", the following is displayed:
```
===== Ollama Configuration =====

Current setting: Not configured (default 127.0.0.1)

Select Ollama access mode:
1. VPN only (enter VPN IP)
2. Local only (127.0.0.1)
```

### 2. Firewall Rules
After selecting "2", the system will:
```
===== Firewall Configuration =====

⚙️ Configuring system firewall...
📝 Setting firewall rules:
• Only allow 127.0.0.1:11434 to access Ollama

⚙️ Applying firewall rules...
✅ Firewall configuration completed
```

### 3. Security Check
After selecting "3", the system will perform:
```
===== Security Check and Advice =====

🔍 Checking System Integrity Protection (SIP) status:
...
🔍 Checking Application Firewall status:
...
🔍 Checking File Sharing service status:
...
🔍 Checking Ollama port status:
...
🔍 Checking Ollama process status:
...
```

### 4. Start Service
After selecting "4", the following is displayed:
```
===== Ollama Service Management =====

📝 Using configuration file setting: host = 127.0.0.1
🔍 Checking Ollama status...
• Using address: 127.0.0.1:11434
⚙️ Starting Ollama service...
✅ Ollama service started
📝 Listening address: 127.0.0.1:11434

===== Model List =====
🔍 Getting installed models...
✅ Installed models:
----------------------------------------
No.   Name                Size      Modified
0     llama2             4.1GB     2025-02-20
1     mistral            4.1GB     2025-02-20
----------------------------------------

Please select the model number to use:
```

### 5. View Logs
After selecting "5", the following is provided:
```
===== Ollama Log Viewer =====

📝 Log viewing options:
1. View logs in real-time (press Ctrl+C to exit)
2. View the latest 50 lines
3. View error messages
0. Return to main menu

Please select [0-3]:
```

### 6. Quick Configuration
Selecting "6" automatically executes:
```
===== Apply All Basic Configurations =====
1. Configure firewall (restrict port access)
...
2. Configure environment variables (set OLLAMA_HOST)
...
3. Security check and advice
...
✅ Basic configuration completed
```

## Frequently Asked Questions

### Permission Issues
Problem symptoms:
- Cannot start script
- Insufficient permission error

Solutions:
1. Make sure to use sudo when running
   ```bash
   sudo ./ollama-security-setup-en.sh
   ```
2. Check file permissions
   ```bash
   chmod +x ollama-security-setup-en.sh
   ```
3. Verify user permissions

### Firewall Configuration
Problem symptoms:
- Rules not taking effect
- Access being blocked

Solutions:
1. Check system firewall status
   ```bash
   /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
   ```
2. Verify rule configuration
   ```bash
   cat /etc/pf.anchors/ollama
   ```
3. Test port access
   ```bash
   curl 127.0.0.1:11434
   ```

### Service Management
Problem symptoms:
- Service startup failure
- Model loading error

Solutions:
1. Check service status
   ```bash
   ps aux | grep ollama
   ```
2. Verify configuration file
   ```bash
   cat ~/.ollama/config
   ```
3. View error logs
   ```bash
   cat ~/.ollama/logs/server.log
   ```

## Security Recommendations

### Basic Protection
1. System security:
   - Update system regularly
   - Enable firewall
   - Enable System Integrity Protection (SIP)
   - Limit access permissions

2. Configuration security:
   - Use secure IP settings (prefer 127.0.0.1 for local use only)
   - Update rules periodically
   - Monitor access logs

### Regular Maintenance
1. Regular checks:
   - Check system logs
   - Test service status
   - Verify security configuration

2. Update maintenance:
   - Update model versions with `ollama pull [model]`
   - Optimize system configuration
   - Clean temporary files

## Technical Support

If you encounter problems:
1. View detailed logs using option 5 in the script
2. Check configuration files in ~/.ollama/
3. Refer to official documentation at https://ollama.ai/
4. Seek community help

## Disclaimer

This tool is only used to configure and manage the Ollama service. Users need to:
1. Comply with relevant laws and regulations
2. Ensure data security
3. Bear the risks of use
4. Pay attention to privacy protection

## Open Source License

This project is licensed under the MIT License, maintained by [@richardsun-ai](https://github.com/richardsun-ai).  
For complete terms, please see the [LICENSE](LICENSE) file. 