# system-audit

Audit scripts + notes.

## Findings (Baseline)
- Kernel: WSL2 Linux 6.6.x (virtualized environment)
- SUID binaries: captured in report (review for unusual entries)
- World-writable dirs: limited scope (/tmp, /var/tmp, /home)
- SSH config: may not exist in WSL unless ssh-server installed
- Auth logs: may be missing in WSL by default
