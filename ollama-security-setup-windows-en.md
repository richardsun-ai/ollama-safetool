# Ollama Security Configuration Tool User Guide

## Table of Contents
- [Ollama Security Configuration Tool User Guide](#ollama-security-configuration-tool-user-guide)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
    - [System Requirements](#system-requirements)
    - [File Description](#file-description)
  - [Installation Preparation](#installation-preparation)
  - [Quick Start](#quick-start)
  - [Feature Details](#feature-details)
    - [1. Configure Settings](#1-configure-settings)
  - [Available Models](#available-models)
  - [Common Issues](#common-issues)
    - [Startup Failures](#startup-failures)
    - [Connection Issues](#connection-issues)
    - [Model Runtime Failures](#model-runtime-failures)
  - [Security Recommendations](#security-recommendations)
    - [Basic Protection](#basic-protection)
    - [Access Control](#access-control)
    - [Regular Maintenance](#regular-maintenance)
  - [Technical Support](#technical-support)
  - [Disclaimer](#disclaimer)
  - [Open Source License](#open-source-license)

## Introduction

The Ollama Security Configuration Tool is used to configure and manage the Ollama service in Windows environments, providing security configuration, service management, and monitoring functions.

### System Requirements
- Windows 10/11
- PowerShell 5.1 or higher
- Ollama installed (https://ollama.ai/download)

### File Description
- `ollama-security-setup.ps1`: Main configuration script
- `start-ollama-security.bat`: Startup batch file

## Installation Preparation

1. Download the configuration tool package
2. Ensure both files are in the same directory
3. Confirm that Ollama is installed
4. Ensure you have administrator privileges

## Quick Start

1. Double-click `start-ollama-security.bat`
2. Click "Yes" in the UAC prompt
3. Wait for the tool to start

After the tool starts, the main menu will display:
```
====== Ollama Security Configuration Tool ======

Basic Configuration:
1. Configure Settings
2. Configure Firewall Rules
3. Security Check and Advice

Service Management:
4. Start Ollama and Select Model
5. View Logs

Quick Actions:
6. Apply Basic Security Config
0. Exit
==============================
```

Description of each option:
1. Configure Settings
   - Configure Ollama's access method and IP settings

2. Configure Firewall Rules
   - Set up Windows Firewall rules to protect Ollama

3. Security Check and Advice
   - Check system security status and provide advice

4. Start Ollama and Select Model
   - Start service and select AI model to run

5. View Logs
   - View running logs and diagnose issues

6. Apply Basic Security Config
   - One-click basic security configuration (Options 1-3)

## Feature Details

### 1. Configure Settings
After selecting "1", the following is displayed:
```
===== Ollama Configuration =====

Select Ollama access mode:
1. VPN Mode - Enter VPN IP
2. Local Mode - Use 127.0.0.1

Operation instructions:
- VPN mode: Need to enter VPN IP address
- Local mode: Automatically configured for local access
- Restart service required after modification
```

### 2. Firewall Rules
After selecting "2", the system will:
```
===== Firewall Configuration =====

[INFO] Configuring system firewall...

[INFO] Setting firewall rules:
* Only allow specified IP to access port 11434
```

Configuration process:
- Automatically creates a firewall rule named "Ollama"
- Restricts access to only the configured IP
- Automatically validates rule effectiveness
- Displays detailed configuration results

### 3. Security Check
After selecting "3", the system will perform:
```
===== Security Check =====

[INFO] Checking Windows Firewall...

[INFO] Checking port status...

[INFO] Checking Ollama installation...
```

Check contents:
- Windows Firewall status
- Port 11434 usage
- Ollama installation integrity
- System security configuration
- Provides specific improvement suggestions

### 4. Start Service
After selecting "4", the following is displayed:
```
===== Ollama Service Management =====

[INFO] Starting Ollama service...

[INFO] Getting model list...

Available Models:
----------------------------------------
No.   Name                Size      Modified
0     llama2             4.1GB     2025-02-20
1     mistral            4.1GB     2025-02-20
----------------------------------------

Select model number:
```

Usage instructions:
- Enter the model number you want to run
- The system will start the model in a new window
- If no models exist, you need to download them first using `ollama pull`
- Wait for the model to fully load before use

### 5. View Logs
After selecting "5", the following is provided:
```
===== Ollama Log Viewer =====

[INFO] Available logs:
1. Application logs
2. Server logs
3. View config file
0. Return to main menu

Select log type [0-3]:
```

Viewing options:
1. Application logs:
   - View the latest 50 lines
   - Filter error messages
   - Real-time monitoring mode

2. Server logs:
   - Runtime status records
   - Connection information
   - Error tracking

3. Config file:
   - Current settings
   - System parameters
   - Runtime configuration

### 6. Quick Configuration
Selecting "6" automatically executes:
```
===== Apply Basic Configuration =====

1. Configure access settings
2. Set firewall rules
3. Run security check
```

Applicable scenarios:
- First time using the tool
- Need to reset configurations
- Quick service deployment

Execution process:
1. Automatically sets basic configurations
2. Configures firewall rules
3. Verifies all settings
4. Displays configuration report

## Available Models
----------------------------------------
No.   Name                Size      Modified
1     mistral            4.1GB     2025-02-20
----------------------------------------

## Common Issues

### Startup Failures
Problem symptoms:
- Tool cannot start
- Permission errors occur
- System errors

Solutions:
1. Permission issues:
   - Right-click and select "Run as administrator"
   - Check user permission settings
   - Temporarily disable security software

2. File issues:
   - Confirm file integrity
   - Check file location
   - Redownload the tool

3. System issues:
   - Confirm system version compatibility
   - Update PowerShell
   - Check system environment

### Connection Issues
Problem symptoms:
- Cannot access service
- Model startup failure
- Connection timeout

Solutions:
1. Network configuration:
   - Check IP settings
   - Verify firewall rules
   - Test network connection

2. Port issues:
   - Check port 11434 usage
   - Confirm firewall allows access
   - Try restarting the service

3. VPN related:
   - Confirm VPN connection status
   - Verify IP address correctness
   - Check VPN routing

### Model Runtime Failures
Problem symptoms:
- Model cannot start
- Runtime errors
- Performance issues

Solutions:
1. Model issues:
   - Confirm model is downloaded
   - Check model integrity
   - Redownload the model

2. Resource issues:
   - Check memory usage
   - Confirm disk space
   - Monitor CPU load

3. Configuration issues:
   - View error logs
   - Verify configuration correctness
   - Reset service configuration

## Security Recommendations

### Basic Protection
1. System security:
   - Update Windows system regularly
   - Enable system firewall
   - Use antivirus software

2. Configuration security:
   - Change access settings periodically
   - Update firewall rules promptly
   - Monitor unusual access

3. Runtime security:
   - Check logs regularly
   - Monitor system resources
   - Handle exceptions promptly

### Access Control
1. Local usage:
   - Use 127.0.0.1
   - Restrict external access
   - Check connections regularly

2. VPN usage:
   - Use fixed IP
   - Strengthen access control
   - Monitor connection status

### Regular Maintenance
1. Regular checks:
   - Review runtime logs
   - Test service status
   - Verify security configuration

2. Update maintenance:
   - Update model versions
   - Optimize system configuration
   - Clean temporary files

3. Backup recommendations:
   - Backup important configurations
   - Save custom settings
   - Record modification history

## Technical Support

If you encounter unresolvable issues:
1. View detailed logs
2. Check configuration files
3. Refer to official documentation
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