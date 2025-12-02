#!/bin/bash
# Script: "iss.sh"
# Author: hans
# Datum: Wed Oct 22 12:25:05 UTC 2025

json="/var/log/app/iss.json"
iss_track="/var/log/app/iss_track.json"

if [ ! -f "$iss_track" ]; then
    echo "[]" > "$iss_track"
fi

api=$(curl -s https://api.wheretheiss.at/v1/satellites/25544)

api_lat=$(echo "$api" | jq '.latitude')
api_lon=$(echo "$api" | jq '.longitude')

cat > "$json" <<EOF
{
    "latitude": $api_lat,
    "longitude": $api_lon
}
EOF

tmpfile=$(mktemp)
jq --argjson la "$api_lat" \
   --argjson lo "$api_lon" \
   '.+ [{ "latitude": $la, "longitude": $lo }]' \
   "$iss_track" > "$tmpfile" && mv "$tmpfile" "$iss_track"

tmpfile=$(mktemp)
jq 'if length > 150 then .[-150:] else . end' "$iss_track" > "$tmpfile" && mv "$tmpfile" "$iss_track"

chmod 644 "$iss_track"
