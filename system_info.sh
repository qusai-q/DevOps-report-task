#!/bin/bash


SERVER_IP=$(hostname -I | awk '{print $1}')
PUBLIC_IP=$(curl -s https://ifconfig.me || echo "N/A")

OS_INFO=$(lsb_release -d | awk -F"\t" '{print $2}')
KERNEL=$(uname -r)
ARCH=$(uname -m)
VIRT=$(systemd-detect-virt)

SERVER_TIME=$(date)
TIMEZONE=$(timedatectl | grep "Time zone" | awk '{print $3 " " $4}')
UPTIME=$(uptime -p | sed 's/up //')

MEM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
MEM_USED=$(free -h | awk '/Mem:/ {print $3}')
SWAP_USED=$(free -h | awk '/Swap:/ {print $3}')
SWAP_TOTAL=$(free -h | awk '/Swap:/ {print $2}')
CPU_CORES=$(nproc)

echo "System Information"
echo "Executed By: $(whoami)"
echo "Hostname: $(hostname)"
echo "Server IP: $SERVER_IP"
echo "Public IP: $PUBLIC_IP"
echo "OS Type and Version: $OS_INFO"
echo "Kernel Version: $KERNEL"
echo "Architecture: $ARCH"
echo "Virtualization: $VIRT"
echo "Server Time: $SERVER_TIME"
echo "Timezone: $TIMEZONE"
echo "Uptime: $UPTIME"
echo ""
echo "Resource Usage"
echo "Total Memory: $MEM_TOTAL"
echo "Memory Usage: $MEM_USED / $MEM_TOTAL"
echo "Swap Usage: $SWAP_USED / $SWAP_TOTAL"
echo "CPU Cores: $CPU_CORES"
