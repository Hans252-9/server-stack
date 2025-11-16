#!/bin/bash
# Script: "portfolio.sh"
# Author: hans
# Datum: Mon Oct 27 09:29:19 UTC 2025

api="https://finnhub.io/api/v1/quote"
token="d3vk029r01qju1gsa400d3vk029r01qju1gsa40g"
symbols_usd=("MTB" "ASML" "STLA" "WSM" "META" "LULU" "IBIT" "TLT")
symbols_czk=("CEZ.PR")
log="/var/log/app/portfolio.log"


{
  echo "Portfolio report $(date)"
  echo ""
  printf "%-10s %10s\n" "SYMBOL" "PRICE"
  printf "%-10s %10s\n" "------" "------"
} > $log



for s in "${symbols_czk[@]}"; do
  price_czk=$(curl -s "${api}?symbol=${s}&token=${token}" | jq '.c')
  printf "%-10s %10s\n" "${s}" "${price_czk} CZK" >> $log
done

for i in "${symbols_usd[@]}"; do
  price_usd=$(curl -s "${api}?symbol=${i}&token=${token}" | jq '.c')
  printf "%-10s %10s\n" "${i}" "${price_usd} USD" >> $log
done

usd_czk=$(curl -s "https://open.er-api.com/v6/latest/USD" | jq '.rates.CZK')

printf -v usd_czk "%.2f" "$usd_czk"
printf "%-10s %10s\n" "USD/CZK" "${usd_czk} CZK" >> $log

