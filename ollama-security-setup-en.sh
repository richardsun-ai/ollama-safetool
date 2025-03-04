#!/bin/bash

# Get current user's environment variables
get_current_ollama_host() {
    if [ -n "$CURRENT_USER" ]; then
        su - $CURRENT_USER -c 'echo $OLLAMA_HOST'
    else
        echo $OLLAMA_HOST
    fi
}

# Check for root privileges
if [ "$EUID" -ne 0 ]; then 
    # Save current user's environment variable settings
    CURRENT_USER=$USER
    CURRENT_HOME=$HOME
    
    # Use sudo to rerun the script
    echo "Root privileges required, rerunning with sudo..."
    sudo CURRENT_USER=$CURRENT_USER CURRENT_HOME=$CURRENT_HOME "$0" "$@"
    exit $?
fi

# Use saved user information
USER=${CURRENT_USER:-$USER}
HOME=${CURRENT_HOME:-$HOME}

# Create configuration directory
CONFIG_DIR="$HOME/.ollama-security"
mkdir -p "$CONFIG_DIR"

# Ensure configuration directory exists and set correct ownership
if [ -n "$CURRENT_USER" ]; then
    mkdir -p ~/.ollama
    chown -R $CURRENT_USER:$(id -gn $CURRENT_USER) ~/.ollama
fi

# Display Menu
show_menu() {
    clear
    echo "====== Ollama Security Configuration Tool ======"
    echo "Basic Configuration:"
    echo "1. Set Environment Variables"
    echo "2. Configure Firewall Rules"
    echo "3. Security Check and Advice"
    echo ""
    echo "Service Management:"
    echo "4. Start Ollama and Select Model"
    echo "5. View Logs"
    echo ""
    echo "Quick Actions:"
    echo "6. Apply Basic Security Configuration (Options 1-3)"
    echo "0. Exit"
    echo "=============================="
}

# Configure Firewall
configure_firewall() {
    echo "===== Firewall Configuration ====="
    
    # Get host setting from config file
    if [ -f ~/.ollama/config ]; then
        CONFIG_HOST=$(grep "host" ~/.ollama/config | cut -d'"' -f2)
    else
        CONFIG_HOST="127.0.0.1"
    fi
    
    echo "⚙️ Configuring system firewall..."
    echo "📝 Setting firewall rules:"
    echo "• Only allow $CONFIG_HOST:11434 to access Ollama"
    
    # Create firewall rules file
    cat > /etc/pf.anchors/ollama << EOF
rdr pass on lo0 inet proto tcp from any to any port 11434 -> $CONFIG_HOST port 11434
block in on ! lo0 proto tcp from any to any port 11434
EOF
    
    # Add rules to main configuration file
    if ! grep -q "anchor \"ollama\"" /etc/pf.conf; then
        echo "anchor \"ollama\"" >> /etc/pf.conf
    fi
    
    # Load rules
    echo "⚙️ Applying firewall rules..."
    pfctl -f /etc/pf.conf 2>/dev/null
    
    echo "✅ Firewall configuration completed"
    echo "Only $CONFIG_HOST:11434 is allowed to access Ollama"
}

