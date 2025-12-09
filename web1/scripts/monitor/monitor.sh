#!/bin/bash
# Script: "monitor.sh"
# Author: hans
# Datum: Sun Oct 19 09:53:31 UTC 2025

#DB nastaveni
DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-monitoring}"
DB_USER="${DB_USER:-monitor}"
DB_PASS="${DB_PASS:-monitor_pass}"

DISK=$(df -h | awk '/\/hostfs/ {print$5}' | tr -d '%')
HOSTNAME="$(hostname)"

ram_total=$(grep MemTotal /host/proc/meminfo | awk '{print$2}')
ram_avail=$(grep MemAvailable /host/proc/meminfo | awk '{print $2}')
RAM_PERCENT=$(awk -v a="$ram_avail" -v b="$ram_total" 'BEGIN { printf "%.2f", (1 - a/b) * 100}')

uptime_sec=$(cut -d. -f1 "/host/proc/uptime")
days=$((uptime_sec / 86400))
after_days=$((uptime_sec % 86400))
hours=$((after_days / 3600))
after_hours=$((after_days % 3600))
mins=$((after_hours / 60))
sec=$((after_hours % 60))

read -r _ user1 nice1 sys1 idle1 iow1 irq1 sirq1 st1 _ _ < "/host/proc/stat"

sleep 1

read -r _ user2 nice2 sys2 idle2 iow2 irq2 sirq2 st2 _ _ < "/host/proc/stat"

total1=$((user1 + nice1 + sys1 + idle1 + iow1 + irq1 + sirq1 + st1))
total2=$((user2 + nice2 + sys2 + idle2 + iow2 + irq2 + sirq2 + st2))
total_diff=$((total2 - total1))
idle_diff=$((idle2 - idle1))
cpu_usage=$(awk -v idle="$idle_diff" -v total="$total_diff" 'BEGIN { printf "%.2f", (1 - idle/total)*100 }')


LOG="/var/log/app/monitor.log"


echo "Host srver je UP: ${days}d ${hours}h ${mins}m ${sec}s " > "$LOG"
echo "Disk serveru je vyuzit z ${DISK}%" >> "$LOG"
echo "Aktualni vyuziti CPU je: ${cpu_usage}%" >> "$LOG"
echo "Aktualni vyuziti RAM je: ${RAM_PERCENT}%" >> "$LOG"

#Insert do PostgreSQL
PGPASSWORD="$DB_PASS" psql \
  -h "$DB_HOST" \
  -p "$DB_PORT" \
  -U "$DB_USER" \
  -d "$DB_NAME" \
  -c "INSERT INTO server_stats (cpu_usage, ram_usage, disk_usage, hostname) VALUES ($cpu_usage, $RAM_PERCENT, $DISK, '$HOSTNAME');"
