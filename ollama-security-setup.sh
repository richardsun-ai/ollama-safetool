#!/bin/bash

# 获取当前用户的环境变量
get_current_ollama_host() {
    if [ -n "$CURRENT_USER" ]; then
        su - $CURRENT_USER -c 'echo $OLLAMA_HOST'
    else
        echo $OLLAMA_HOST
    fi
}

# 检查是否有 root 权限
if [ "$EUID" -ne 0 ]; then 
    # 保存当前用户的环境变量设置
    CURRENT_USER=$USER
    CURRENT_HOME=$HOME
    
    # 使用 sudo 重新运行脚本
    echo "需要 root 权限，使用 sudo 重新运行..."
    sudo CURRENT_USER=$CURRENT_USER CURRENT_HOME=$CURRENT_HOME "$0" "$@"
    exit $?
fi

# 使用保存的用户信息
USER=${CURRENT_USER:-$USER}
HOME=${CURRENT_HOME:-$HOME}

# 创建配置目录
CONFIG_DIR="$HOME/.ollama-security"
mkdir -p "$CONFIG_DIR"

# 确保配置目录存在并设置正确的所有权
if [ -n "$CURRENT_USER" ]; then
    mkdir -p ~/.ollama
    chown -R $CURRENT_USER:$(id -gn $CURRENT_USER) ~/.ollama
fi

# 显示菜单
show_menu() {
    clear
    echo "====== Ollama 安全配置工具 ======"
    echo "基础配置:"
    echo "1. 设置环境变量"
    echo "2. 配置防火墙规则"
    echo "3. 安全检查和建议"
    echo ""
    echo "运行管理:"
    echo "4. 启动 Ollama 并选择模型"
    echo "5. 查看运行日志"
    echo ""
    echo "快捷操作:"
    echo "6. 应用基础安全配置 (选项 1-3)"
    echo "0. 退出"
    echo "=============================="
}

# 配置防火墙
configure_firewall() {
    echo "===== 防火墙配置 ====="
    
    # 从配置文件获取 host 设置
    if [ -f ~/.ollama/config ]; then
        CONFIG_HOST=$(grep "host" ~/.ollama/config | cut -d'"' -f2)
    else
        CONFIG_HOST="127.0.0.1"
    fi
    
    echo "⚙️ 正在配置系统防火墙..."
    echo "📝 设置防火墙规则:"
    echo "• 只允许 $CONFIG_HOST:11434 访问 Ollama"
    
    # 创建防火墙规则文件
    cat > /etc/pf.anchors/ollama << EOF
rdr pass on lo0 inet proto tcp from any to any port 11434 -> $CONFIG_HOST port 11434
block in on ! lo0 proto tcp from any to any port 11434
EOF
    
    # 在主配置文件中添加规则
    if ! grep -q "anchor \"ollama\"" /etc/pf.conf; then
        echo "anchor \"ollama\"" >> /etc/pf.conf
    fi
    
    # 加载规则
    echo "⚙️ 正在应用防火墙规则..."
    pfctl -f /etc/pf.conf 2>/dev/null
    
    echo "✅ 防火墙配置完成"
    echo "只允许 $CONFIG_HOST:11434 访问 Ollama"
}

