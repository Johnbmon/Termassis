#!/bin/bash

# terminal-assistant.sh - A helpful terminal assistant

# Text colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Show welcome message
show_welcome() {
    echo -e "${GREEN}============================================${NC}"
    echo -e "${BLUE}Welcome to your Terminal Assistant!${NC}"
    echo -e "${GREEN}============================================${NC}"
    echo -e "Type ${YELLOW}help${NC} to see available commands"
    echo ""
}

# Show help menu
show_help() {
    echo -e "  ${BLUE}Available commands:${NC}"
    echo -e "  ${YELLOW}sys${NC}         - Show system information"
    echo -e "  ${YELLOW}net${NC}         - Show network information"
    echo -e "  ${YELLOW}disk${NC}        - Show disk space usage"
    echo -e "  ${YELLOW}proc${NC}        - Show top processes by CPU/memory"
    echo -e "  ${YELLOW}weather${NC}     - Show weather forecast"
    echo -e "  ${YELLOW}notes${NC}       - Manage quick notes"
    echo -e "  ${YELLOW}search${NC}      - Search for files"
    echo -e "  ${YELLOW}compress${NC}    - Compress files/directories"
    echo -e "  ${YELLOW}extract${NC}     - Extract compressed archives"
    echo -e "  ${YELLOW}Connect${NC}     - Show network connections"
    echo -e "  ${YELLOW}update${NC}      - Update system packages"
    echo -e "  ${YELLOW}help${NC}        - Show this help menu"
    echo -e "  ${YELLOW}exit${NC}        - Exit the assistant"
}

# System information
show_system_info() {
    echo -e "${BLUE}System Information:${NC}"
    echo -e "${GREEN}--------------------------------------------${NC}"
    echo -e "${YELLOW}OS:${NC} $(uname -o)"
    echo -e "${YELLOW}Kernel:${NC} $(uname -r)"
    echo -e "${YELLOW}Uptime:${NC} $(uptime -p)"
    echo -e "${YELLOW}Shell:${NC} $SHELL"
    echo -e "${YELLOW}CPU:${NC} $(grep -m 1 'model name' /proc/cpuinfo | cut -d':' -f2 | sed 's/^ *//')"
    echo -e "${YELLOW}Memory:${NC} $(free -h | grep Mem | awk '{print $3 " used of " $2 " total"}')"
}

# Network information
show_network_info() {
    echo -e "${BLUE}Network Information:${NC}"
    echo -e "${GREEN}--------------------------------------------${NC}"
    echo -e "${YELLOW}IP Addresses:${NC}"
    ip -4 addr show | grep -v 127.0.0.1 | grep inet | awk '{print "  " $2 " on " $NF}'
    echo ""
    echo -e "${YELLOW}DNS Servers:${NC}"
    grep nameserver /etc/resolv.conf | awk '{print "  " $2}'
    echo ""
    echo -e "${YELLOW}Internet Connection:${NC}"
    ping -c 1 -W 2 google.com > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "  ${GREEN}Connected${NC}"
    else
        echo -e "  ${RED}Disconnected${NC}"
    fi
}

# Disk space usage
show_disk_usage() {
    echo -e "${BLUE}Disk Space Usage:${NC}"
    echo -e "${GREEN}--------------------------------------------${NC}"
    df -h | grep -v tmp | grep -v dev | grep -v run
}

# Show top processes
show_top_processes() {
    echo -e "${BLUE}Top Processes:${NC}"
    echo -e "${GREEN}--------------------------------------------${NC}"
    echo -e "${YELLOW}By CPU:${NC}"
    ps aux --sort=-%cpu | head -6
    echo ""
    echo -e "${YELLOW}By Memory:${NC}"
    ps aux --sort=-%mem | head -6
}

# Show weather forecast
show_weather() {
    echo -e "${BLUE}Weather Forecast:${NC}"
    echo -e "${GREEN}--------------------------------------------${NC}"
    if command -v curl > /dev/null; then
        curl -s wttr.in/?0
    else
        echo -e "${RED}Error: curl is not installed.${NC}"
    fi
}

# Notes management
NOTES_FILE="$HOME/.terminal_assistant_notes.txt"

manage_notes() {
    if [ ! -f "$NOTES_FILE" ]; then
        touch "$NOTES_FILE"
    fi

    case "$1" in
        "add")
            shift
            if [ -n "$1" ]; then
                echo "$(date +"%Y-%m-%d %H:%M") - $*" >> "$NOTES_FILE"
                echo -e "${GREEN}Note added successfully!${NC}"
            else
                echo -e "${RED}Error: Note text is required.${NC}"
            fi
            ;;
        "list")
            if [ -s "$NOTES_FILE" ]; then
                echo -e "${BLUE}Your Notes:${NC}"
                echo -e "${GREEN}--------------------------------------------${NC}"
                cat -n "$NOTES_FILE"
            else
                echo -e "${YELLOW}No notes found.${NC}"
            fi
            ;;
        "clear")
            echo -n > "$NOTES_FILE"
            echo -e "${GREEN}All notes cleared!${NC}"
            ;;
        "delete")
            if [ -s "$NOTES_FILE" ]; then
                echo -e "${BLUE}Your Notes:${NC}"
                cat -n "$NOTES_FILE"
                echo ""
                read -p "Enter the note number to delete: " note_num
                if [[ $note_num =~ ^[0-9]+$ ]]; then
                    sed -i "${note_num}d" "$NOTES_FILE"
                    echo -e "${GREEN}Note #$note_num deleted!${NC}"
                else
                    echo -e "${RED}Error: Invalid number.${NC}"
                fi
            else
                echo -e "${YELLOW}No notes found.${NC}"
            fi
            ;;
        *)
            echo -e "${BLUE}Notes Management:${NC}"
            echo -e "  ${YELLOW}notes add <text>${NC}   - Add a new note"
            echo -e "  ${YELLOW}notes list${NC}         - List all notes"
            echo -e "  ${YELLOW}notes delete${NC}       - Delete a specific note"
            echo -e "  ${YELLOW}notes clear${NC}        - Clear all notes"
            ;;
    esac
}

