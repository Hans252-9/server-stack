#!/bin/bash
# Script: "apod.sh"
# Author: hans
# Datum: Mon Oct 27 13:25:51 UTC 2025

picture=/opt/app/web/apod.jpg
API_KEY="${NASA_API_KEY:?NASA_API_KEY not set}"

url=$(curl -s "https://api.nasa.gov/planetary/apod?api_key=${API_KEY}" | jq -r '.url')

curl -s "$url" -o "$picture"