# 配置设置
configure_env() {
    echo "===== Ollama 配置 ====="
    
    # 读取当前配置
    if [ -f ~/.ollama/config ]; then
        CURRENT_HOST=$(grep "host" ~/.ollama/config | cut -d'"' -f2)
        echo "当前设置: host = $CURRENT_HOST"
    else
        echo "当前设置: 未配置 (默认 127.0.0.1)"
    fi
    
    # 检查环境变量
    if [ -n "$OLLAMA_HOST" ]; then
        echo -e "\n发现环境变量: OLLAMA_HOST = $OLLAMA_HOST"
        echo "[提示] 手动删除此变量的步骤:"
        echo "1. 编辑 ~/.zshrc 或 ~/.bash_profile"
        echo "2. 找到并删除 export OLLAMA_HOST=xxx 这一行"
        echo "3. 保存文件"
        echo "4. 执行 source ~/.zshrc 或 source ~/.bash_profile"
        echo "5. 重启 Ollama 服务"
    fi
    
    # 原有的配置选项保持不变
    echo -e "\n请选择 Ollama 访问模式:"
    echo "1. 仅 VPN 使用 (输入 VPN IP)"
    echo "2. 仅本地使用 (127.0.0.1)"
    read -p "请选择 [1-2]: " choice
    
    # 保持原有的配置逻辑不变
    case $choice in
        1)
            read -p "请输入您的 VPN IP 地址: " vpn_ip
            if [ -z "$vpn_ip" ]; then
                echo "❌ IP 地址不能为空"
                return
            fi
            # 写入配置
            if [ -n "$CURRENT_USER" ]; then
                echo "host = \"$vpn_ip\"" | sudo -u $CURRENT_USER tee ~/.ollama/config > /dev/null
                chown $CURRENT_USER:$(id -gn $CURRENT_USER) ~/.ollama/config
            else
                echo "host = \"$vpn_ip\"" > ~/.ollama/config
            fi
            ;;
        2)
            # 写入配置
            if [ -n "$CURRENT_USER" ]; then
                echo "host = \"127.0.0.1\"" | sudo -u $CURRENT_USER tee ~/.ollama/config > /dev/null
                chown $CURRENT_USER:$(id -gn $CURRENT_USER) ~/.ollama/config
            else
                echo "host = \"127.0.0.1\"" > ~/.ollama/config
            fi
            ;;
    esac
    
    # 重启 Ollama 服务
    echo "⚙️ 重启 Ollama 服务..."
    pkill ollama
    sleep 2
    echo "✅ 新设置已生效"
    echo "请使用选项 4 重新启动 Ollama"
}

