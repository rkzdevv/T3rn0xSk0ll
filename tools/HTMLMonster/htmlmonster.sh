#!/bin/bash

# ==========================================
# HTMLMonster - Main Controller
# ==========================================

# COLORS
YELLOW="\033[1;33m"
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
MODULES_DIR="$BASE_DIR/modules"
OUTPUT_DIR="$BASE_DIR/output"
KEYWORDS_FILE="$BASE_DIR/keywords.txt"
LOG_FILE="$OUTPUT_DIR/history.log"

SCANNER="$MODULES_DIR/scanner.sh"
PARSER="$MODULES_DIR/parser.sh"
REPORT="$MODULES_DIR/report.sh"

# ==========================================
# LOGO
# ==========================================
show_logo() {
clear
echo -e "$YELLOW"
cat << "EOF"

                   :+xxX$$$$$$XXx+:                   
               ;x&x;..............;x&X;               
            :$$:......................:$$:            
      +X$$$&+..........................:;x&$$&$x.     
    XX.;xXx;:..........................:;;+X$$x+X&    
    Xx.......:X+......................;X+..::;;;x&    
     ;&;+x.......;+................++......:xx+&x     
     Xx.X&+X&;..........................;&$+$&+$X     
    +$..Xx  ;;:+$:..................:$+:;;  ;$;;&+    
   .&:..::  ....&..:+............;...&....  :;:;+&:   
   xX...... :...&...:  ........  ....&...;  :.:;;$x   
   &;......  ...;...  ..........  ...:...  ...:;;x&   
   &:..........;;;..................;+;.......:;;+&   
   &.........................................::;;+&   
   &:....;xx;::........................:;;xXx;:;;x&   
   xX...;::    +$+:................:+$x    ;;X;;;$x   
   .&...+;:   : .    :;.:;xx;:.;:    : :   :;X;;;&:   
    +$..+;:  ;      . .        . .   .  ;  ;;X;;$+    
     Xx..+; :   .  .  :        :  .  .   ; ;X;;XX     
      XX::x$:   ; ;   :        :   ; ;   :&X;;XX      
       x$:::X.  +.                  .+  ;X;;;$x       
        :$x:::+x:x     :     .:     x;X+;;;x$:        
          ;$x::::;++:  :      :  ;xx+;;;;x&+          
            :$$+;;::;+++++xxx++++;;;;;+$$;            
               ;X&Xx;;;;;;;;;;;;;;+X&X;               
                   ;xXX$$$&&$$$XXx;                   

EOF
echo -e "$RESET"
echo -e "${GREEN}HTMLMonster - Advanced HTML Security Analyzer${RESET}"
echo ""
}

# ==========================================
# PROJECT INTEGRITY CHECK
# ==========================================
check_integrity() {

FILES=(
"$SCANNER"
"$PARSER"
"$REPORT"
"$KEYWORDS_FILE"
)

for file in "${FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}[FATAL] Missing file: $file${RESET}"
        exit 1
    fi
done

# Check directories
[ ! -d "$MODULES_DIR" ] && echo "Missing modules dir" && exit 1
[ ! -d "$OUTPUT_DIR" ] && mkdir -p "$OUTPUT_DIR"

}

# ==========================================
# PERMISSIONS
# ==========================================
fix_permissions() {
chmod +x "$SCANNER" "$PARSER" "$REPORT" 2>/dev/null
}

# ==========================================
# LOG SYSTEM
# ==========================================
log_action() {
echo "[$(date '+%H:%M:%S')] $1" >> "$LOG_FILE"
}

# ==========================================
# SCAN FILE
# ==========================================
scan_file() {

read -p "Enter HTML file path: " file

if [ ! -f "$file" ]; then
    echo -e "${RED}File not found${RESET}"
    return
fi

RAW="$OUTPUT_DIR/raw_$(date +%s).txt"
FINAL="$OUTPUT_DIR/final_$(date +%s).txt"

log_action "Scan file: $file"

bash "$SCANNER" "$file" > "$RAW"
bash "$PARSER" "$RAW" "$FINAL"
bash "$REPORT" "$FINAL"
}

# ==========================================
# SCAN URL
# ==========================================
scan_url() {

read -p "Enter URL: " url

RAW="$OUTPUT_DIR/raw_$(date +%s).txt"
FINAL="$OUTPUT_DIR/final_$(date +%s).txt"

log_action "Scan URL: $url"

bash "$SCANNER" "$url" > "$RAW"
bash "$PARSER" "$RAW" "$FINAL"
bash "$REPORT" "$FINAL"
}

# ==========================================
# AUTO MODE
# ==========================================
auto_mode() {

read -p "Target (file or URL): " target

RAW="$OUTPUT_DIR/raw_auto.txt"
FINAL="$OUTPUT_DIR/final_auto.txt"

log_action "Auto scan: $target"

echo -e "${CYAN}[+] Running full scan...${RESET}"

bash "$SCANNER" "$target" > "$RAW"
bash "$PARSER" "$RAW" "$FINAL"
bash "$REPORT" "$FINAL"
}

# ==========================================
# VIEW REPORTS
# ==========================================
view_reports() {

show_logo

echo "Available Reports:"
ls "$OUTPUT_DIR"

echo ""
read -p "Enter report name: " r

if [ -f "$OUTPUT_DIR/$r" ]; then
    bash "$REPORT" "$OUTPUT_DIR/$r"
else
    echo -e "${RED}Not found${RESET}"
    sleep 1
fi
}

# ==========================================
# VIEW LOGS
# ==========================================
view_logs() {

show_logo
echo "History:"
echo "---------------------------"

cat "$LOG_FILE" 2>/dev/null || echo "No logs yet"

echo ""
read -p "Enter..."
}

# ==========================================
# TOOL INFO
# ==========================================
about() {

show_logo

echo -e "${CYAN}HTMLMonster${RESET}"
echo "Advanced HTML Security Analyzer"
echo ""
echo "Features:"
echo "- Keyword scanning"
echo "- Input detection"
echo "- Token detection"
echo "- Admin path discovery"
echo "- Security scoring"
echo ""
echo "Version: 1.0"
echo ""

read -p "Enter..."
}

# ==========================================
# MAIN MENU
# ==========================================
main_menu() {

while true; do

show_logo

echo -e "${WHITE}[1] Scan HTML File${RESET}"
echo -e "${WHITE}[2] Scan URL${RESET}"
echo -e "${WHITE}[3] Auto Mode${RESET}"
echo -e "${WHITE}[4] View Reports${RESET}"
echo -e "${WHITE}[5] View History${RESET}"
echo -e "${WHITE}[6] About${RESET}"
echo -e "${RED}[0] Exit${RESET}"

echo ""

read -p "Choose: " opt

case $opt in
    1) scan_file ;;
    2) scan_url ;;
    3) auto_mode ;;
    4) view_reports ;;
    5) view_logs ;;
    6) about ;;
    0) exit 0 ;;
    *) echo "Invalid"; sleep 1 ;;
esac

done
}

# ==========================================
# START
# ==========================================
check_integrity
fix_permissions
main_menu
