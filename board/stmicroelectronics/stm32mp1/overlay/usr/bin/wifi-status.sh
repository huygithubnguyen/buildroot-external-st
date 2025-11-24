#!/bin/sh
# WiFi Status and Monitoring Script for Bike Computer
# Provides current WiFi connection status and diagnostics

set -euo pipefail

WIFI_INTERFACE="wlan0"
WPA_CONF="/etc/wpa_supplicant.conf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}=== STM32MP157F-DK2 Bike Computer WiFi Status ===${NC}"
    echo
}

print_status() {
    local status=$1
    local message=$2
    case $status in
        "OK") echo -e "${GREEN}✓${NC} $message" ;;
        "WARN") echo -e "${YELLOW}⚠${NC} $message" ;;
        "FAIL") echo -e "${RED}✗${NC} $message" ;;
    esac
}

check_interface() {
    if ip link show "$WIFI_INTERFACE" >/dev/null 2>&1; then
        local status=$(ip link show "$WIFI_INTERFACE" | grep -o 'state [A-Z]*' | cut -d' ' -f2)
        print_status "OK" "Interface $WIFI_INTERFACE: $status"
        return 0
    else
        print_status "FAIL" "Interface $WIFI_INTERFACE: Not found"
        return 1
    fi
}

check_driver() {
    if dmesg | grep -q "brcmfmac"; then
        print_status "OK" "brcmfmac driver: Loaded"
    else
        print_status "FAIL" "brcmfmac driver: Not loaded"
    fi
}

check_wpa_supplicant() {
    if pgrep -f "wpa_supplicant.*$WIFI_INTERFACE" >/dev/null; then
        print_status "OK" "WPA supplicant: Running"
    else
        print_status "FAIL" "WPA supplicant: Not running"
    fi
}

check_connection() {
    if wpa_cli -i "$WIFI_INTERFACE" status >/dev/null 2>&1; then
        local wpa_state=$(wpa_cli -i "$WIFI_INTERFACE" status | grep "wpa_state=" | cut -d'=' -f2)
        local ssid=$(wpa_cli -i "$WIFI_INTERFACE" status | grep "ssid=" | cut -d'=' -f2)
        local ip=$(ip -4 addr show "$WIFI_INTERFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
        
        if [ "$wpa_state" = "COMPLETED" ]; then
            print_status "OK" "Connection: $ssid ($ip)"
        else
            print_status "WARN" "Connection: $wpa_state"
        fi
    else
        print_status "FAIL" "WPA control interface: Not available"
    fi
}

check_signal() {
    if wpa_cli -i "$WIFI_INTERFACE" status >/dev/null 2>&1; then
        local rssi=$(wpa_cli -i "$WIFI_INTERFACE" status | grep "rssi=" | cut -d'=' -f2)
        local link_speed=$(wpa_cli -i "$WIFI_INTERFACE" status | grep "rx_rate=" | cut -d'=' -f2)
        
        if [ -n "$rssi" ]; then
            if [ "$rssi" -gt -50 ]; then
                print_status "OK" "Signal strength: Excellent ($rssi dBm)"
            elif [ "$rssi" -gt -60 ]; then
                print_status "OK" "Signal strength: Good ($rssi dBm)"
            elif [ "$rssi" -gt -70 ]; then
                print_status "WARN" "Signal strength: Fair ($rssi dBm)"
            else
                print_status "WARN" "Signal strength: Poor ($rssi dBm)"
            fi
        fi
        
        if [ -n "$link_speed" ]; then
            print_status "OK" "Link speed: ${link_speed} Mbps"
        fi
    fi
}

check_internet() {
    if ping -c 1 -W 5 8.8.8.8 >/dev/null 2>&1; then
        print_status "OK" "Internet connectivity: Available"
    else
        print_status "FAIL" "Internet connectivity: Not available"
    fi
}

show_available_networks() {
    echo -e "${BLUE}Available Networks:${NC}"
    if wpa_cli -i "$WIFI_INTERFACE" scan_results >/dev/null 2>&1; then
        wpa_cli -i "$WIFI_INTERFACE" scan_results | tail -n +2 | while IFS=$'\t' read -r bssid freq signal level flags ssid; do
            if [ -n "$ssid" ]; then
                echo "  $ssid (${signal} dBm)"
            fi
        done
    else
        echo "  Unable to scan for networks"
    fi
    echo
}

show_configuration() {
    echo -e "${BLUE}Configuration:${NC}"
    echo "  Interface: $WIFI_INTERFACE"
    echo "  WPA Config: $WPA_CONF"
    if [ -f "$WPA_CONF" ]; then
        local configured_networks=$(grep -c "ssid=" "$WPA_CONF" 2>/dev/null || echo "0")
        echo "  Configured networks: $configured_networks"
    fi
    echo
}

show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -s, --status     Show current WiFi status (default)"
    echo "  -n, --networks   Show available networks"
    echo "  -c, --config     Show configuration"
    echo "  -r, --reconnect  Force reconnection to S23Portable"
    echo "  -h, --help       Show this help"
    echo
}

reconnect_wifi() {
    echo "Forcing WiFi reconnection..."
    /etc/init.d/S50wifi-autoconnect restart
    sleep 5
    check_connection
}

# Main logic
case "${1:---status}" in
    -s|--status)
        print_header
        check_driver
        check_interface
        check_wpa_supplicant
        check_connection
        check_signal
        check_internet
        ;;
    -n|--networks)
        print_header
        show_available_networks
        ;;
    -c|--config)
        print_header
        show_configuration
        ;;
    -r|--reconnect)
        print_header
        reconnect_wifi
        ;;
    -h|--help)
        show_help
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
