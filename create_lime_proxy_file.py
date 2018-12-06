#This pgm gets a list of Limeproxies from the site and converts it to a json file for import
#prod-id 46047 can be obtained with curl -X GET -H 'Content-type: application/json' -H "Authorization: Bearer $TOKEN" "https://api.limeproxies.com/v2/product/active"

import requests
import re
import json
import datetime

TOKEN="6689f3b832c72130871ab20e6a1edd78d15c4d587f45bb498426cbe94aef68ce"
AUTH = "Bearer " + TOKEN

headers = {
    'Content-type': 'application/json',
    'Authorization': AUTH
}

response = requests.get('https://api.limeproxies.com/v2/product/46047/status', headers=headers)
content = response.json()

#store the response in a file for further manipulation
f = open("lime.txt", "w")
print >> f, response.json()
f.close()

#pull out all the ip add and create json file
#note that port, username and pwd are same for all ips
#username and pwd is the one we use to login to limeproxies website

#create output json file with date
now = datetime.datetime.now()
fname= "limeproxies" + now.strftime("_%Y_%m_%d") + ".json"

f = open("lime.txt", "r")
line = f.readline()
f.close()

iplist = re.findall(r'(?:\d{1,3}\.){3}\d{1,3}', line)

outfile = open(fname,'w')
doc = {}

doc['provider'] = "limeproxies"
proxies = []
index = 0
#for line in infile:
for ipadd in iplist:
	index += 1
	port = "1212"
	proxy = {}
	proxy['host'] = ipadd
	proxy['port'] = "1212"
	proxy['username'] = "user-42399"
	proxy['password'] = "PB3Uy49i3Qdcq"
	proxies.append(proxy)

doc['proxies'] = proxies
output = json.dumps(doc)
outfile.write(output)

outfile.close()
print "Done... need to upload ", fname, "to S3"