# 安全检查和建议
security_check_and_advice() {
    echo "===== 安全检查和建议 ====="
    
    # 检查 SIP 状态
    echo "🔍 检查系统完整性保护(SIP)状态:"
    if csrutil status | grep -q "enabled"; then
        echo "✅ 系统完整性保护(SIP)已完全启用"
        echo "   这是最安全的配置，可以防止系统被恶意修改"
    else
        echo "⚠️ 系统完整性保护(SIP)未完全启用，当前状态:"
        
        # 检查各个保护项
        if csrutil status | grep -q "Apple Internal: disabled"; then
            echo "❌ 苹果内部功能：已禁用"
            echo "   这是正常的，普通用户不需要此功能"
        fi
        
        if csrutil status | grep -q "Kext Signing: disabled"; then
            echo "⚠️ 内核扩展签名：已禁用"
            echo "   建议：启用此功能可以防止未经签名的内核扩展加载"
        fi
        
        if csrutil status | grep -q "Filesystem Protections: disabled"; then
            echo "⚠️ 文件系统保护：已禁用"
            echo "   建议：启用此功能可以保护系统文件不被修改"
        fi
        
        if csrutil status | grep -q "Debugging Restrictions: disabled"; then
            echo "⚠️ 调试限制：已禁用"
            echo "   建议：启用此功能可以防止未授权的程序调试系统进程"
        fi
        
        if csrutil status | grep -q "DTrace Restrictions: disabled"; then
            echo "⚠️ DTrace限制：已禁用"
            echo "   建议：启用此功能可以限制 DTrace 的使用范围"
        fi
        
        if csrutil status | grep -q "NVRAM Protections: disabled"; then
            echo "⚠️ NVRAM保护：已禁用"
            echo "   建议：启用此功能可以防止系统设置被恶意修改"
        fi
        
        if csrutil status | grep -q "BaseSystem Verification: enabled"; then
            echo "✅ 系统基础验证：已启用"
            echo "   很好，这保护了系统核心组件"
        fi
        
        echo -e "\n🔧 如何启用完整的系统保护："
        echo "1. 重启 Mac"
        echo "2. 开机时按住 Command + R 进入恢复模式"
        echo "3. 点击实用工具 > 终端"
        echo "4. 输入：csrutil enable"
        echo "5. 重启电脑"
    fi
    
    # 检查防火墙状态
    echo -e "\n🔍 检查应用防火墙状态:"
    if /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate | grep -q "enabled"; then
        echo "✅ 应用防火墙已启用"
        echo "   这有助于保护您的系统免受网络攻击"
    else
        echo "⚠️ 应用防火墙未启用"
        echo "建议：启用应用防火墙"
        echo "1. 打开系统偏好设置"
        echo "2. 点击安全性与隐私"
        echo "3. 切换到防火墙标签"
        echo "4. 点击启用防火墙"
    fi
    
    # 检查文件共享
    echo -e "\n🔍 检查文件共享服务状态:"
    if [ -n "$(launchctl list | grep smbd)" ]; then
        echo "⚠️ 文件共享服务正在运行"
        echo "建议：如果不需要与其他设备共享文件，建议关闭此服务"
        echo "1. 打开系统偏好设置"
        echo "2. 点击共享"
        echo "3. 取消选中文件共享"
        launchctl list | grep smbd
    else
        echo "✅ 文件共享服务未运行"
        echo "   这减少了系统的攻击面"
    fi
    
    # 检查 Ollama 端口
    echo -e "\n🔍 检查 Ollama 端口状态:"
    if lsof -i :11434 | grep -q "LISTEN"; then
        # 检查是否是 Ollama 在使用端口
        if lsof -i :11434 | grep -q "ollama.*LISTEN"; then
            echo "✅ 端口 11434 正在被 Ollama 使用"
            echo "   连接信息:"
            lsof -i :11434
        else
            echo "⚠️ 端口 11434 被其他程序占用"
            echo "   当前占用端口的进程:"
            lsof -i :11434
            echo "建议：停止占用端口的程序，确保端口可供 Ollama 使用"
        fi
    else
        echo "✅ 端口 11434 未被占用"
        echo "   Ollama 可以正常启动"
    fi
    
    # 检查 Ollama 进程
    echo -e "\n🔍 检查 Ollama 进程状态:"
    if ps aux | grep -v grep | grep -q "ollama"; then
        echo "✅ Ollama 正在运行"
        echo "   当前进程信息:"
        ps aux | grep ollama | grep -v grep
    else
        echo "❌ Ollama 未运行"
        echo "建议：如果要使用 Ollama，请使用选项 4 启动服务"
    fi
}

# 列出可用模型
list_models() {
    echo "===== 模型列表 ====="
    echo "🔍 获取已安装的模型..."
    
    models=$(ollama list | awk 'NR>1 {print $1}')
    if [ -z "$models" ]; then
        echo "❌ 没有找到已下载的模型"
        return 1
    fi
    
    echo "✅ 已安装的模型:"
    echo "----------------------------------------"
    echo "序号  名称                大小      修改时间"
    ollama list | awk 'NR>1 {printf "%-5d %-20s %-9s %s\n", NR-1, $1, $3, $4" "$5}'
    echo "----------------------------------------"
    return 0
}