# File search
search_files() {
    if [ -z "$1" ]; then
        echo -e "${RED}Error: Please specify a search pattern.${NC}"
        echo -e "Usage: ${YELLOW}search <pattern> [directory]${NC}"
        return
    fi

    local pattern="$1"
    local directory="${2:-.}"

    echo -e "${BLUE}Searching for '${pattern}' in ${directory}:${NC}"
    echo -e "${GREEN}--------------------------------------------${NC}"
    find "$directory" -type f -name "*${pattern}*" 2>/dev/null | while read -r file; do
        echo -e "${YELLOW}$(basename "$file")${NC} - $(dirname "$file")"
    done
}

# Compress files/directories
compress_files() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "${RED}Error: Missing arguments.${NC}"
        echo -e "Usage: ${YELLOW}compress <output_file> <files/directories...>${NC}"
        return
    fi

    local output="$1"
    shift

    if [[ "$output" == *.tar.gz ]]; then
        tar -czvf "$output" "$@"
    elif [[ "$output" == *.tar.bz2 ]]; then
        tar -cjvf "$output" "$@"
    elif [[ "$output" == *.tar ]]; then
        tar -cvf "$output" "$@"
    elif [[ "$output" == *.zip ]]; then
        zip -r "$output" "$@"
    else
        echo -e "${RED}Error: Unsupported format. Use .tar.gz, .tar.bz2, .tar, or .zip${NC}"
        return
    fi

    echo -e "${GREEN}Successfully compressed to $output${NC}"
}

# Extract archives
extract_archive() {
    if [ -z "$1" ]; then
        echo -e "${RED}Error: Please specify an archive to extract.${NC}"
        echo -e "Usage: ${YELLOW}extract <archive_file>${NC}"
        return
    fi

    if [ ! -f "$1" ]; then
        echo -e "${RED}Error: '$1' is not a valid file.${NC}"
        return
    fi

    case "$1" in
        *.tar.bz2)  tar -xjvf "$1"   ;;
        *.tar.gz)   tar -xzvf "$1"   ;;
        *.tar.xz)   tar -xJvf "$1"   ;;
        *.bz2)      bunzip2 "$1"     ;;
        *.rar)      unrar x "$1"     ;;
        *.gz)       gunzip "$1"      ;;
        *.tar)      tar -xvf "$1"    ;;
        *.tbz2)     tar -xjvf "$1"   ;;
        *.tgz)      tar -xzvf "$1"   ;;
        *.zip)      unzip "$1"       ;;
        *.Z)        uncompress "$1"  ;;
        *.7z)       7z x "$1"        ;;
        *)          echo -e "${RED}Error: '$1' cannot be extracted via this function.${NC}" ;;
    esac
}
# Show network connections
show_connections() {
    echo ""
    echo -e "${YELLOW}Open Ports and Active Connections:${NC}"
    netstat -antpul 2>/dev/null || echo -e "  ${RED}netstat command not found or requires sudo${NC}" 
}    
# Update system packages
update_system() {
    echo -e "${BLUE}Updating system packages:${NC}"
    echo -e "${GREEN}--------------------------------------------${NC}"
    
    if command -v apt > /dev/null; then
        sudo apt update && sudo apt upgrade -y
    elif command -v dnf > /dev/null; then
        sudo dnf update -y
    elif command -v yum > /dev/null; then
        sudo yum update -y
    elif command -v pacman > /dev/null; then
        sudo pacman -Syu --noconfirm
    elif command -v zypper > /dev/null; then
        sudo zypper update -y
    elif command -v brew > /dev/null; then
        brew update && brew upgrade
    else
        echo -e "${RED}Error: Package manager not recognized.${NC}"
        return
    fi
    
    echo -e "${GREEN}System update completed!${NC}"
}

# Main loop
main() {
    show_welcome

    while true; do
        echo -en "${YELLOW}assistant${NC} > "
        read -r cmd args

        case "$cmd" in
            "help")
                show_help
                ;;
            "sys")
                show_system_info
                ;;
            "net")
                show_network_info
                ;;
            "disk")
                show_disk_usage
                ;;
            "proc")
                show_top_processes
                ;;
            "weather")
                show_weather
                ;;
            "notes")
                manage_notes $args
                ;;
            "search")
                search_files $args
                ;;
            "compress")
                compress_files $args
                ;;
            "extract")
                extract_archive $args
                ;;
            "conn")
                show_connections
                ;;
            "update")
                update_system
                ;;
            "exit"|"quit"|"q")
                echo -e "${GREEN}Thank you for using Terminal Assistant. Goodbye!${NC}"
                break
                ;;
            "")
                # Do nothing for empty input
                ;;
            *)
                echo -e "${RED}Unknown command: $cmd${NC}"
                echo -e "Type ${YELLOW}help${NC} to see available commands"
                ;;
        esac
        echo ""
    done
}

# Start the assistant
main
