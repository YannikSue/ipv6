@echo off
echo --- Switch default distro to Debian-IPv6 ---
wsl --set-default Debian-IPv6

echo --- Set user to root ---
wsl --manage Debian-IPv6 --set-default-user root

echo --- Link testbed files to Debian-IPv6 ---
rem wsl bash -c "ln -s /root/ipv6 /mnt/c/Users/ulfl/Nextcloud/Documents/gitea.ipv6/testbed/debian"
wsl ln -sf /mnt/c/Users/ulfl/Nextcloud/Documents/gitea.ipv6/testbed/debian /root/ipv6
rem TODO: Such a symlink to "Users/ulfl" isn't a general solution

rem @echo --- Copy files to Debian-IPv6 ---
rem robocopy . \\wsl$\Debian-IPv6\root\ipv6 /s /e
rem wsl bash -c "rm -rf /root/ipv6/*Zone.Identifier"
rem wsl bash -c 'find /root/ipv6 -type f -iname "*.sh" -exec chmod +x {} \;'

echo --- Start wsl ---
wsl ~
