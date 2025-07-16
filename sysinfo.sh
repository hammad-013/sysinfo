#!/bin/bash

bold=$(tput bold)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

current_user="$(whoami)"
host_name="$(hostname)"
current_date="$(date)"
up_time="$(uptime -p | cut -c4-)"
kernel_version="$(uname -r)"
no_of_users_logged_in="$(who | wc -l)"
linux_distro=$(hostnamectl | grep Operating | awk -F':' '{ print $2 }' | cut -c2-)
architecture=$(hostnamectl | grep Architecture | awk -F':' '{ print $2 }' | cut -c2-)
hardware=$(hostnamectl | grep Hardware | awk -F':' '{ print $2 }' | cut -c2- | tr '\n' ' ')

if command -v dpkg >/dev/null 2>&1; then
    package_manager="dpkg"
elif command -v pacman >/dev/null 2>&1; then
    package_manager="pacman"
elif command -v dnf >/dev/null 2>&1; then
    package_manager="dnf"
elif command -v zypper >/dev/null 2>&1; then
    package_manager="zypper"
elif command -v apk >/dev/null 2>&1; then
    package_manager="apk"
elif command -v xbps-install >/dev/null 2>&1; then
    package_manager="xbps"
elif command -v eopkg >/dev/null 2>&1; then
    package_manager="eopkg"
elif command -v nix-env >/dev/null 2>&1; then
    package_manager="nix"
else
    echo "Unknown package manager"
fi
no_of_packages=$(dpkg --get-selections | wc -l)
shell=$(echo "$SHELL" | awk -F'/' '{ print $3 }')
shell_version=$("$shell" --version | head -n 1)
resolution=$(xrandr | grep '*' | awk '{ print $1}')
desktop_environment=$(echo "$DESKTOP_SESSION" | tr a-z A-Z)
terminal=$(ps -o comm= -p $(ps -o ppid= -p $(ps -o ppid= $$)) | tr a-z A-Z)
cpu=$(cat /proc/cpuinfo | grep -i "model name" | head -n 1 | awk -F':' '{ print $2}' | cut -c2-)
gpu=$(lspci | grep -i vga | awk -F':' '{ print $3}' | cut -c2-)
total_ram=$(free -h | grep -i '^mem' | awk '{print $2}')
used_ram=$(free -h | grep -i '^mem' | awk '{print $3}')

clear

echo ""
figlet -t -f ANSI\ Shadow "$linux_distro" -w 100 | lolcat

echo ""
echo "${bold}${GREEN}$current_user${NORMAL}@${bold}${GREEN}$host_name${NORMAL}"
echo "${bold}${GREEN}No. of Users Logged In${NORMAL}: $no_of_users_logged_in"
echo "${bold}${GREEN}-------------------------${NORMAL}"
echo "${bold}${GREEN}OS${NORMAL}: $linux_distro $architecture"
echo "${bold}${GREEN}Hardware${NORMAL}: $hardware"
echo "${bold}${GREEN}Kernel${NORMAL}: $kernel_version"
echo "${bold}${GREEN}Uptime${NORMAL}: $up_time"
echo "${bold}${GREEN}Packages${NORMAL}: $no_of_packages ($package_manager)"
echo "${bold}${GREEN}Shell${NORMAL}: $shell_version"
echo "${bold}${GREEN}Resolution${NORMAL}: $resolution"
echo "${bold}${GREEN}DE${NORMAL}: $desktop_environment"
echo "${bold}${GREEN}Terminal${NORMAL}: $terminal"
echo "${bold}${GREEN}CPU${NORMAL}: $cpu"
echo "${bold}${GREEN}GPU${NORMAL}: $gpu"
echo "${bold}${GREEN}Memory${NORMAL}: $used_ram / $total_ram"
echo ""
