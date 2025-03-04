# Set UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# Set code page
$null = & cmd /c chcp 65001

# Check admin permissions
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Requires administrator privileges, restarting..."
    Start-Process powershell -Verb RunAs -ArgumentList "-File `"$PSCommandPath`"" 
    exit
}

# Display Menu
function Show-Menu {
    Clear-Host
    Write-Host "====== Ollama Security Configuration Tool ======"
    Write-Host "Basic Configuration:"
    Write-Host "1. Configure Settings"
    Write-Host "2. Configure Firewall Rules"
    Write-Host "3. Security Check and Advice"
    Write-Host ""
    Write-Host "Service Management:"
    Write-Host "4. Start Ollama and Select Model"
    Write-Host "5. View Logs"
    Write-Host ""
    Write-Host "Quick Actions:"
    Write-Host "6. Apply Basic Security Config (Options 1-3)"
    Write-Host "0. Exit"
    Write-Host "=============================="
}

# Configure Firewall
function Set-OllamaFirewall {
    Write-Host "===== Firewall Configuration ====="
    
    # Get host setting from config file
    $configFile = "$env:USERPROFILE\.ollama\config"
    if (Test-Path $configFile) {
        $configContent = Get-Content $configFile
        $CONFIG_HOST = $configContent -match 'host = "([^"]+)"' | ForEach-Object { $matches[1] }
    } else {
        $CONFIG_HOST = "127.0.0.1"
    }
    
    Write-Host "[INFO] Configuring system firewall..."
    Write-Host "[INFO] Setting firewall rules:"
    Write-Host "* Only allow $CONFIG_HOST:11434 to access Ollama"
    
    # Remove existing rules
    Remove-NetFirewallRule -DisplayName "Ollama" -ErrorAction SilentlyContinue
    
    # Create new rule
    New-NetFirewallRule -DisplayName "Ollama" -Direction Inbound -LocalPort 11434 -Protocol TCP -Action Allow -RemoteAddress $CONFIG_HOST
    
    # Verify firewall rules
    Write-Host "`n[INFO] Verifying firewall configuration:"
    $rule = Get-NetFirewallRule -DisplayName "Ollama" | Get-NetFirewallPortFilter
    if ($rule) {
        Write-Host "[OK] Firewall rule found:"
        Write-Host "* Rule name: Ollama"
        Write-Host "* Protocol: $($rule.Protocol)"
        Write-Host "* Local port: $($rule.LocalPort)"
        
        $addressFilter = Get-NetFirewallRule -DisplayName "Ollama" | Get-NetFirewallAddressFilter
        Write-Host "* Remote address: $($addressFilter.RemoteAddress)"
        
        # Test connection
        Write-Host "`n[INFO] Testing connection:"
        $testResult = Test-NetConnection -ComputerName $CONFIG_HOST -Port 11434 -WarningAction SilentlyContinue
        if ($testResult.TcpTestSucceeded) {
            Write-Host "[OK] Port 11434 is accessible from allowed IP"
        } else {
            Write-Host "[WARN] Port 11434 is not accessible, this might be expected if Ollama is not running"
        }
    } else {
        Write-Host "[ERROR] Firewall rule was not created successfully"
    }
    
    Write-Host "`n[INFO] You can also verify manually:"
    Write-Host "1. Open Windows Defender Firewall with Advanced Security"
    Write-Host "2. Click on 'Inbound Rules'"
    Write-Host "3. Look for rule named 'Ollama'"
    Write-Host "4. Double-click to view details"
}

# Set Environment Variables
function Set-OllamaConfig {
    Write-Host "===== Ollama Configuration ====="
    
    # Read current configuration
    $configFile = "$env:USERPROFILE\.ollama\config"
    if (Test-Path $configFile) {
        $configContent = Get-Content $configFile
        $currentHost = $configContent -match 'host = "([^"]+)"' | ForEach-Object { $matches[1] }
        Write-Host "Current setting: host = $currentHost"
    } else {
        Write-Host "Current setting: Not configured (default 127.0.0.1)"
    }
    
    # Check and show environment variable info
    $envHost = [Environment]::GetEnvironmentVariable("OLLAMA_HOST", "User")
    if ($envHost) {
        Write-Host "`nFound environment variable: OLLAMA_HOST = $envHost"
        Write-Host "[INFO] To remove this variable manually:"
        Write-Host "1. Press Win + R"
        Write-Host "2. Type 'sysdm.cpl' and press Enter"
        Write-Host "3. Go to 'Advanced' tab"
        Write-Host "4. Click 'Environment Variables'"
        Write-Host "5. Under 'User variables', find and remove 'OLLAMA_HOST'"
        Write-Host "6. Click 'OK' to save changes"
        Write-Host "7. Restart Ollama after removal"
    }

    # Configure host settings
    Write-Host "`nSelect Ollama access mode:"
    Write-Host "1. VPN only (enter VPN IP)"
    Write-Host "2. Local only (127.0.0.1)"
    Write-Host "0. Skip configuration"
    $choice = Read-Host "Choose [0-2]"
    
    switch ($choice) {
        "1" {
            $vpn_ip = Read-Host "Enter your VPN IP address"
            if ([string]::IsNullOrEmpty($vpn_ip)) {
                Write-Host "[ERROR] IP address cannot be empty"
                return
            }
            "host = `"$vpn_ip`"" | Set-Content $configFile
            Write-Host "[OK] Set host to $vpn_ip"
        }
        "2" {
            "host = `"127.0.0.1`"" | Set-Content $configFile
            Write-Host "[OK] Set host to 127.0.0.1"
        }
        "0" {
            Write-Host "[INFO] Skipping configuration"
            return
        }
        default {
            Write-Host "[ERROR] Invalid choice"
            return
        }
    }
    
    # Restart Ollama service
    Write-Host "[INFO] Restarting Ollama service..."
    Stop-Process -Name "ollama" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Write-Host "[OK] New settings applied"
    Write-Host "[INFO] Please use option 4 to restart Ollama"
}