# Configure settings
configure_env() {
    echo "===== Ollama Configuration ====="
    
    # Read current configuration
    if [ -f ~/.ollama/config ]; then
        CURRENT_HOST=$(grep "host" ~/.ollama/config | cut -d'"' -f2)
        echo "Current setting: host = $CURRENT_HOST"
    else
        echo "Current setting: Not configured (default 127.0.0.1)"
    fi
    
    # Check environment variables
    if [ -n "$OLLAMA_HOST" ]; then
        echo -e "\nFound environment variable: OLLAMA_HOST = $OLLAMA_HOST"
        echo "[Info] Steps to manually remove this variable:"
        echo "1. Edit ~/.zshrc or ~/.bash_profile"
        echo "2. Find and remove the line 'export OLLAMA_HOST=xxx'"
        echo "3. Save the file"
        echo "4. Execute 'source ~/.zshrc' or 'source ~/.bash_profile'"
        echo "5. Restart the Ollama service"
    fi
    
    # Keep the original configuration options unchanged
    echo -e "\nSelect Ollama access mode:"
    echo "1. VPN only (enter VPN IP)"
    echo "2. Local only (127.0.0.1)"
    read -p "Choose [1-2]: " choice
    
    # Keep the original configuration logic unchanged
    case $choice in
        1)
            read -p "Enter your VPN IP address: " vpn_ip
            if [ -z "$vpn_ip" ]; then
                echo "❌ IP address cannot be empty"
                return
            fi
            # Write configuration
            if [ -n "$CURRENT_USER" ]; then
                echo "host = \"$vpn_ip\"" | sudo -u $CURRENT_USER tee ~/.ollama/config > /dev/null
                chown $CURRENT_USER:$(id -gn $CURRENT_USER) ~/.ollama/config
            else
                echo "host = \"$vpn_ip\"" > ~/.ollama/config
            fi
            ;;
        2)
            # Write configuration
            if [ -n "$CURRENT_USER" ]; then
                echo "host = \"127.0.0.1\"" | sudo -u $CURRENT_USER tee ~/.ollama/config > /dev/null
                chown $CURRENT_USER:$(id -gn $CURRENT_USER) ~/.ollama/config
            else
                echo "host = \"127.0.0.1\"" > ~/.ollama/config
            fi
            ;;
    esac
    
    # Restart Ollama service
    echo "⚙️ Restarting Ollama service..."
    pkill ollama
    sleep 2
    echo "✅ New settings applied"
    echo "Please use option 4 to restart Ollama"
}

