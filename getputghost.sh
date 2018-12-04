#!/bin/bash
# This script get the list of ghostproxies from the website, edit it to the right json format and uploads it to the S3bucket

#make sure you specify the right bucket here
mys3bucket=importio-test-public
echo "$mys3bucket is where your Ghost proxy file will be uploaded to "

#clean up newpr and oldpr dirs
`rm ./newpr/ghost*.json*`
`rm ./oldpr/ghost*.json*`

#create filename that includes today's date
fname="ghostproxies_"`date +%m`"_"`date +%d`"_"`date +%Y`
fx=".json"
fnamex="$fname$fx"
echo "working on ..." $fnamex

#get the list of ghostproxies for Import and edit it to the json format rquired

curl https://ghostproxies.com/proxies/api/import.json > ./newpr/$fnamex
sleep 5
sed -i -e "s/}]}/}], \"name\": \"$fname\"}/" ./newpr/$fnamex
sed -i -e "s/ip/host/g" ./newpr/$fnamex
echo `grep -o "host"  ./newpr/$fnamex|wc -l` "IP addresses processed"


#saving old json file to oldpr dir
aws s3 sync s3://$mys3bucket/ ./oldpr --exclude '*' --include 'ghost*.json'
oldf=`ls ./oldpr/*.json`
echo "file deleted : " $oldf
aws s3 rm s3://$mys3bucket/$oldf

#upload new proxyfile to S3
aws s3 cp ./newpr/$fnamex s3://$mys3bucket/
