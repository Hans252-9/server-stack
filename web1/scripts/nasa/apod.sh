#!/bin/bash
# Script: "apod.sh"
# Author: hans
# Datum: Mon Oct 27 13:25:51 UTC 2025

picture=/opt/app/web/apod.jpg


url=$(curl -s "https://api.nasa.gov/planetary/apod?api_key=YoP0mZxujKOeBRem9Szf4BhVh0Qs96DeU7Guzxyy" | jq -r '.url')

curl -s "$url" -o "$picture"

