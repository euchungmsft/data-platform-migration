#!/bin/sh

if [ $# -lt 1 ]
  then
    echo "Removes all resources of given resource group. It actually doesn't remove anything"
    echo "rmall.sh {Resource Group Name}"
    exit
fi

RGNAME=$1

JST1=`az resource list --resource-group $RGNAME`
echo "$JST1" | python3 -c "
import sys, json, subprocess;

#print(json.load(sys.stdin)[0]['name'])
jso = json.load(sys.stdin)
buf2 = ''
for rcs in jso:
  #print(rcs['name'], rcs['type'])
  #buf = \"az resource delete --resource-group %s -name %s --resource-type %s \" % ('TEST1', rcs['name'], rcs['type'])
  #buf = \"az resource delete --ids %s \" % (rcs['id'])
  buf2 += \"%s \" % (rcs['id'])

print('Run this from your command line')
print(\"az resource delete --ids %s\" % (buf2))
"

