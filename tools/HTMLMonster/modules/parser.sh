#!/bin/bash

# ==========================================
# HTMLMonster - Parser Module
# ==========================================

# COLORS
RED="\033[1;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

# ==========================================
# INIT
# ==========================================
RAW_REPORT="$1"
PARSED_REPORT="$2"

if [ -z "$RAW_REPORT" ]; then
    echo "Usage: parser.sh <raw_report> <output_report>"
    exit 1
fi

if [ ! -f "$RAW_REPORT" ]; then
    echo -e "${RED}[ERROR] Raw report not found${RESET}"
    exit 1
fi

if [ -z "$PARSED_REPORT" ]; then
    PARSED_REPORT="../output/parsed_$(date +%s).txt"
fi

> "$PARSED_REPORT"

# ==========================================
# REMOVE DUPLICATES
# ==========================================
clean_duplicates() {
    sort "$RAW_REPORT" | uniq > /tmp/htmlmonster_clean.tmp
}

# ==========================================
# CLASSIFY RESULTS
# ==========================================
classify_results() {

    CRITICAL_FILE="/tmp/htmlmonster_critical.tmp"
    WARNING_FILE="/tmp/htmlmonster_warning.tmp"
    INFO_FILE="/tmp/htmlmonster_info.tmp"

    > "$CRITICAL_FILE"
    > "$WARNING_FILE"
    > "$INFO_FILE"

    while read -r line; do

        if echo "$line" | grep -q "\[CRITICAL\]"; then
            echo "$line" >> "$CRITICAL_FILE"

        elif echo "$line" | grep -q "\[WARNING\]"; then
            echo "$line" >> "$WARNING_FILE"

        elif echo "$line" | grep -q "\[INFO\]"; then
            echo "$line" >> "$INFO_FILE"

        fi

    done < /tmp/htmlmonster_clean.tmp
}

# ==========================================
# COUNT RESULTS
# ==========================================
count_results() {
    CRIT_COUNT=$(wc -l < "$CRITICAL_FILE")
    WARN_COUNT=$(wc -l < "$WARNING_FILE")
    INFO_COUNT=$(wc -l < "$INFO_FILE")
}

# ==========================================
# PRIORITY ANALYSIS
# ==========================================
priority_analysis() {

    echo -e "${CYAN}[+] Analyzing priorities...${RESET}"

    if [ "$CRIT_COUNT" -gt 5 ]; then
        PRIORITY="HIGH RISK"
    elif [ "$CRIT_COUNT" -gt 0 ]; then
        PRIORITY="MEDIUM RISK"
    else
        PRIORITY="LOW RISK"
    fi
}

# ==========================================
# SCORE CALCULATION
# ==========================================
calculate_score() {

    SCORE=100

    SCORE=$((SCORE - (CRIT_COUNT * 15)))
    SCORE=$((SCORE - (WARN_COUNT * 7)))
    SCORE=$((SCORE - (INFO_COUNT * 2)))

    if [ $SCORE -lt 0 ]; then
        SCORE=0
    fi
}

# ==========================================
# FORMAT OUTPUT
# ==========================================
format_output() {

    echo "===================================" >> "$PARSED_REPORT"
    echo "        HTMLMonster Report          " >> "$PARSED_REPORT"
    echo "===================================" >> "$PARSED_REPORT"
    echo "" >> "$PARSED_REPORT"

    echo "Summary:" >> "$PARSED_REPORT"
    echo "CRITICAL: $CRIT_COUNT" >> "$PARSED_REPORT"
    echo "WARNING : $WARN_COUNT" >> "$PARSED_REPORT"
    echo "INFO    : $INFO_COUNT" >> "$PARSED_REPORT"
    echo "" >> "$PARSED_REPORT"

    echo "Risk Level: $PRIORITY" >> "$PARSED_REPORT"
    echo "Security Score: $SCORE%" >> "$PARSED_REPORT"
    echo "" >> "$PARSED_REPORT"

    echo "========== CRITICAL ==========" >> "$PARSED_REPORT"
    cat "$CRITICAL_FILE" >> "$PARSED_REPORT"
    echo "" >> "$PARSED_REPORT"

    echo "========== WARNING ==========" >> "$PARSED_REPORT"
    cat "$WARNING_FILE" >> "$PARSED_REPORT"
    echo "" >> "$PARSED_REPORT"

    echo "========== INFO ==========" >> "$PARSED_REPORT"
    cat "$INFO_FILE" >> "$PARSED_REPORT"
    echo "" >> "$PARSED_REPORT"
}

# ==========================================
# TERMINAL OUTPUT
# ==========================================
show_terminal_output() {

    echo ""
    echo -e "${RED}CRITICAL: $CRIT_COUNT${RESET}"
    echo -e "${YELLOW}WARNING : $WARN_COUNT${RESET}"
    echo -e "${GREEN}INFO    : $INFO_COUNT${RESET}"
    echo ""

    echo -e "${CYAN}Risk Level: $PRIORITY${RESET}"
    echo -e "${CYAN}Security Score: $SCORE%${RESET}"
    echo ""

    if [ "$CRIT_COUNT" -gt 0 ]; then
        echo -e "${RED}Top Critical Issues:${RESET}"
        head -n 5 "$CRITICAL_FILE"
        echo ""
    fi
}

# ==========================================
# CLEAN TEMP FILES
# ==========================================
cleanup() {
    rm -f /tmp/htmlmonster_*.tmp 2>/dev/null
}

# ==========================================
# MAIN
# ==========================================
main() {

    echo -e "${CYAN}[+] Parsing results...${RESET}"

    clean_duplicates
    classify_results
    count_results
    priority_analysis
    calculate_score
    format_output
    show_terminal_output
    cleanup

    echo -e "${GREEN}[+] Parsed report saved: $PARSED_REPORT${RESET}"
}

# ==========================================
# RUN
# ==========================================
main