# 启动 Ollama
start_ollama() {
    echo "===== Ollama 服务管理 ====="
    
    # 使用正确的用户主目录
    USER_HOME=$(eval echo ~$CURRENT_USER)
    CONFIG_FILE="$USER_HOME/.ollama/config"
    
    # 从配置文件读取 host 设置
    if [ -f "$CONFIG_FILE" ]; then
        CONFIG_HOST=$(grep "host" "$CONFIG_FILE" | cut -d'"' -f2)
        echo "📝 使用配置文件设置: host = $CONFIG_HOST (配置文件: $CONFIG_FILE)"
    else
        echo "⚠️ 未找到配置文件，创建默认配置..."
        CONFIG_HOST="127.0.0.1"
        echo "host = \"$CONFIG_HOST\"" > "$CONFIG_FILE"
        echo "✅ 已创建默认配置: host = $CONFIG_HOST"
    fi
    
    echo "🔍 检查 Ollama 状态..."
    echo "• 使用地址: $CONFIG_HOST:11434"
    
    # 先停止现有的 Ollama 进程
    if pgrep -x "ollama" > /dev/null; then
        echo "⚙️ 停止现有的 Ollama 进程..."
        pkill ollama
        sleep 2
    fi
    
    echo "⚙️ 启动 Ollama 服务..."
    if [ -n "$CURRENT_USER" ]; then
        # 使用正确的用户身份启动服务
        sudo -u $CURRENT_USER bash -c "OLLAMA_HOST=$CONFIG_HOST ollama serve > /dev/null 2>&1 &"
    else
        OLLAMA_HOST=$CONFIG_HOST ollama serve > /dev/null 2>&1 &
    fi
    sleep 2
    echo "✅ Ollama 服务已启动"
    echo "📝 监听地址: $CONFIG_HOST:11434"
    
    if ! list_models; then
        echo "⚠️ 请先使用 'ollama pull' 下载模型"
        return
    fi
    
    echo
    read -p "请选择要使用的模型编号: " model_num
    
    # 获取选择的模型名称
    selected_model=$(ollama list | awk 'NR>1 {print $1}' | sed -n "${model_num}p")
    
    if [ -n "$selected_model" ]; then
        echo "🚀 启动模型: $selected_model"
        # 在新终端窗口中运行模型
        if [ "$(uname)" == "Darwin" ]; then
            # macOS - 使用完整命令字符串
            CMD="export OLLAMA_HOST=$CONFIG_HOST && ollama run $selected_model"
            osascript -e "tell application \"Terminal\" to do script \"$CMD\""
        else
            # 其他 Unix 系统
            x-terminal-emulator -e "export OLLAMA_HOST=$CONFIG_HOST && ollama run $selected_model" &
        fi
        echo "✅ 模型已在新窗口中启动"
        echo "• 访问地址: $CONFIG_HOST:11434"
    else
        echo "❌ 无效的选择"
    fi
}

# 应用所有配置
apply_all() {
    echo "===== 应用所有基础配置 ====="
    echo "1. 配置防火墙 (限制端口访问)"
    configure_firewall
    
    echo -e "\n2. 配置环境变量 (设置 OLLAMA_HOST)"
    configure_env
    
    echo -e "\n3. 安全检查和建议"
    security_check_and_advice
    
    echo -e "\n✅ 基础配置已完成"
}

# 查看日志
view_logs() {
    echo "===== Ollama 日志查看 ====="
    LOG_FILE="$HOME/.ollama/logs/server.log"
    
    if [ ! -f "$LOG_FILE" ]; then
        echo "❌ 日志文件不存在: $LOG_FILE"
        echo "请先运行 Ollama 服务生成日志"
        return
    fi
    
    echo "📝 日志查看选项:"
    echo "1. 实时查看日志 (按 Ctrl+C 退出)"
    echo "2. 查看最新 50 行"
    echo "3. 查看错误信息"
    echo "0. 返回主菜单"
    
    read -p "请选择 [0-3]: " log_choice
    
    case $log_choice in
        1)
            echo "📝 实时查看日志 (按 Ctrl+C 退出)..."
            tail -f "$LOG_FILE"
            ;;
        2)
            echo "📝 最新 50 行日志:"
            echo "----------------------------------------"
            tail -n 50 "$LOG_FILE"
            echo "----------------------------------------"
            ;;
        3)
            echo "📝 错误信息:"
            echo "----------------------------------------"
            grep -i "error\|failed\|warning" "$LOG_FILE" | tail -n 20
            echo "----------------------------------------"
            ;;
        0)
            return
            ;;
        *)
            echo "❌ 无效选择"
            ;;
    esac
}

# 主循环
while true; do
    show_menu
    read -p "请选择操作 [0-6]: " choice
    
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
        0) echo "退出程序"; exit 0 ;;
        *) echo "无效选择，请重试" ;;
    esac
    
    echo
    read -p "按回车键继续..."
done
