#!/bin/bash

# ==============================
# COLORS
# ==============================
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

# ==============================
# HEADER
# ==============================
show_header() {
    clear
    echo -e "${RED}=====================================${RESET}"
    echo -e "${CYAN}        T3rn0xSk0ll - Crypto${RESET}"
    echo -e "${RED}=====================================${RESET}"
    echo ""
}

# ==============================
# PASSWORD CREATOR
# ==============================
password_creator() {
    show_header
    read -p "Length (default 16): " length
    length=${length:-16}

    # valida número
    [[ ! "$length" =~ ^[0-9]+$ ]] && echo "Invalid length" && sleep 1 && return

    tr -dc 'A-Za-z0-9!@#$%^&*()_+=' < /dev/urandom | head -c "$length"
    echo -e "\n"
    read -p "Press enter to continue..."
}

# ==============================
# PASSWORD ANALYZER
# ==============================
password_analyzer() {
    show_header
    read -p "Enter password: " pass

    [ -z "$pass" ] && echo "Empty password!" && sleep 1 && return

    score=0
    len=${#pass}

    [ $len -ge 12 ] && score=$((score+30))
    [ $len -ge 8 ] && score=$((score+15))

    [[ "$pass" =~ [A-Z] ]] && score=$((score+15))
    [[ "$pass" =~ [a-z] ]] && score=$((score+15))
    [[ "$pass" =~ [0-9] ]] && score=$((score+20))
    [[ "$pass" =~ [^A-Za-z0-9] ]] && score=$((score+20))

    echo ""
    echo "Score: $score%"

    if [ $score -lt 40 ]; then
        echo -e "${RED}Weak${RESET}"
    elif [ $score -lt 70 ]; then
        echo -e "${CYAN}Medium${RESET}"
    else
        echo -e "${GREEN}Strong${RESET}"
    fi

    echo ""
    read -p "Press enter to continue..."
}

# ==============================
# FILE ENCRYPT
# ==============================
file_encrypt() {
    show_header
    read -p "File to encrypt: " file

    [ ! -f "$file" ] && echo "File not found!" && sleep 1 && return

    read -s -p "Password: " pass
    echo ""

    openssl enc -aes-256-cbc -salt -in "$file" -out "$file.enc" -k "$pass"

    if [ $? -eq 0 ]; then
        echo "Encrypted -> $file.enc"
    else
        echo "Encryption failed"
    fi

    read -p "Press enter..."
}

# ==============================
# FILE DECRYPT
# ==============================
file_decrypt() {
    show_header
    read -p "File to decrypt (.enc): " file

    [ ! -f "$file" ] && echo "File not found!" && sleep 1 && return

    read -s -p "Password: " pass
    echo ""

    output="${file%.enc}"

    openssl enc -aes-256-cbc -d -in "$file" -out "$output" -k "$pass"

    if [ $? -eq 0 ]; then
        echo "Decrypted -> $output"
    else
        echo "Decryption failed"
    fi

    read -p "Press enter..."
}

# ==============================
# HASH GENERATOR
# ==============================
hash_generator() {
    show_header
    echo "1) MD5"
    echo "2) SHA1"
    echo "3) SHA256"
    echo ""

    read -p "Choose: " opt
    read -p "Text: " txt

    [ -z "$txt" ] && echo "Empty input!" && sleep 1 && return

    case $opt in
        1) echo -n "$txt" | md5sum ;;
        2) echo -n "$txt" | sha1sum ;;
        3) echo -n "$txt" | sha256sum ;;
        *) echo "Invalid" ;;
    esac

    echo ""
    read -p "Press enter..."
}

# ==============================
# RANDOM KEY GENERATOR
# ==============================
random_key() {
    show_header
    read -p "Key length (default 32): " len
    len=${len:-32}

    [[ ! "$len" =~ ^[0-9]+$ ]] && echo "Invalid length" && sleep 1 && return

    head -c 64 /dev/urandom | base64 | head -c "$len"
    echo -e "\n"
    read -p "Press enter..."
}

# ==============================
# TOOL CHECK
# ==============================
check_tools() {
    show_header
    echo -e "${CYAN}Checking Crypto Tools...${RESET}"
    echo ""

    tools=("openssl" "md5sum" "sha1sum" "sha256sum")

    for tool in "${tools[@]}"; do
        if command -v "$tool" &>/dev/null; then
            echo -e "$tool ${GREEN}✔${RESET}"
        else
            echo -e "$tool ${RED}✖${RESET}"
        fi
    done

    echo ""
    read -p "Press enter..."
}

# ==============================
# MAIN MENU
# ==============================
while true; do
    show_header

    echo -e "${WHITE}[1] Password Creator${RESET}"
    echo -e "${WHITE}[2] Password Analyzer${RESET}"
    echo -e "${WHITE}[3] Encrypt File${RESET}"
    echo -e "${WHITE}[4] Decrypt File${RESET}"
    echo -e "${WHITE}[5] Hash Generator${RESET}"
    echo -e "${WHITE}[6] Random Key Generator${RESET}"
    echo -e "${WHITE}[7] Tool Check${RESET}"
    echo -e "${RED}[0] Back${RESET}"
    echo ""

    read -p "Choose: " opt

    case $opt in
        1) password_creator ;;
        2) password_analyzer ;;
        3) file_encrypt ;;
        4) file_decrypt ;;
        5) hash_generator ;;
        6) random_key ;;
        7) check_tools ;;
        0) break ;;
        *) echo -e "${RED}Invalid option${RESET}"; sleep 1 ;;
    esac
done
