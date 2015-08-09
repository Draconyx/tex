#!/bin/bash

[[ $1 ]] || { echo "Usage: $0 <customer>" && exit 1; }

# Var
whitef="$(tput setaf 7)"
normal="$(tput sgr0)"
date=$(date +"%Y%m%d")
cust="$1"
invoice="cust-${cust}-${date}"

# Functions
ask()     { printf "${whitef}$*${normal}"; }

# Copy template
{ [[ -d invoice ]] && cp -r invoice/ $invoice; } || { echo "dir invoice doesn't exist, template not copied" && exit 1; }
cd $invoice

ask "Enter your company e-mail address (e.g. jschipp@draconyx.net): "
read -e -r EMAIL
[[  $EMAIL ]] || { echo "Invalid response, exiting.." && exit 1; }

ask "Enter your contact phone number (e.g. (812) 555-5555: "
read -e -r PHONE
[[  $PHONE ]] || { echo "Invalid response, exiting.." && exit 1; }

ask "Enter the recipients company name (e.g. Bob's Burgers, LLC.): "
read -e -r COMPANY
[[  $COMPANY ]] || { echo "Invalid response, exiting.." && exit 1; }

ask "Enter the recipients personal full name: (e.g. Bob Belcher): "
read -e -r NAME
[[  $NAME ]] || { echo "Invalid response, exiting.." && exit 1; }

ask "Enter hourly rate (e.g. 100): "
read -e -r RATE
[[  $RATE ]] || { echo "Invalid response, exiting.." && exit 1; }

ask "Enter invoice number (e.g. 1): "
read -e -r INUM
[[  $INUM ]] || { echo "Invalid response, exiting.." && exit 1; }



ask "Continue? [Y/N]: "
read -e -r TRY
[[ "$TRY" =~ ^[Nn]$ ]] && { echo "No selected, exiting.." && exit 1; }
[[ "$TRY" =~ ^[nN][oO]$ ]] && { echo "No selected, exiting.." && exit 1; }
[[ $TRY ]] || { echo "Invalid response, exiting.." && exit 1; }

sed -i.bu "s/user@company/$EMAIL/" invoice.tex
sed -i.bu "s/333-333-4444/$PHONE/" invoice.tex
sed -i.bu "s/CompanyName/$COMPANY/" invoice.tex
sed -i.bu "s/CustomerName/$NAME/" invoice.tex
sed -i.bu "s/CustomerName/$RATE/" invoice.tex
sed -i.bu "s/HourlyRate/$RATE/" invoice.tex
sed -i.bu "s/InvoiceNum/$INUM/" invoice.tex

rm -f *.bu
vim invoice.tex
pdflatex invoice.tex && open invoice.pdf
