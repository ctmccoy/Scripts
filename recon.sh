#!/bin/bash

REQUIRED_PACKAGES=(lsb-release iproute2 lm-sensors)

echo "====== HOST RECONNAISSANCE ======"
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"

echo -e "\n=== PACKAGE CHECK ==="
MISSING=()
for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! dpkg -s "$pkg" &> /dev/null; then
        echo "Missing: $pkg"
        MISSING+=("$pkg")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo -e "\nInstalling missing packages: ${MISSING[*]}"
    sudo apt update
    sudo apt install -y "${MISSING[@]}"
else
    echo "All required packages are installed."
fi

echo -e "\n=== OS & KERNEL ==="
uname -a
[ -x "$(command -v lsb_release)" ] && lsb_release -a 2>/dev/null

echo -e "\n=== CURRENT USER & DIRECTORY ==="
echo "User: $(whoami)"
echo "Current Directory: $(pwd)"

echo -e "\n=== USER ACCOUNTS ==="
echo "Logged-in Users:"
who
echo -e "\nUser Count: $(getent passwd | wc -l)"
echo "Users with UID >= 1000:"
awk -F: '$3>=1000{print $1}' /etc/passwd

echo -e "\n=== NETWORKING INFO ==="
echo "IP Addresses:"
ip -4 addr show | grep inet
echo -e "\nMAC Addresses:"
ip link show | awk '/ether/ {print $2}'
echo -e "\nOpen Connections:"
ss -tuna | head -n 15

echo -e "\n=== DISK USAGE ==="
df -h | grep -E '^(/dev|Filesystem)'

echo -e "\n=== TEMPERATURE ==="
if command -v sensors &> /dev/null; then
    sensors
else
    echo "sensors command missing. Try running: sudo sensors-detect"
fi

echo -e "\n=== END OF REPORT ==="
