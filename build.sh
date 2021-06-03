#!/bin/sh

if [ ! -d "./build" ] 
then
  mkdir build
fi

#fi=`find . -name '*.bicep' -print`
fi=`ls *.bicep`
for ef in $fi
do
  echo "Building >> "$ef
  bicep build $ef --outdir build
done

cp *.parameters.json build
cp metadata.json build