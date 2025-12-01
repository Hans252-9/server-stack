#!/bin/bash
# Script: "airplanes.sh"
# Author: hans
# Datum: Mon Oct 27 18:06:06 UTC 2025

json="/var/log/app/airplanes.json"
la_min="48.27"
la_max="51.88"
lo_min="11.63"
lo_max="17.25"

api="https://opensky-network.org/api/states/all?"

curl -s "${api}lamin=${la_min}&lomin=${lo_min}&lamax=${la_max}&lomax=${lo_max}" \
| jq 'if .states then [.states[] | {callsign: .[1], origin_country: .[2], lat: .[6], lon: .[5], alt: .[7], velocity: .[9]}] else [] end' \
> "$json"

