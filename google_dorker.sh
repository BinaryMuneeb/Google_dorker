#!/bin/bash

# ============================================================
# Google Dorking Generator Script for Cybersecurity Research
# Author: Muneeb UMER
# Usage: ./google_dorker.sh
# ============================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
BROWSER="xdg-open"  # Default browser opener (Linux)
DELAY=1            # Minimal delay

# Check if running on macOS and adjust browser opener
if [[ "$OSTYPE" == "darwin"* ]]; then
    BROWSER="open"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    BROWSER="start"
fi

# ==========================================
# BANNER
# ==========================================
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
   ____                   _       _       _           _             
  / ___| ___   ___   __ _| |   __| | __ _| |__  _   _| | ___  _ __  
 | |  _ / _ \ / _ \ / _` | |  / _` |/ _` | '_ \| | | | |/ _ \| '_ \ 
 | |_| | (_) | (_) | (_| | | | (_| | (_| | |_) | |_| | | (_) | | | |
  \____|\___/ \___/ \__, |_|  \__,_|\__,_|_.__/ \__, |_|\___/|_| |_|
                    |___/                       |___/                
EOF
    echo -e "${NC}"
    echo -e "${YELLOW}  Google Dork Generator for Security Research${NC}"
    echo -e "${YELLOW}  Generates URLs - Manual execution required${NC}"
    echo -e "${YELLOW}  Developed BY => Muneeb Umer "
    echo -e "${MAGENTA}  =================================================${NC}"
    echo ""
}

# ==========================================
# UTILITY FUNCTIONS
# ==========================================

# URL encode function
url_encode() {
    local string="$1"
    local encoded=""
    local pos c o
    
    for (( pos=0; pos<${#string}; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9]) encoded+="$c" ;;
            *) printf -v o '%%%02x' "'$c"; encoded+="$o" ;;
        esac
    done
    echo "$encoded"
}

# Generate Google search URL
generate_url() {
    local query="$1"
    local encoded_query=$(url_encode "$query")
    echo "https://www.google.com/search?q=${encoded_query}"
}

# Open browser with search (only when explicitly requested)
open_search() {
    local url="$1"
    echo -e "${BLUE}[*] Opening browser...${NC}"
    $BROWSER "$url" 2>/dev/null &
    sleep $DELAY
}

# Copy to clipboard function
copy_to_clipboard() {
    local text="$1"
    if command -v xclip &> /dev/null; then
        echo -n "$text" | xclip -selection clipboard
        echo -e "${GREEN}[✓] Copied to clipboard!${NC}"
    elif command -v xsel &> /dev/null; then
        echo -n "$text" | xsel --clipboard --input
        echo -e "${GREEN}[✓] Copied to clipboard!${NC}"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo -n "$text" | pbcopy
        echo -e "${GREEN}[✓] Copied to clipboard!${NC}"
    else
        echo -e "${YELLOW}[!] Clipboard copy not available${NC}"
    fi
}

# Save results to file
save_dork() {
    local category="$1"
    local dork="$2"
    local url="$3"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    echo "[$timestamp] [$category]" >> google_dorks_history.txt
    echo "DORK: $dork" >> google_dorks_history.txt
    echo "URL: $url" >> google_dorks_history.txt
    echo "----------------------------------------" >> google_dorks_history.txt
}

# Display dork with options
display_dork() {
    local category="$1"
    local dork="$2"
    local url=$(generate_url "$dork")
    
    echo ""
    echo -e "${MAGENTA}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC} ${YELLOW}CATEGORY:${NC} $category"
    echo -e "${MAGENTA}║${NC} ${CYAN}DORK:${NC} $dork"
    echo -e "${MAGENTA}║${NC} ${GREEN}URL:${NC} $url"
    echo -e "${MAGENTA}╚════════════════════════════════════════════════════════════╝${NC}"
    
    while true; do
        echo ""
        echo -e "${BLUE}Options:${NC}"
        echo "  [o] Open in browser"
        echo "  [c] Copy URL to clipboard"
        echo "  [d] Copy DORK to clipboard"
        echo "  [s] Skip to next"
        echo "  [q] Quit this category"
        echo ""
        read -p "Select option: " choice
        
        case "$choice" in
            o|O)
                open_search "$url"
                save_dork "$category" "$dork" "$url"
                break
                ;;
            c|C)
                copy_to_clipboard "$url"
                ;;
            d|D)
                copy_to_clipboard "$dork"
                ;;
            s|S)
                break
                ;;
            q|Q)
                return 1  # Signal to quit category
                ;;
            *)
                echo -e "${RED}[!] Invalid option${NC}"
                ;;
        esac
    done
    return 0
}

# ==========================================
# DORK CATEGORIES
# ==========================================

# 1. SENSITIVE FILES
dork_sensitive_files() {
    echo -e "\n${RED}[+] Sensitive Files & Documents${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    local domain="$1"
    local target=""
    
    if [ -n "$domain" ]; then
        target="site:$domain "
    fi
    
    declare -a dorks=(
        "${target}filetype:pdf confidential"
        "${target}filetype:pdf \"internal use only\""
        "${target}filetype:docx confidential"
        "${target}filetype:xlsx password"
        "${target}filetype:csv email"
        "${target}filetype:sql \"MySQL dump\""
        "${target}filetype:env DB_PASSWORD"
        "${target}filetype:log username"
        "${target}filetype:backup"
        "${target}filetype:bak"
        "${target}filetype:old"
        "${target}filetype:zip confidential"
        "${target}filetype:tar.gz backup"
        "${target}filetype:sql backup"
        "${target}filetype:mdb"
        "${target}filetype:cfg"
        "${target}filetype:conf"
        "${target}filetype:ini"
        "${target}filetype:xml"
        "${target}filetype:json api_key"
    )
    
    for dork in "${dorks[@]}"; do
        display_dork "SENSITIVE_FILES" "$dork"
        if [ $? -ne 0 ]; then break; fi
    done
}

# 2. ADMIN PANELS & LOGIN PAGES
dork_admin_panels() {
    echo -e "\n${RED}[+] Admin Panels & Login Pages${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    local domain="$1"
    local target=""
    
    if [ -n "$domain" ]; then
        target="site:$domain "
    fi
    
    declare -a dorks=(
        "${target}inurl:admin"
        "${target}inurl:administrator"
        "${target}inurl:login"
        "${target}inurl:signin"
        "${target}inurl:portal"
        "${target}inurl:cpanel"
        "${target}inurl:phpmyadmin"
        "${target}inurl:webmail"
        "${target}intitle:\"login\" \"admin\""
        "${target}intitle:\"index of\" \"admin\""
        "${target}intitle:login intext:username"
        "${target}inurl:wp-admin"
        "${target}inurl:wp-login"
        "${target}inurl:admin.php"
        "${target}inurl:administrator.php"
        "${target}inurl:login.php"
        "${target}inurl:panel"
        "${target}inurl:dashboard"
        "${target}inurl:backend"
        "${target}inurl:control"
    )
    
    for dork in "${dorks[@]}"; do
        display_dork "ADMIN_PANELS" "$dork"
        if [ $? -ne 0 ]; then break; fi
    done
}

# 3. CONFIGURATION & EXPOSURE
dork_config_exposure() {
    echo -e "\n${RED}[+] Configuration Files & Exposure${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    local domain="$1"
    local target=""
    
    if [ -n "$domain" ]; then
        target="site:$domain "
    fi
    
    declare -a dorks=(
        "${target}filetype:xml"
        "${target}filetype:conf"
        "${target}filetype:cnf"
        "${target}filetype:config"
        "${target}filetype:env"
        "${target}filetype:yaml"
        "${target}filetype:yml"
        "${target}filetype:json"
        "${target}filetype:properties"
        "${target}filetype:sql"
        "${target}filetype:db"
        "${target}filetype:sqlite"
        "${target}ext:sql"
        "${target}ext:bak"
        "${target}ext:backup"
        "${target}ext:swp"
        "${target}ext:old"
        "${target}ext:orig"
        "${target}ext:copy"
    )
    
    for dork in "${dorks[@]}"; do
        display_dork "CONFIG_EXPOSURE" "$dork"
        if [ $? -ne 0 ]; then break; fi
    done
}

# 4. VULNERABILITIES & EXPLOITS
dork_vulnerabilities() {
    echo -e "\n${RED}[+] Potential Vulnerabilities${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    local domain="$1"
    local target=""
    
    if [ -n "$domain" ]; then
        target="site:$domain "
    fi
    
    declare -a dorks=(
        "${target}inurl:index.php?id="
        "${target}inurl:page.php?id="
        "${target}inurl:product.php?id="
        "${target}inurl:category.php?id="
        "${target}inurl:article.php?id="
        "${target}inurl:news.php?id="
        "${target}inurl:item.php?id="
        "${target}inurl:view.php?id="
        "${target}inurl:detail.php?id="
        "${target}inurl:file.php?file="
        "${target}inurl:download.php?file="
        "${target}inurl:path="
        "${target}inurl:redirect="
        "${target}inurl:return="
        "${target}inurl:next="
        "${target}inurl:url="
        "${target}inurl:continue="
        "${target}inurl:host="
        "${target}inurl:proxy="
    )
    
    for dork in "${dorks[@]}"; do
        display_dork "VULNERABILITIES" "$dork"
        if [ $? -ne 0 ]; then break; fi
    done
}

# 5. DIRECTORY LISTING
dork_directory_listing() {
    echo -e "\n${RED}[+] Directory Listings${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    local domain="$1"
    local target=""
    
    if [ -n "$domain" ]; then
        target="site:$domain "
    fi
    
    declare -a dorks=(
        "${target}intitle:\"index of\" \"parent directory\""
        "${target}intitle:\"index of\" \"Apache Server\""
        "${target}intitle:\"index of\" \"nginx\""
        "${target}intitle:\"index of\" \"IIS\""
        "${target}intitle:\"index of\" \"backup\""
        "${target}intitle:\"index of\" \"admin\""
        "${target}intitle:\"index of\" \"config\""
        "${target}intitle:\"index of\" \"database\""
        "${target}intitle:\"index of\" \"uploads\""
        "${target}intitle:\"index of\" \"files\""
        "${target}intitle:\"index of\" \"private\""
        "${target}intitle:\"index of\" \"secret\""
        "${target}intitle:\"index of\" \"password\""
        "${target}intitle:\"index of\" \"confidential\""
        "${target}intitle:\"index of\" \"restricted\""
        "${target}intitle:\"index of\" \"archive\""
        "${target}intitle:\"index of\" \"old\""
        "${target}intitle:\"index of\" \"temp\""
        "${target}intitle:\"index of\" \"tmp\""
        "${target}intitle:\"index of\" \"logs\""
    )
    
    for dork in "${dorks[@]}"; do
        display_dork "DIRECTORY_LISTING" "$dork"
        if [ $? -ne 0 ]; then break; fi
    done
}

# 6. CLOUD STORAGE & S3 BUCKETS
dork_cloud_storage() {
    echo -e "\n${RED}[+] Cloud Storage & S3 Buckets${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    local domain="$1"
    local target=""
    
    if [ -n "$domain" ]; then
        target="site:$domain "
    fi
    
    declare -a dorks=(
        "${target}site:s3.amazonaws.com"
        "${target}site:blob.core.windows.net"
        "${target}site:storage.googleapis.com"
        "${target}site:amazonaws.com"
        "${target}site:dropbox.com"
        "${target}site:box.com"
        "${target}site:drive.google.com"
        "${target}site:onedrive.live.com"
        "${target}intitle:\"index of\" \"s3\""
        "${target}intitle:\"index of\" \"bucket\""
        "${target}inurl:s3.amazonaws.com"
        "${target}inurl:blob.core.windows.net"
        "${target}inurl:storage.googleapis.com"
        "${target}\"bucket\" \"s3\" \"aws\""
        "${target}\"storage\" \"azure\" \"blob\""
        "${target}filetype:json \"s3\" \"bucket\""
        "${target}filetype:xml \"s3\" \"bucket\""
        "${target}site:s3.amazonaws.com confidential"
        "${target}site:s3.amazonaws.com backup"
        "${target}site:s3.amazonaws.com database"
    )
    
    for dork in "${dorks[@]}"; do
        display_dork "CLOUD_STORAGE" "$dork"
        if [ $? -ne 0 ]; then break; fi
    done
}

# 7. ERROR MESSAGES & DEBUG INFO
dork_error_messages() {
    echo -e "\n${RED}[+] Error Messages & Debug Information${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    local domain="$1"
    local target=""
    
    if [ -n "$domain" ]; then
        target="site:$domain "
    fi
    
    declare -a dorks=(
        "${target}\"PHP Parse error\""
        "${target}\"PHP Warning\""
        "${target}\"PHP Fatal error\""
        "${target}\"MySQL error\""
        "${target}\"SQL syntax\""
        "${target}\"ODBC SQL Server Driver\""
        "${target}\"Microsoft OLE DB Provider\""
        "${target}\"error in your SQL syntax\""
        "${target}\"Warning: mysql_\""
        "${target}\"Warning: pg_\""
        "${target}\"Warning: oci_\""
        "${target}\"Warning: mssql_\""
        "${target}\"Unclosed quotation mark\""
        "${target}\"quoted string not properly terminated\""
        "${target}\"ORA-01756\""
        "${target}\"ORA-00933\""
        "${target}\"ORA-00936\""
        "${target}\"Microsoft SQL Native Client error\""
        "${target}\"supplied argument is not a valid MySQL result\""
    )
    
    for dork in "${dorks[@]}"; do
        display_dork "ERROR_MESSAGES" "$dork"
        if [ $? -ne 0 ]; then break; fi
    done
}

# 8. WEBCAMS & IoT DEVICES
dork_webcams_iot() {
    echo -e "\n${RED}[+] Webcams & IoT Devices${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    local domain="$1"
    local target=""
    
    if [ -n "$domain" ]; then
        target="site:$domain "
    fi
    
    declare -a dorks=(
        "${target}inurl:viewerframe?mode=motion"
        "${target}intitle:\"webcamXP 5\""
        "${target}inurl:webcam.html"
        "${target}intitle:\"Live View / - AXIS\""
        "${target}inurl:view/view.shtml"
        "${target}intitle:\"WJ-NT104 Main Page\""
        "${target}intitle:\"snc-rz30\" -demo"
        "${target}intitle:\"Live View / - AXIS 206M\""
        "${target}intitle:\"Live View / - AXIS 206W\""
        "${target}intitle:\"Live View / - AXIS 210\""
        "${target}inurl:indexFrame.shtml Axis"
        "${target}intitle:\"axis\" \"live camera\""
        "${target}inurl:lvappl.htm"
        "${target}intitle:\"EvoCam\" inurl:webcam.html"
        "${target}intitle:\"Live NetSnap Cam-Server feed\""
        "${target}intitle:\"Live View / - AXIS\" | inurl:view/view.shtml"
        "${target}inurl:ViewerFrame?Mode=Refresh"
        "${target}intitle:\"Toshiba Network Camera\" user login"
        "${target}intitle:\"i-Catcher Console - Web Monitor\""
    )
    
    for dork in "${dorks[@]}"; do
        display_dork "WEBCAMS_IOT" "$dork"
        if [ $? -ne 0 ]; then break; fi
    done
}

# 9. NETWORK DEVICES
dork_network_devices() {
    echo -e "\n${RED}[+] Network Devices & Infrastructure${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    local domain="$1"
    local target=""
    
    if [ -n "$domain" ]; then
        target="site:$domain "
    fi
    
    declare -a dorks=(
        "${target}intitle:\"Router\" \"login\""
        "${target}intitle:\"Switch\" \"login\""
        "${target}intitle:\"Firewall\" \"login\""
        "${target}intitle:\"VPN\" \"login\""
        "${target}intitle:\"APC\" \"Management\""
        "${target}intitle:\"HP LaserJet\" \"login\""
        "${target}intitle:\"Brother\" \"login\""
        "${target}intitle:\"Canon\" \"login\""
        "${target}intitle:\"Epson\" \"login\""
        "${target}intitle:\"Lexmark\" \"login\""
        "${target}intitle:\"Samsung\" \"login\""
        "${target}intitle:\"Xerox\" \"login\""
        "${target}intitle:\"Dell\" \"login\""
        "${target}intitle:\"Cisco\" \"login\""
        "${target}intitle:\"Juniper\" \"login\""
        "${target}intitle:\"Fortinet\" \"login\""
        "${target}intitle:\"SonicWall\" \"login\""
        "${target}intitle:\"Palo Alto\" \"login\""
        "${target}intitle:\"F5\" \"login\""
        "${target}intitle:\"Citrix\" \"login\""
    )
    
    for dork in "${dorks[@]}"; do
        display_dork "NETWORK_DEVICES" "$dork"
        if [ $? -ne 0 ]; then break; fi
    done
}

# 10. CUSTOM SEARCH
custom_search() {
    echo -e "\n${CYAN}[+] Custom Google Dork Search${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    read -p "Enter your custom search term: " custom_term
    
    if [ -z "$custom_term" ]; then
        echo -e "${RED}[!] No search term provided${NC}"
        return
    fi
    
    display_dork "CUSTOM" "$custom_term"
}

# 11. ADVANCED CUSTOM DORK BUILDER
advanced_dork_builder() {
    echo -e "\n${CYAN}[+] Advanced Dork Builder${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    local dork=""
    
    while true; do
        echo ""
        echo -e "${GREEN}Current dork:${NC} $dork"
        echo ""
        echo -e "${CYAN}Build your custom dork:${NC}"
        echo "  [1] Add site/domain filter"
        echo "  [2] Add filetype filter"
        echo "  [3] Add inurl filter"
        echo "  [4] Add intitle filter"
        echo "  [5] Add intext filter"
        echo "  [6] Add exclude term (-term)"
        echo "  [7] Add OR condition"
        echo "  [8] Preview and Execute"
        echo "  [9] Clear and Start Over"
        echo "  [0] Back to main menu"
        echo ""
        
        read -p "Select option: " choice
        
        case $choice in
            1)
                read -p "Enter domain (e.g., example.com): " domain
                dork+="site:$domain "
                ;;
            2)
                read -p "Enter filetype (e.g., pdf, docx, sql): " filetype
                dork+="filetype:$filetype "
                ;;
            3)
                read -p "Enter inurl term: " inurl
                dork+="inurl:$inurl "
                ;;
            4)
                read -p "Enter intitle term: " intitle
                dork+="intitle:$intitle "
                ;;
            5)
                read -p "Enter intext term: " intext
                dork+="intext:$intext "
                ;;
            6)
                read -p "Enter term to exclude: " exclude
                dork+="-$exclude "
                ;;
            7)
                read -p "Enter OR term (will be added as |term): " or_term
                dork+="|$or_term "
                ;;
            8)
                if [ -n "$dork" ]; then
                    display_dork "ADVANCED_BUILDER" "$dork"
                    dork=""
                else
                    echo -e "${RED}[!] Dork is empty${NC}"
                fi
                ;;
            9)
                dork=""
                echo -e "${GREEN}[*] Cleared${NC}"
                ;;
            0)
                break
                ;;
            *)
                echo -e "${RED}[!] Invalid option${NC}"
                ;;
        esac
    done
}

# 12. GENERATE ALL DORKS TO FILE
generate_all_dorks() {
    echo -e "\n${CYAN}[+] Generate All Dorks to File${NC}"
    echo -e "${YELLOW}----------------------------------------${NC}"
    
    read -p "Enter target domain (leave empty for templates): " domain
    read -p "Enter output filename [dorks_list.txt]: " filename
    
    if [ -z "$filename" ]; then
        filename="dorks_list.txt"
    fi
    
    local target=""
    if [ -n "$domain" ]; then
        target="site:$domain "
    fi
    
    echo "Google Dorks Generated: $(date)" > "$filename"
    echo "Target: ${domain:-'Global'}" >> "$filename"
    echo "========================================" >> "$filename"
    echo "" >> "$filename"
    
    # Array of all dork categories
    declare -A categories
    categories[Sensitive_Files]="filetype:pdf confidential filetype:pdf \"internal use only\" filetype:docx confidential filetype:xlsx password filetype:csv email filetype:sql \"MySQL dump\" filetype:env DB_PASSWORD filetype:log username filetype:backup filetype:bak filetype:old filetype:zip confidential filetype:tar.gz backup filetype:sql backup filetype:mdb filetype:cfg filetype:conf filetype:ini filetype:xml filetype:json api_key"
    
    categories[Admin_Panels]="inurl:admin inurl:administrator inurl:login inurl:signin inurl:portal inurl:cpanel inurl:phpmyadmin inurl:webmail intitle:\"login\" \"admin\" intitle:\"index of\" \"admin\" intitle:login intext:username inurl:wp-admin inurl:wp-login inurl:admin.php inurl:administrator.php inurl:login.php inurl:panel inurl:dashboard inurl:backend inurl:control"
    
    categories[Config_Exposure]="filetype:xml filetype:conf filetype:cnf filetype:config filetype:env filetype:yaml filetype:yml filetype:json filetype:properties filetype:sql filetype:db filetype:sqlite ext:sql ext:bak ext:backup ext:swp ext:old ext:orig ext:copy"
    
    categories[Vulnerabilities]="inurl:index.php?id= inurl:page.php?id= inurl:product.php?id= inurl:category.php?id= inurl:article.php?id= inurl:news.php?id= inurl:item.php?id= inurl:view.php?id= inurl:detail.php?id= inurl:file.php?file= inurl:download.php?file= inurl:path= inurl:redirect= inurl:return= inurl:next= inurl:url= inurl:continue= inurl:host= inurl:proxy="
    
    categories[Directory_Listing]="intitle:\"index of\" \"parent directory\" intitle:\"index of\" \"Apache Server\" intitle:\"index of\" \"nginx\" intitle:\"index of\" \"IIS\" intitle:\"index of\" \"backup\" intitle:\"index of\" \"admin\" intitle:\"index of\" \"config\" intitle:\"index of\" \"database\" intitle:\"index of\" \"uploads\" intitle:\"index of\" \"files\" intitle:\"index of\" \"private\" intitle:\"index of\" \"secret\" intitle:\"index of\" \"password\" intitle:\"index of\" \"confidential\" intitle:\"index of\" \"restricted\" intitle:\"index of\" \"archive\" intitle:\"index of\" \"old\" intitle:\"index of\" \"temp\" intitle:\"index of\" \"tmp\" intitle:\"index of\" \"logs\""
    
    categories[Cloud_Storage]="site:s3.amazonaws.com site:blob.core.windows.net site:storage.googleapis.com site:amazonaws.com site:dropbox.com site:box.com site:drive.google.com site:onedrive.live.com intitle:\"index of\" \"s3\" intitle:\"index of\" \"bucket\" inurl:s3.amazonaws.com inurl:blob.core.windows.net inurl:storage.googleapis.com \"bucket\" \"s3\" \"aws\" \"storage\" \"azure\" \"blob\" filetype:json \"s3\" \"bucket\" filetype:xml \"s3\" \"bucket\" site:s3.amazonaws.com confidential site:s3.amazonaws.com backup site:s3.amazonaws.com database"
    
    categories[Error_Messages]="\"PHP Parse error\" \"PHP Warning\" \"PHP Fatal error\" \"MySQL error\" \"SQL syntax\" \"ODBC SQL Server Driver\" \"Microsoft OLE DB Provider\" \"error in your SQL syntax\" \"Warning: mysql_\" \"Warning: pg_\" \"Warning: oci_\" \"Warning: mssql_\" \"Unclosed quotation mark\" \"quoted string not properly terminated\" \"ORA-01756\" \"ORA-00933\" \"ORA-00936\" \"Microsoft SQL Native Client error\" \"supplied argument is not a valid MySQL result\""
    
    for category in "${!categories[@]}"; do
        echo "" >> "$filename"
        echo "## $category" >> "$filename"
        echo "----------------------------------------" >> "$filename"
        
        for dork in ${categories[$category]}; do
            full_dork="${target}${dork}"
            url=$(generate_url "$full_dork")
            echo "DORK: $full_dork" >> "$filename"
            echo "URL:  $url" >> "$filename"
            echo "" >> "$filename"
        done
    done
    
    echo -e "${GREEN}[✓] Generated $filename with all dorks!${NC}"
    read -p "Press Enter to continue..."
}

# ==========================================
# MAIN MENU
# ==========================================
main_menu() {
    while true; do
        show_banner
        
        echo -e "${GREEN}Select an option:${NC}"
        echo ""
        echo -e "${CYAN}  [1]${NC} Sensitive Files & Documents"
        echo -e "${CYAN}  [2]${NC} Admin Panels & Login Pages"
        echo -e "${CYAN}  [3]${NC} Configuration Files & Exposure"
        echo -e "${CYAN}  [4]${NC} Potential Vulnerabilities"
        echo -e "${CYAN}  [5]${NC} Directory Listings"
        echo -e "${CYAN}  [6]${NC} Cloud Storage & S3 Buckets"
        echo -e "${CYAN}  [7]${NC} Error Messages & Debug Info"
        echo -e "${CYAN}  [8]${NC} Webcams & IoT Devices"
        echo -e "${CYAN}  [9]${NC} Network Devices & Infrastructure"
        echo -e "${CYAN}  [10]${NC} Custom Search"
        echo -e "${CYAN}  [11]${NC} Advanced Dork Builder"
        echo -e "${CYAN}  [12]${NC} Generate All Dorks to File"
        echo -e "${CYAN}  [13]${NC} View Search History"
        echo -e "${CYAN}  [0]${NC} Exit"
        echo ""
        
        read -p "Enter your choice: " choice
        
        # Ask for target domain if needed
        local target_domain=""
        if [[ "$choice" =~ ^[1-9]$ ]] && [ "$choice" != "10" ] && [ "$choice" != "11" ] && [ "$choice" != "12" ]; then
            read -p "Enter target domain (leave empty for global search): " target_domain
        fi
        
        case $choice in
            1) dork_sensitive_files "$target_domain" ;;
            2) dork_admin_panels "$target_domain" ;;
            3) dork_config_exposure "$target_domain" ;;
            4) dork_vulnerabilities "$target_domain" ;;
            5) dork_directory_listing "$target_domain" ;;
            6) dork_cloud_storage "$target_domain" ;;
            7) dork_error_messages "$target_domain" ;;
            8) dork_webcams_iot "$target_domain" ;;
            9) dork_network_devices "$target_domain" ;;
            10) custom_search ;;
            11) advanced_dork_builder ;;
            12) generate_all_dorks ;;
            13) 
                if [ -f "google_dorks_history.txt" ]; then
                    echo -e "\n${CYAN}Search History:${NC}"
                    cat google_dorks_history.txt
                    read -p "Press Enter to continue..."
                else
                    echo -e "\n${RED}[!] No history file found${NC}"
                    sleep 2
                fi
                ;;
            0) 
                echo -e "\n${GREEN}[*] Exiting...${NC}"
                exit 0
                ;;
            *)
                echo -e "\n${RED}[!] Invalid option${NC}"
                sleep 2
                ;;
        esac
    done
}

# ==========================================
# INITIALIZATION
# ==========================================

# Show disclaimer
show_disclaimer() {
    echo -e "${RED}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                    LEGAL DISCLAIMER                            ║"
    echo "╠════════════════════════════════════════════════════════════════╣"
    echo "║  This tool is for educational and authorized security testing  ║"
    echo "║  purposes only. Unauthorized access to computer systems is       ║"
    echo "║  illegal. Always obtain proper authorization before testing. ║"
    echo "║                                                                ║"
    echo "║  This script GENERATES dorks only. It does NOT automatically   ║"
    echo "║  open browsers. You choose when to execute searches.           ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    read -p "Do you agree to use this tool responsibly? (yes/no): " agree
    
    if [ "$agree" != "yes" ]; then
        echo -e "${RED}[!] You must agree to the terms to use this tool${NC}"
        exit 1
    fi
}

# ==========================================
# SCRIPT ENTRY POINT
# ==========================================

# Initialize
show_disclaimer
main_menu
