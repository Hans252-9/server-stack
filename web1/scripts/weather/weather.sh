#!/bin/bash
# Script: "weather.sh"
# Author: hans
# Datum: Tue Oct 21 17:50:38 UTC 2025

#DB nastaveni
DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-monitoring}"
DB_USER="${DB_USER:-monitor}"
DB_PASS="${DB_PASS:-monitor_pass}"

LOG="/var/log/app/weather.log"

PRAHA_LAT=50.08
PRAHA_LON=14.42

BRNO_LAT=49.19
BRNO_LON=16.60

OSTRAVA_LAT=49.82
OSTRAVA_LON=18.26

NOVY_JICIN_LAT=49.59
NOVY_JICIN_LON=18.01

SNEZKA_LAT=50.73
SNEZKA_LON=15.73

HORSKA_KVILDA_LAT=49.07
HORSKA_KVILDA_LON=13.57

HRA_LAT=49.80
HRA_LON=14.27

PRAHA_DATA=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${PRAHA_LAT}&longitude=${PRAHA_LON}&current_weather=true&timezone=auto")
BRNO_DATA=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${BRNO_LAT}&longitude=${BRNO_LON}&current_weather=true&timezone=auto")
OSTRAVA_DATA=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${OSTRAVA_LAT}&longitude=${OSTRAVA_LON}&current_weather=true&timezone=auto")
NOVY_JICIN_DATA=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${NOVY_JICIN_LAT}&longitude=${NOVY_JICIN_LON}&current_weather=true&\
timezone=auto")

SNEZKA_DATA=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${SNEZKA_LAT}&longitude=${SNEZKA_LON}&current_weather=true&timezone=auto")
HORSKA_KVILDA_DATA=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${HORSKA_KVILDA_LAT}&longitude=${HORSKA_KVILDA_LON}&current_weather=true\
&timezone=auto")

HRA_DATA=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${HRA_LAT}&longitude=${HRA_LON}&current_weather=true&timezone=auto")

PRAHA_TEMP=$(echo "$PRAHA_DATA" | jq '.current_weather.temperature')
BRNO_TEMP=$(echo "$BRNO_DATA" | jq '.current_weather.temperature')
OSTRAVA_TEMP=$(echo "$OSTRAVA_DATA" | jq '.current_weather.temperature')
NOVY_JICIN_TEMP=$(echo "$NOVY_JICIN_DATA" | jq '.current_weather.temperature')
SNEZKA_TEMP=$(echo "$SNEZKA_DATA" | jq '.current_weather.temperature')
HORSKA_KVILDA_TEMP=$(echo "$HORSKA_KVILDA_DATA" | jq '.current_weather.temperature')
HRA_TEMP=$(echo "$HRA_DATA" | jq '.current_weather.temperature')

insert_temp() {
  local place="$1"
  local temp="$2"

  [ "$temp" = "null" ] && return

#Insert do PostgreSQL
  PGPASSWORD="$DB_PASS" psql \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    -U "$DB_USER" \
    -d "$DB_NAME" \
    -c "INSERT INTO temperatures (place, temp_c) VALUES ('$place', $temp);" > /dev/null
}

insert_temp "PRAHA"         "$PRAHA_TEMP"
insert_temp "BRNO"          "$BRNO_TEMP"
insert_temp "OSTRAVA"       "$OSTRAVA_TEMP"
insert_temp "NOVY_JICIN"    "$NOVY_JICIN_TEMP"
insert_temp "SNEZKA"        "$SNEZKA_TEMP"
insert_temp "HORSKA_KVILDA" "$HORSKA_KVILDA_TEMP"
insert_temp "MALA_HRASTICE" "$HRA_TEMP"

echo "PRAHA ${PRAHA_TEMP}°C | BRNO ${BRNO_TEMP}°C | OSTRAVA ${OSTRAVA_TEMP}°C | NOVY JICIN ${NOVY_JICIN_TEMP}°C | SNEZKA ${SNEZKA_TEMP}°C\
 | HORSKA KVILDA ${HORSKA_KVILDA_TEMP}°C | MALA HRASTICE ${HRA_TEMP}°C" > $LOG







