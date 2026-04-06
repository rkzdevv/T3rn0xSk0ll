#!/bin/bash

# ==========================================
# HTMLMonster - Report Module
# ==========================================

# COLORS
RED="\033[1;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
BOLD="\033[1m"
RESET="\033[0m"

# ==========================================
# INIT
# ==========================================
REPORT_FILE="$1"

if [ -z "$REPORT_FILE" ]; then
    echo "Usage: report.sh <parsed_report>"
    exit 1
fi

if [ ! -f "$REPORT_FILE" ]; then
    echo -e "${RED}[ERROR] Report not found${RESET}"
    exit 1
fi

# ==========================================
# HEADER
# ==========================================
show_header() {
clear
echo -e "${RED}"
echo "=========================================="
echo "        HTMLMonster - Final Report        "
echo "=========================================="
echo -e "${RESET}"
}

# ==========================================
# LOAD DATA
# ==========================================
load_data() {
CRITICAL=$(grep "CRITICAL:" "$REPORT_FILE" | awk '{print $2}')
WARNING=$(grep "WARNING" "$REPORT_FILE" | grep ":" | awk '{print $2}')
INFO=$(grep "INFO" "$REPORT_FILE" | grep ":" | awk '{print $2}')
SCORE=$(grep "Security Score" "$REPORT_FILE" | awk '{print $3}')
RISK=$(grep "Risk Level" "$REPORT_FILE" | cut -d ':' -f2)
}

# ==========================================
# SUMMARY
# ==========================================
show_summary() {

echo -e "${CYAN}${BOLD}Summary${RESET}"
echo ""

echo -e "${RED}CRITICAL : $CRITICAL${RESET}"
echo -e "${YELLOW}WARNING  : $WARNING${RESET}"
echo -e "${GREEN}INFO     : $INFO${RESET}"
echo ""

echo -e "${CYAN}Risk Level:$RISK${RESET}"
echo -e "${CYAN}Security Score: $SCORE${RESET}"
echo ""
}

# ==========================================
# SHOW CRITICAL
# ==========================================
show_critical() {

echo -e "${RED}${BOLD}CRITICAL ISSUES${RESET}"
echo "------------------------------------------"

grep "\[CRITICAL\]" "$REPORT_FILE" | while read -r line; do
    echo -e "${RED}$line${RESET}"
done

echo ""
}

# ==========================================
# SHOW WARNING
# ==========================================
show_warning() {

echo -e "${YELLOW}${BOLD}WARNINGS${RESET}"
echo "------------------------------------------"

grep "\[WARNING\]" "$REPORT_FILE" | while read -r line; do
    echo -e "${YELLOW}$line${RESET}"
done

echo ""
}

# ==========================================
# SHOW INFO
# ==========================================
show_info() {

echo -e "${GREEN}${BOLD}INFO${RESET}"
echo "------------------------------------------"

grep "\[INFO\]" "$REPORT_FILE" | while read -r line; do
    echo -e "${GREEN}$line${RESET}"
done

echo ""
}

# ==========================================
# RISK MESSAGE
# ==========================================
risk_message() {

echo -e "${CYAN}${BOLD}Assessment${RESET}"
echo "------------------------------------------"

if [[ "$RISK" == *"HIGH"* ]]; then
    echo -e "${RED}This target is highly vulnerable.${RESET}"
elif [[ "$RISK" == *"MEDIUM"* ]]; then
    echo -e "${YELLOW}Moderate risk detected.${RESET}"
else
    echo -e "${GREEN}Low risk level.${RESET}"
fi

echo ""
}

# ==========================================
# EXPORT REPORT
# ==========================================
export_report() {

read -p "Export report to file? (y/n): " choice

if [[ "$choice" == "y" ]]; then
    read -p "File name: " fname
    cp "$REPORT_FILE" "$fname"
    echo -e "${GREEN}[+] Exported to $fname${RESET}"
fi
}

# ==========================================
# VIEW RAW
# ==========================================
view_raw() {
echo ""
echo -e "${WHITE}Raw Report:${RESET}"
echo "------------------------------------------"
cat "$REPORT_FILE"
echo ""
}

# ==========================================
# MENU
# ==========================================
menu() {

while true; do
    show_header
    load_data
    show_summary

    echo "[1] Show Critical"
    echo "[2] Show Warnings"
    echo "[3] Show Info"
    echo "[4] Assessment"
    echo "[5] View Raw Report"
    echo "[6] Export Report"
    echo "[0] Exit"
    echo ""

    read -p "Choose: " opt

    case $opt in
        1) show_critical; read -p "Enter..." ;;
        2) show_warning; read -p "Enter..." ;;
        3) show_info; read -p "Enter..." ;;
        4) risk_message; read -p "Enter..." ;;
        5) view_raw; read -p "Enter..." ;;
        6) export_report; read -p "Enter..." ;;
        0) exit 0 ;;
        *) echo "Invalid"; sleep 1 ;;
    esac

done
}

# ==========================================
# RUN
# ==========================================
menu
