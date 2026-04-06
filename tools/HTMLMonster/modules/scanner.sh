#!/bin/bash

# ==========================================
# HTMLMonster - Scanner Module
# ==========================================

# COLORS
RED="\033[1;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
RESET="\033[0m"

# FILES
KEYWORDS_FILE="../keywords.txt"
OUTPUT_DIR="../output"
TMP_FILE="/tmp/htmlmonster_scan.tmp"

# ==========================================
# INIT
# ==========================================
init() {
    mkdir -p "$OUTPUT_DIR"
    > "$TMP_FILE"
}

# ==========================================
# LOAD TARGET
# ==========================================
load_target() {
    TARGET="$1"

    if [[ "$TARGET" == http* ]]; then
        echo -e "${CYAN}[+] Fetching URL...${RESET}"
        curl -s "$TARGET" > "$TMP_FILE"
    else
        if [ ! -f "$TARGET" ]; then
            echo -e "${RED}[ERROR] File not found${RESET}"
            exit 1
        fi
        cat "$TARGET" > "$TMP_FILE"
    fi
}

# ==========================================
# KEYWORD SCAN
# ==========================================
scan_keywords() {
    echo -e "${CYAN}[+] Scanning keywords...${RESET}"

    while read -r key; do
        if grep -iq "$key" "$TMP_FILE"; then
            echo -e "${YELLOW}[WARNING] Keyword found: $key${RESET}"
            echo "[WARNING] $key" >> "$REPORT"
        fi
    done < "$KEYWORDS_FILE"
}

# ==========================================
# PASSWORD INPUT DETECTION
# ==========================================
detect_password_inputs() {
    echo -e "${CYAN}[+] Checking password fields...${RESET}"

    if grep -i "<input" "$TMP_FILE" | grep -i "password" >/dev/null; then
        echo -e "${RED}[CRITICAL] Password input found${RESET}"
        echo "[CRITICAL] Password input field detected" >> "$REPORT"
    fi
}

# ==========================================
# COMMENT ANALYSIS
# ==========================================
scan_comments() {
    echo -e "${CYAN}[+] Analyzing comments...${RESET}"

    COMMENTS=$(grep -o "<!--.*-->" "$TMP_FILE")

    if [ ! -z "$COMMENTS" ]; then
        echo "$COMMENTS" | while read -r line; do
            if echo "$line" | grep -Ei "admin|password|secret|key"; then
                echo -e "${RED}[CRITICAL] Suspicious comment: $line${RESET}"
                echo "[CRITICAL] Comment: $line" >> "$REPORT"
            else
                echo -e "${GREEN}[INFO] Comment found${RESET}"
                echo "[INFO] Comment detected" >> "$REPORT"
            fi
        done
    fi
}

# ==========================================
# SCRIPT DETECTION
# ==========================================
scan_scripts() {
    echo -e "${CYAN}[+] Checking scripts...${RESET}"

    if grep -i "<script" "$TMP_FILE" >/dev/null; then
        echo -e "${YELLOW}[WARNING] Script tag detected${RESET}"
        echo "[WARNING] Script tag found" >> "$REPORT"
    fi

    if grep -i "src=" "$TMP_FILE" | grep -i "http" >/dev/null; then
        echo -e "${YELLOW}[WARNING] External script detected${RESET}"
        echo "[WARNING] External script" >> "$REPORT"
    fi
}

# ==========================================
# ADMIN PANEL DETECTION
# ==========================================
scan_admin_paths() {
    echo -e "${CYAN}[+] Searching admin paths...${RESET}"

    if grep -Ei "/admin|/dashboard|/panel" "$TMP_FILE" >/dev/null; then
        echo -e "${RED}[CRITICAL] Admin path reference found${RESET}"
        echo "[CRITICAL] Admin path found" >> "$REPORT"
    fi
}

# ==========================================
# FORM ANALYSIS
# ==========================================
scan_forms() {
    echo -e "${CYAN}[+] Checking forms...${RESET}"

    if grep -i "<form" "$TMP_FILE" >/dev/null; then
        echo -e "${GREEN}[INFO] Form detected${RESET}"
        echo "[INFO] Form found" >> "$REPORT"

        if ! grep -i "method=\"post\"" "$TMP_FILE" >/dev/null; then
            echo -e "${YELLOW}[WARNING] Form may not use POST${RESET}"
            echo "[WARNING] Form without POST" >> "$REPORT"
        fi
    fi
}

# ==========================================
# TOKEN / SECRET DETECTION
# ==========================================
scan_tokens() {
    echo -e "${CYAN}[+] Searching tokens/secrets...${RESET}"

    if grep -Ei "token|api_key|secret" "$TMP_FILE" >/dev/null; then
        echo -e "${RED}[CRITICAL] Possible token/secret found${RESET}"
        echo "[CRITICAL] Token or secret detected" >> "$REPORT"
    fi
}

# ==========================================
# EMAIL DETECTION
# ==========================================
scan_emails() {
    echo -e "${CYAN}[+] Searching emails...${RESET}"

    EMAILS=$(grep -Eo "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}" "$TMP_FILE")

    if [ ! -z "$EMAILS" ]; then
        echo -e "${GREEN}[INFO] Emails found${RESET}"
        echo "$EMAILS"
        echo "[INFO] Emails detected" >> "$REPORT"
    fi
}

# ==========================================
# SECURITY SCORE
# ==========================================
calculate_score() {

    SCORE=100

    CRIT=$(grep -c "\[CRITICAL\]" "$REPORT")
    WARN=$(grep -c "\[WARNING\]" "$REPORT")

    SCORE=$((SCORE - (CRIT * 15)))
    SCORE=$((SCORE - (WARN * 5)))

    if [ $SCORE -lt 0 ]; then
        SCORE=0
    fi

    echo ""
    echo -e "${CYAN}Security Score: $SCORE%${RESET}"
    echo "Score: $SCORE%" >> "$REPORT"
}

# ==========================================
# MAIN SCAN
# ==========================================
run_scan() {

    TARGET="$1"
    REPORT="$OUTPUT_DIR/report_$(date +%s).txt"

    init
    load_target "$TARGET"

    echo "[+] Scan started for $TARGET" > "$REPORT"

    scan_keywords
    detect_password_inputs
    scan_comments
    scan_scripts
    scan_admin_paths
    scan_forms
    scan_tokens
    scan_emails

    calculate_score

    echo ""
    echo -e "${GREEN}[+] Scan completed${RESET}"
    echo -e "${GREEN}[+] Report saved: $REPORT${RESET}"
}

# ==========================================
# EXECUTION
# ==========================================
if [ -z "$1" ]; then
    echo "Usage: scanner.sh <file|url>"
    exit 1
fi

run_scan "$1"
