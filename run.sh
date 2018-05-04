#!/bin/bash
# A simple security and privacy check script for GNU/Linux.
# Written by Frihetskjemper under the Anarchist Unlicense.
# You can find the Anarchist Unlicense here:
# https://github.com/frihetskjemper

# Color defines
COLOR_NC='\e[0m' # No Color
COLOR_WHITE='\e[1;37m'
COLOR_BLACK='\e[0;30m'
COLOR_BLUE='\e[0;34m'
COLOR_LIGHT_BLUE='\e[1;34m'
COLOR_GREEN='\e[0;32m'
COLOR_LIGHT_GREEN='\e[1;32m'
COLOR_CYAN='\e[0;36m'
COLOR_LIGHT_CYAN='\e[1;36m'
COLOR_RED='\e[0;31m'
COLOR_LIGHT_RED='\e[1;31m'
COLOR_PURPLE='\e[0;35m'
COLOR_LIGHT_PURPLE='\e[1;35m'
COLOR_BROWN='\e[0;33m'
COLOR_YELLOW='\e[1;33m'
COLOR_GRAY='\e[0;30m'
COLOR_LIGHT_GRAY='\e[0;37m'

#### WGET STUFF ####
TOR=https://www.torproject.org/dist/torbrowser/7.5.3/tor-browser-linux64-7.5.3_en-US.tar.xz

#### ENVIRONMENT ####
function install_deps () {
    echo '[*] Checking to see if this computer has the required dependencies...'
    # First try Fedora
    sudo dnf install wget lolcat git figlet nmap clamav clamav-update rkhunter -y &> output.log
    # Then try to see if it's Debian/Ubuntu
    sudo apt install wget lolcat git figlet nmap clamav rkhunter -y &> output.log
    # Then try to see if it's Arch Linux.
    sudo pacman -S wget lolcat git figlet nmap clamav rkhunter -y &> output.log
}

function show_banner () {
    echo ""
    figlet -f smslant "ANARSCRIPT" | lolcat
    echo ""
}

#### CLAMAV ####
function clam_config () {
    echo [+] "This will require some manual configuration. Go to /etc/freshclam.conf and uncomment the appropriate server."
    freshclam
    echo "Done."
}

#### TOR BROWSER ####
function mktordir () {
    mkdir -p $HOME/bin/torbrowser/
}

function cdtordir () {
    cd $HOME/bin/torbrowser/
}

function cdbrowser () {
    cd $HOME/bin/torbrowser/tor-browser_en-US/
}

function tor_run () {
    if [ ! -d "$HOME/bin/torbrowser" ]; then
        mktordir
    fi
    cdtordir
    wget $TOR
    tar -xf tor-browser-linux64-7.5.3_en-US.tar.xz
    cdbrowser # CD in to tor dir
    ./start-tor-browser.desktop # Start Tor Browser session
}

#### VULN PATCH ####
function nmap() {
    echo "[+] Displaying nmap scan of your ports. It's up to you decide which ones to close, using a firewall utility such as ufw."
    nmap -A -T4 localhost
    echo "[+] Done."
}

function isdriveencrypted () {
    echo "[+] Check if your drive is encrypted. If TYPE says crypto_LUKS then your fine. If not, reinstall your distro right now and make sure to enable disk encryption."
    echo "[+] Checking sda1..."
    blkid /dev/sda1
    echo "[+] Checking sda2..."
    blkid /dev/sda2
    echo "[+] Checking sda3..."
    blkid /dev/sda3
    echo "[+] Checking sda4..."
    blkid /dev/sda4
    echo "[+] Done. "
}

function update_node () {
    ## Debian
    sudo apt update &> output.log
    sudo apt upgrade -y &> output.log
    ## Fedora
    sudo dnf update -y &> output.log
    ## Arch
    sudo pacman -Syu &> output.log
}

function vuln_check() {
    nmap
    isdriveencrypted
    update_node
}

### Privacy suite
function install_suite () {
    # Please create an issue of what tools should be installed here!
    echo "Coming soon!"
}

#### MAIN ####

function menu () {
    PS3='Please select an option from the menu> '
    options=("Run ClamAV Anti-virus" "Run Tor" "Check for vulnerabilities & Patch" "Install Privacy Suite (Debian Only for now)" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Run ClamAV Anti-virus")
                clam_config
                ;;
            "Run Tor")
                tor_run
                echo "[+] Done."
                echo "[+] Removing old Tor archive..."
                cdtordir
                rm tor*tar.xz
                echo "[+] Success."
                echo ""
                ;;
            "Check for vulnerabilities & Patch")
                vuln_check
                ;;
            "Install Privacy Suite (Debian Only for now)")
                install_suite
                ;;
            "Quit")
                break
                ;;
            *) echo invalid option;;
        esac
    done
}

function main () {
    install_deps
    show_banner
    menu
}
main