# Security Check and Advice
function Security-CheckAndAdvice {
    Write-Host "===== Security Check ====="
    
    # Check Firewall
    $firewallStatus = Get-NetFirewallProfile
    if ($firewallStatus.Enabled) {
        Write-Host "[INFO] Checking Windows Firewall..."
        Write-Host "[OK] Windows Firewall is enabled"
    } else {
        Write-Host "[WARN] Windows Firewall is not enabled"
        Write-Host "Advice: Enable Windows Firewall to improve security"
    }
    
    # Check Ollama Port
    $portInUse = Get-NetTCPConnection -LocalPort 11434 -ErrorAction SilentlyContinue
    if ($portInUse) {
        $process = Get-Process -Id $portInUse.OwningProcess -ErrorAction SilentlyContinue
        if ($process.ProcessName -eq "ollama") {
            Write-Host "[NORMAL] Port 11434 is being used by Ollama"
        } else {
            Write-Host "[ERROR] Port 11434 is being used by another program: $($process.ProcessName)"
            Write-Host "Advice: Stop the process to allow Ollama to use this port"
        }
    } else {
        Write-Host "[NORMAL] Port 11434 is available for Ollama"
    }
    
    # Check Ollama Installation
    $ollamaPath = Get-Command ollama -ErrorAction SilentlyContinue
    if ($ollamaPath) {
        Write-Host "[NORMAL] Ollama is installed at: $($ollamaPath.Source)"
    } else {
        Write-Host "[ERROR] Ollama not found or not added to system path"
        Write-Host "Advice: Install Ollama or add it to the system PATH"
    }
}

