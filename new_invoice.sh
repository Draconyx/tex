#!/bin/bash
ask()     { printf "${whitef}$*${normal}"; }

[[ $1 ]] || { echo "Usage: $0 <customer>" && exit 1; }

# Var
date=$(date +"%Y%m%d")
cust="$1"
invoice="cust-${cust}-${date}"

# Copy template
{ [[ -d invoice ]] && cp -r invoice/ $invoice; } || { echo "dir invoice doesn't exist, template not copied" && exit 1; }
cd $invoice

ask "Enter your company e-mail address (e.g. jschipp@draconyx.net): "
read -e -r EMAIL
[[  $EMAIL ]] || { echo "Invalid response, exiting.." && exit 1; }
sed -i.bu "s/user@company/$EMAIL/" invoice.tex

ask "Enter your contact phone number (e.g. (812) 555-5555: "
read -e -r PHONE
[[  $PHONE ]] || { echo "Invalid response, exiting.." && exit 1; }
sed -i.bu "s/333-333-4444/$PHONE/" invoice.tex

ask "Enter the recipients company name (e.g. Bob's Burgers, LLC.): "
read -e -r COMPANY
[[  $COMPANY ]] || { echo "Invalid response, exiting.." && exit 1; }
sed -i.bu "s/CompanyName/$COMPANY/" invoice.tex

ask "Enter the recipients personal full name: (e.g. Bob Belcher)"
read -e -r NAME
[[  $NAME ]] || { echo "Invalid response, exiting.." && exit 1; }
sed -i.bu "s/CustomerName/$NAME/" invoice.tex

rm -f *.bu
vim invoice.tex
pdflatex invoice.tex && open invoice.pdf