# Security check and advice
security_check_and_advice() {
    echo "===== Security Check and Advice ====="
    
    # Check SIP status
    echo "🔍 Checking System Integrity Protection (SIP) status:"
    if csrutil status | grep -q "enabled"; then
        echo "✅ System Integrity Protection (SIP) is fully enabled"
        echo "   This is the most secure configuration, preventing malicious system modifications"
    else
        echo "⚠️ System Integrity Protection (SIP) is not fully enabled, current status:"
        
        # Check each protection item
        if csrutil status | grep -q "Apple Internal: disabled"; then
            echo "❌ Apple Internal: disabled"
            echo "   This is normal, regular users don't need this feature"
        fi
        
        if csrutil status | grep -q "Kext Signing: disabled"; then
            echo "⚠️ Kernel Extension Signing: disabled"
            echo "   Recommendation: Enable this feature to prevent unsigned kernel extensions from loading"
        fi
        
        if csrutil status | grep -q "Filesystem Protections: disabled"; then
            echo "⚠️ Filesystem Protections: disabled"
            echo "   Recommendation: Enable this feature to protect system files from modification"
        fi
        
        if csrutil status | grep -q "Debugging Restrictions: disabled"; then
            echo "⚠️ Debugging Restrictions: disabled"
            echo "   Recommendation: Enable this feature to prevent unauthorized programs from debugging system processes"
        fi
        
        if csrutil status | grep -q "DTrace Restrictions: disabled"; then
            echo "⚠️ DTrace Restrictions: disabled"
            echo "   Recommendation: Enable this feature to limit DTrace usage scope"
        fi
        
        if csrutil status | grep -q "NVRAM Protections: disabled"; then
            echo "⚠️ NVRAM Protections: disabled"
            echo "   Recommendation: Enable this feature to prevent system settings from malicious modification"
        fi
        
        if csrutil status | grep -q "BaseSystem Verification: enabled"; then
            echo "✅ BaseSystem Verification: enabled"
            echo "   Good, this protects core system components"
        fi
        
        echo -e "\n🔧 How to enable full system protection:"
        echo "1. Restart your Mac"
        echo "2. Hold Command + R during startup to enter Recovery Mode"
        echo "3. Click Utilities > Terminal"
        echo "4. Enter: csrutil enable"
        echo "5. Restart your computer"
    fi
    
    # Check firewall status
    echo -e "\n🔍 Checking Application Firewall status:"
    if /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate | grep -q "enabled"; then
        echo "✅ Application Firewall is enabled"
        echo "   This helps protect your system from network attacks"
    else
        echo "⚠️ Application Firewall is not enabled"
        echo "Recommendation: Enable Application Firewall"
        echo "1. Open System Preferences"
        echo "2. Click Security & Privacy"
        echo "3. Switch to Firewall tab"
        echo "4. Click Enable Firewall"
    fi
    
    # Check file sharing
    echo -e "\n🔍 Checking File Sharing service status:"
    if [ -n "$(launchctl list | grep smbd)" ]; then
        echo "⚠️ File Sharing service is running"
        echo "Recommendation: If you don't need to share files with other devices, consider disabling this service"
        echo "1. Open System Preferences"
        echo "2. Click Sharing"
        echo "3. Uncheck File Sharing"
        launchctl list | grep smbd
    else
        echo "✅ File Sharing service is not running"
        echo "   This reduces the attack surface of your system"
    fi
    
    # Check Ollama port
    echo -e "\n🔍 Checking Ollama port status:"
    if lsof -i :11434 | grep -q "LISTEN"; then
        # Check if Ollama is using the port
        if lsof -i :11434 | grep -q "ollama.*LISTEN"; then
            echo "✅ Port 11434 is being used by Ollama"
            echo "   Connection information:"
            lsof -i :11434
        else
            echo "⚠️ Port 11434 is being used by another program"
            echo "   Process currently occupying the port:"
            lsof -i :11434
            echo "Recommendation: Stop the program occupying the port to make it available for Ollama"
        fi
    else
        echo "✅ Port 11434 is not occupied"
        echo "   Ollama can start normally"
    fi
    
    # Check Ollama process
    echo -e "\n🔍 Checking Ollama process status:"
    if ps aux | grep -v grep | grep -q "ollama"; then
        echo "✅ Ollama is running"
        echo "   Current process information:"
        ps aux | grep ollama | grep -v grep
    else
        echo "❌ Ollama is not running"
        echo "Recommendation: If you want to use Ollama, use option 4 to start the service"
    fi
}

# List available models
list_models() {
    echo "===== Model List ====="
    echo "🔍 Getting installed models..."
    
    models=$(ollama list | awk 'NR>1 {print $1}')
    if [ -z "$models" ]; then
        echo "❌ No downloaded models found"
        return 1
    fi
    
    echo "✅ Installed models:"
    echo "----------------------------------------"
    echo "No.   Name                Size      Modified"
    ollama list | awk 'NR>1 {printf "%-5d %-20s %-9s %s\n", NR-1, $1, $3, $4" "$5}'
    echo "----------------------------------------"
    return 0
}