# Start Ollama
function Start-OllamaService {
    Write-Host "===== Ollama Service Management ====="
    
    # Read host setting from config file
    $configFile = "$env:USERPROFILE\.ollama\config"
    if (Test-Path $configFile) {
        $configContent = Get-Content $configFile
        $CONFIG_HOST = $configContent -match 'host = "([^"]+)"' | ForEach-Object { $matches[1] }
        Write-Host "[INFO] Using configuration: host = $CONFIG_HOST"
    } else {
        Write-Host "[WARN] No config file found, creating default..."
        $CONFIG_HOST = "127.0.0.1"
        New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.ollama" | Out-Null
        "host = `"$CONFIG_HOST`"" | Set-Content $configFile
        Write-Host "[OK] Created default config: host = $CONFIG_HOST"
    }
    
    Write-Host "[INFO] Checking Ollama status..."
    Write-Host "* Using address: $CONFIG_HOST`:11434"
    
    # Stop existing process
    $ollamaProcess = Get-Process "ollama" -ErrorAction SilentlyContinue
    if ($ollamaProcess) {
        Write-Host "[INFO] Stopping existing Ollama process..."
        Stop-Process -Name "ollama" -Force
        Start-Sleep -Seconds 2
    }
    
    Write-Host "[INFO] Starting Ollama service..."
    $env:OLLAMA_HOST = $CONFIG_HOST
    Start-Process ollama -ArgumentList "serve" -WindowStyle Hidden
    Start-Sleep -Seconds 2
    Write-Host "[OK] Ollama service started"
    Write-Host "[INFO] Listening on: $CONFIG_HOST`:11434"
    
    # List models
    $models = ollama list
    if ($models.Count -le 1) {
        Write-Host "[WARN] Please use 'ollama pull' to download models first"
        return
    }
    
    Write-Host "`n[OK] Installed models:"
    Write-Host "----------------------------------------"
    Write-Host "No.   Name                Size      Modified"
    $modelList = @($models | Select-Object -Skip 1)
    $i = 0
    foreach ($model in $modelList) {
        Write-Host "$i     $model"
        $i++
    }
    Write-Host "----------------------------------------"
    
    $modelNum = Read-Host "`nSelect model number"
    # Convert input to integer and validate
    try {
        $modelIndex = [int]$modelNum
        if ($modelIndex -lt 0 -or $modelIndex -ge $modelList.Count) {
            Write-Host "[ERROR] Invalid model number"
            return
        }
        # Get the full model line and split it to get the model name
        $selectedModel = $modelList[$modelIndex].ToString().Split()[0]
        
        if ($selectedModel) {
            Write-Host "[INFO] Starting model: $selectedModel"
            $cmd = "Set-Item Env:OLLAMA_HOST '$CONFIG_HOST'; ollama run $selectedModel"
            Start-Process powershell -ArgumentList "-NoExit", "-Command", $cmd
            Write-Host "[OK] Model started in new window"
            Write-Host "* Access address: $CONFIG_HOST`:11434"
        } else {
            Write-Host "[ERROR] Invalid selection"
        }
    } catch {
        Write-Host "[ERROR] Please enter a valid number"
        return
    }
}

function View-OllamaLogs {
    Write-Host "===== Ollama Log Viewer ====="
    
    # Ollama logs are in LocalAppData
    $logPath = "$env:LOCALAPPDATA\Ollama"

    if (-not (Test-Path $logPath)) {
        Write-Host "[WARN] Ollama directory not found at: $logPath"
        Write-Host "[INFO] Please ensure Ollama is installed correctly"
        return
    }

    Write-Host "[INFO] Available log files:"
    Write-Host "1. Application logs (app*.log)"
    Write-Host "2. Server logs (server*.log)"
    Write-Host "3. View config.json"
    Write-Host "0. Return to main menu"

    $choice = Read-Host "> Choose log type [0-3]"

    switch ($choice) {
        "1" {
            $appLogs = Get-ChildItem -Path $logPath -Filter "app*.log" | Sort-Object LastWriteTime -Descending
            Write-Host "`n[INFO] Application logs:"
            for ($i = 0; $i -lt $appLogs.Count; $i++) {
                Write-Host "$($i+1). $($appLogs[$i].Name) - $($appLogs[$i].LastWriteTime)"
            }
            $logChoice = Read-Host "> Choose log number [1-$($appLogs.Count)]"
            if ($logChoice -match '^\d+$' -and [int]$logChoice -le $appLogs.Count) {
                $selectedLog = $appLogs[$logChoice-1].FullName
                Show-LogContent $selectedLog
            } else {
                Write-Host "[ERROR] Invalid selection"
            }
        }
        "2" {
            $serverLogs = Get-ChildItem -Path $logPath -Filter "server*.log" | Sort-Object LastWriteTime -Descending
            Write-Host "`n[INFO] Server logs:"
            for ($i = 0; $i -lt $serverLogs.Count; $i++) {
                Write-Host "$($i+1). $($serverLogs[$i].Name) - $($serverLogs[$i].LastWriteTime)"
            }
            $logChoice = Read-Host "> Choose log number [1-$($serverLogs.Count)]"
            if ($logChoice -match '^\d+$' -and [int]$logChoice -le $serverLogs.Count) {
                $selectedLog = $serverLogs[$logChoice-1].FullName
                Show-LogContent $selectedLog
            } else {
                Write-Host "[ERROR] Invalid selection"
            }
        }
        "3" {
            $configFile = "$logPath\config.json"
            if (Test-Path $configFile) {
                Write-Host "`n[INFO] Configuration file content:"
                Write-Host "----------------------------------------"
                Get-Content $configFile | ConvertFrom-Json | ConvertTo-Json -Depth 10
                Write-Host "----------------------------------------"
            } else {
                Write-Host "[WARN] config.json not found"
            }
        }
        "0" { return }
        default { Write-Host "[ERROR] Invalid option" }
    }
}

function Show-LogContent {
    param (
        [string]$logFile
    )
    Write-Host "`n[INFO] Log viewing options for $(Split-Path $logFile -Leaf):"
    Write-Host "1. View last 50 lines"
    Write-Host "2. View error messages"
    Write-Host "3. Monitor in real-time"
    Write-Host "0. Back"

    $viewChoice = Read-Host "> Choose option [0-3]"

    switch ($viewChoice) {
        "1" {
            Write-Host "`n[INFO] Last 50 lines:"
            Write-Host "----------------------------------------"
            Get-Content $logFile -Tail 50
            Write-Host "----------------------------------------"
        }
        "2" {
            Write-Host "`n[INFO] Error messages:"
            Write-Host "----------------------------------------"
            Get-Content $logFile | Select-String -Pattern "error","fail","warn" -CaseSensitive:$false
            Write-Host "----------------------------------------"
        }
        "3" {
            Write-Host "[INFO] Monitoring log (Press Ctrl+C to stop)..."
            Get-Content $logFile -Wait -Tail 10
        }
        "0" { return }
        default { Write-Host "[ERROR] Invalid option" }
    }
}

# Main loop
while ($true) {
    Show-Menu
    $choice = Read-Host "Select operation [0-6]"
    
    switch ($choice) {
        "1" { Set-OllamaConfig }
        "2" { Set-OllamaFirewall }
        "3" { Security-CheckAndAdvice }
        "4" { Start-OllamaService }
        "5" { View-OllamaLogs }
        "6" { 
            Set-OllamaConfig
            Set-OllamaFirewall
            Security-CheckAndAdvice
        }
        "0" { 
            Write-Host "Exiting program"
            exit 
        }
        default { Write-Host "[ERROR] Invalid selection, please try again" }
    }
    
    Write-Host
    Read-Host "Press Enter to continue..."
} 