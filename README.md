# Ollama-Safetool

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)]()

A security configuration management tool for Ollama, providing simple security settings and service management functions to help users securely deploy and run Ollama large language models.

## Project Overview

Ollama-Safetool is a security configuration tool designed specifically for [Ollama](https://ollama.ai/) large language model applications, helping users address security challenges during deployment and use. This tool ensures Ollama runs in a secure environment by automating firewall rule configuration, managing network settings, monitoring service status, and more.

## Key Features

- **Security Configuration**: Automatically set up firewall rules to restrict external access
- **Service Management**: One-click start of Ollama service and model selection
- **Network Settings**: Configure VPN mode or local mode to control access scope
- **Security Checks**: Security status assessment of system and installation environment
- **Log Monitoring**: View and analyze operation logs
- **Cross-Platform Support**: Compatible with Windows, macOS, and Linux systems

## System Requirements

### Windows
- Windows 10/11
- PowerShell 5.1 or higher
- Ollama installed

### macOS/Linux
- macOS 10.15+ or mainstream Linux distributions
- Bash environment
- Ollama installed
- root/sudo privileges

## Installation Guide

1. Clone the repository or download the latest version
   ```bash
   git clone https://github.com/richardsun-ai/ollama-safetool.git
   ```

2. Grant execution permissions to scripts (macOS/Linux)
   ```bash
   chmod +x ollama-security-setup.sh
   ```

## Usage Instructions

### Windows
1. Double-click to run `start-ollama-security.bat`
2. Select "Yes" in the UAC prompt to allow administrator privileges
3. Follow the menu prompts

### macOS/Linux
1. Open terminal and navigate to the tool directory
2. Execute the following command
   ```bash
   sudo ./ollama-security-setup.sh
   ```
3. Select the desired function from the menu

## File Structure

```
ollama-safetool/
├── LICENSE                        # MIT license
├── README.md                      # Project documentation
├── VERSION.md                     # Version history
├── AUTHORS                        # Contributor information
├── ollama-security-setup.ps1      # Windows main script
├── start-ollama-security.bat      # Windows startup batch file
├── ollama-security-setup.sh       # macOS/Linux script
├── ollama-security-setup-mac.md   # macOS user manual
└── ollama-security-setup-windows.md # Windows user manual
```

## Detailed Functionality

### Security Configuration Features
- Firewall Rule Setup: Restrict service access to authorized IPs only
- Environment Variable Configuration: Securely manage Ollama's runtime environment
- Service Isolation: Ensure the service runs in a secure network environment

### Service Management Features
- Service Start and Stop: Convenient control of Ollama service
- Model Selection and Loading: One-click startup of required AI models
- Status Monitoring: Real-time view of service operational status

## Frequently Asked Questions

**Q: Why are administrator/root privileges required?**  
A: Configuring firewalls and system network settings requires administrator-level privileges.

**Q: Will the configuration affect other applications?**  
A: The tool only modifies settings related to Ollama and will not affect other applications.

**Q: How can I restore default settings?**  
A: The tool provides recovery options to quickly restore all changes.

## Contribution Guidelines

Issue reports and feature suggestions are welcome!

1. Fork the project
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Contact

Richard Sun - [@richardsun-ai](https://github.com/richardsun-ai)

Project Link: [https://github.com/richardsun-ai/ollama-safetool](https://github.com/richardsun-ai/ollama-safetool)