# Start Ollama
start_ollama() {
    echo "===== Ollama Service Management ====="
    
    # Use correct user home directory
    USER_HOME=$(eval echo ~$CURRENT_USER)
    CONFIG_FILE="$USER_HOME/.ollama/config"
    
    # Read host setting from configuration file
    if [ -f "$CONFIG_FILE" ]; then
        CONFIG_HOST=$(grep "host" "$CONFIG_FILE" | cut -d'"' -f2)
        echo "📝 Using configuration file setting: host = $CONFIG_HOST (config file: $CONFIG_FILE)"
    else
        echo "⚠️ Configuration file not found, creating default configuration..."
        CONFIG_HOST="127.0.0.1"
        echo "host = \"$CONFIG_HOST\"" > "$CONFIG_FILE"
        echo "✅ Created default configuration: host = $CONFIG_HOST"
    fi
    
    echo "🔍 Checking Ollama status..."
    echo "• Using address: $CONFIG_HOST:11434"
    
    # First stop existing Ollama process
    if pgrep -x "ollama" > /dev/null; then
        echo "⚙️ Stopping existing Ollama process..."
        pkill ollama
        sleep 2
    fi
    
    echo "⚙️ Starting Ollama service..."
    if [ -n "$CURRENT_USER" ]; then
        # Use correct user identity to start service
        sudo -u $CURRENT_USER bash -c "OLLAMA_HOST=$CONFIG_HOST ollama serve > /dev/null 2>&1 &"
    else
        OLLAMA_HOST=$CONFIG_HOST ollama serve > /dev/null 2>&1 &
    fi
    sleep 2
    echo "✅ Ollama service started"
    echo "📝 Listening address: $CONFIG_HOST:11434"
    
    if ! list_models; then
        echo "⚠️ Please use 'ollama pull' to download models first"
        return
    fi
    
    echo
    read -p "Please select the model number to use: " model_num
    
    # Get the selected model name
    selected_model=$(ollama list | awk 'NR>1 {print $1}' | sed -n "${model_num}p")
    
    if [ -n "$selected_model" ]; then
        echo "🚀 Starting model: $selected_model"
        # Run the model in a new terminal window
        if [ "$(uname)" == "Darwin" ]; then
            # macOS - use complete command string
            CMD="export OLLAMA_HOST=$CONFIG_HOST && ollama run $selected_model"
            osascript -e "tell application \"Terminal\" to do script \"$CMD\""
        else
            # Other Unix systems
            x-terminal-emulator -e "export OLLAMA_HOST=$CONFIG_HOST && ollama run $selected_model" &
        fi
        echo "✅ Model started in a new window"
        echo "• Access address: $CONFIG_HOST:11434"
    else
        echo "❌ Invalid selection"
    fi
}

# Apply all configurations
apply_all() {
    echo "===== Apply All Basic Configurations ====="
    echo "1. Configure firewall (restrict port access)"
    configure_firewall
    
    echo -e "\n2. Configure environment variables (set OLLAMA_HOST)"
    configure_env
    
    echo -e "\n3. Security check and advice"
    security_check_and_advice
    
    echo -e "\n✅ Basic configuration completed"
}

# View logs
view_logs() {
    echo "===== Ollama Log Viewer ====="
    LOG_FILE="$HOME/.ollama/logs/server.log"
    
    if [ ! -f "$LOG_FILE" ]; then
        echo "❌ Log file does not exist: $LOG_FILE"
        echo "Please run the Ollama service first to generate logs"
        return
    fi
    
    echo "📝 Log viewing options:"
    echo "1. View logs in real-time (press Ctrl+C to exit)"
    echo "2. View the latest 50 lines"
    echo "3. View error messages"
    echo "0. Return to main menu"
    
    read -p "Please select [0-3]: " log_choice
    
    case $log_choice in
        1)
            echo "📝 Viewing logs in real-time (press Ctrl+C to exit)..."
            tail -f "$LOG_FILE"
            ;;
        2)
            echo "📝 Latest 50 lines of logs:"
            echo "----------------------------------------"
            tail -n 50 "$LOG_FILE"
            echo "----------------------------------------"
            ;;
        3)
            echo "📝 Error messages:"
            echo "----------------------------------------"
            grep -i "error\|failed\|warning" "$LOG_FILE" | tail -n 20
            echo "----------------------------------------"
            ;;
        0)
            return
            ;;
        *)
            echo "❌ Invalid selection"
            ;;
    esac
}

# Main loop
while true; do
    show_menu
    read -p "Please select operation [0-6]: " choice
    
    case $choice in
        1) configure_env ;;
        2) configure_firewall ;;
        3) security_check_and_advice ;;
        4) start_ollama ;;
        5) view_logs ;;
        6) 
            configure_env
            configure_firewall
            security_check_and_advice
            ;;
        0) echo "Exiting program"; exit 0 ;;
        *) echo "Invalid selection, please try again" ;;
    esac
    
    echo
    read -p "Press Enter to continue..."
done 