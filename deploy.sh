#!/bin/sh
#set -x
function syntax {
	echo "Syntax: deploy.sh <directory>"
	echo " deploy the bill of materials to the specified directory"
	return 0
}

if [ $# -ne 1 ]; then
	echo "Need to provide a directory to deploy to. No parameter given."
	syntax
	exit 16
fi
if [ ! -d $1 ]; then 
	echo "Need to specify a directory to deploy to. $1 is not a directory."
	syntax
	exit 16
fi

rm -rf $1/properties $1/bin $1/docs
mkdir $1/docs
mkdir $1/docs/C
mkdir $1/docs/C/cat1
mkdir $1/bin
mkdir $1/properties

names=`cat zbrew.bom`
code="${names}"

#msg=""
#man=""
#for n in ${names}; do
#	msg="${msg} ${n}-msg.1"
#done
#for n in ${names}; do
#	man="${man} ${n}.1"
#done

#cd docs/C/cat1
#cp ${man} $1/docs/C/cat1
#cd ../
#cp ${msg} $1/docs/C
#cd ../../

for c in ${code}; do
	cp -p ${c} $1/${c}
done

exit $? 
