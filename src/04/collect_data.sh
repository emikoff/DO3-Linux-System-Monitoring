#!/bin/bash

# Системные данные
system_data() {
    HOSTNAME=$(hostname)
    USER=$(whoami)
    OS=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"' | head -n1)
    DATE=$(date +"%d %b %Y %H:%M:%S")
    UPTIME=$(uptime -p | sed 's/^up //')
    UPTIME_SEC=$(awk '{print int($1)}' /proc/uptime)
}

# Часовой пояс и UTC-смещение
time_data() {
    local time_zone
    local utc_offset

    time_zone=$(timedatectl show --property=Timezone --value)
    utc_offset=$(date +%:z)
    utc_offset=${utc_offset/+0/+}
    utc_offset=${utc_offset/-0/-}
    TIMEZONE="$time_zone UTC $utc_offset"
}

# Сеть
ip_config() {
    local ip_info
    local ip_with_prefix
    local prefix
    local interface

    ip_info=$(ip -o -4 addr show scope global | head -n1)
    ip_with_prefix=$(echo "$ip_info" | awk '{print $4}')
    prefix=$(echo "$ip_with_prefix" | cut -d/ -f2)
    IP=$(echo "$ip_with_prefix" | cut -d/ -f1)
    MASK=$(ifconfig | grep -F "$IP" | awk 'NR == 1 {print $4}')
    interface=$(echo "$ip_info" | awk '{print $2}')
    GATEWAY=$(ip route | grep "$interface" | grep "default" | awk '{print $3}')
}

# RAM
ram_data() {
    RAM_TOTAL=$(free -b | grep "Mem" | awk '{printf "%.3f GB", $2/(1024^3)}')
    RAM_USED=$(free -b | grep "Mem" | awk '{printf "%.3f GB", $3/(1024^3)}')
    RAM_FREE=$(free -b | grep "Mem" | awk '{printf "%.3f GB", $4/(1024^3)}')
}

# Диск
space_data() {
    SPACE_ROOT=$(df -k / | awk 'NR==2 {printf "%.2f MB", $2/1024}')
    SPACE_ROOT_USED=$(df -k / | awk 'NR==2 {printf "%.2f MB", $3/1024}')
    SPACE_ROOT_FREE=$(df -k / | awk 'NR==2 {printf "%.2f MB", $4/1024}')
}
