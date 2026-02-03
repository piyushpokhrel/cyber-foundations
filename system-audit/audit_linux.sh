
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
echo "===== USERS (whoami, id, /etc/passwd sample) ====="
whoami || true
id || true
echo "Users with shells (first 20):"
awk -F: '$7 !~ /(nologin|false)$/ {print $1 ":" $7}' /etc/passwd | head -n 20 || true
echo

echo "===== SUDO ACCESS ====="
if command -v sudo >/dev/null 2>&1; then
  sudo -n true 2>/dev/null && echo "[+] Current user has passwordless sudo" || echo "[-] No passwordless sudo (expected)"
else
  echo "[!] sudo not found"
fi
echo

echo "===== SUID BINARIES (top 30) ====="
# SUID files can be privilege escalation targets; listing is a common baseline check
find /usr /bin /sbin /usr/bin /usr/sbin -perm -4000 -type f 2>/dev/null | head -n 30
echo

echo "===== WORLD-WRITABLE DIRS (safe scope) ====="
# Limit scope to common places to avoid long scans in WSL
find /tmp /var/tmp /home -type d -perm -0002 2>/dev/null | head -n 50
echo

echo "===== SSH CONFIG (if present) ====="
if [ -f /etc/ssh/sshd_config ]; then
  egrep -i '^(PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|AllowUsers|AllowGroups)' /etc/ssh/sshd_config | sed 's/^/  /'
else
  echo "[!] /etc/ssh/sshd_config not found (ssh server may not be installed)"
fi
echo
echo "===== AUTH / LOGIN LOGS (best effort) ====="
if [ -f /var/log/auth.log ]; then
  echo "[+] /var/log/auth.log exists. Recent failed logins:"
  grep -i "failed password" /var/log/auth.log | tail -n 20 || true
elif [ -f /var/log/secure ]; then
  echo "[+] /var/log/secure exists. Recent failed logins:"
  grep -i "failed password" /var/log/secure | tail -n 20 || true
else
  echo "[!] No auth log found (/var/log/auth.log or /var/log/secure). This is common in WSL."
fi
echo
