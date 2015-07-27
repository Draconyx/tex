#!/bin/bash
{ [[ -f token ]] && source token; } || { echo "Token required, try: echo 'api=xxxx-xxxxxxxxx-xxxx' > token" && exit 1; }
date=$(date +"%Y%m%d")
[[ $1 ]] || { echo "Usage: $0 <path/to/invoice.pdf>" && exit 1; }
file="$1"
[[ -f $file ]] || { echo "File $file doesn't exist..exiting" && exit 1; }
dir=$(dirname $file)
company=$(grep company cust-skyline-20150727/invoice.tex | sed -e 's/\\tab//' -e 's/\\.*//')
[[ $api ]] || { echo "Token not set..exiting" && exit 1; }
curl -F file=@${file} -F channels=#invoices -F filetype=pdf -F filename="$file" -F title="$company $date" -F token=${api} https://slack.com/api/files.upload
