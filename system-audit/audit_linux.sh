
echo "===== SYSTEM INFORMATION ====="
uname -a

echo "===== CPU INFO ====="
lscpu

echo "===== MEMORY ====="
free -h

echo "===== DISK ====="
lsblk
df -h

echo "===== NETWORK ====="
ip a
ss -tulnp

echo "===== RUNNING SERVICES (WSL-safe) ====="
if command -v systemctl >/dev/null 2>&1 && [ "$(ps -p 1 -o comm=)" = "systemd" ]; then
    systemctl list-units --type=service --state=running
else
    echo "[!] systemd not running (WSL environment). Showing top processes instead:"
    ps aux --sort=-%cpu | head -n 20
fi
