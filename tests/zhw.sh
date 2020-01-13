#!/bin/sh
#
# Basic test to ensure zhw can be installed and configured
#
. zbrewfuncs
mydir=$(callerdir ${0})
#set -x

# First, make sure the zhw repo has been installed

if ! [ -e "${mydir}/../../zbrew-zhw" ]; then
	echo "Need to install zhw repo to run this test" >&2
	exit 1
fi

# Clear up any jetsam from a previous run
drm -f "${ZBREW_HLQ}zhw*.*"

# Search for product

result=`zbrew search hello`
if [ "${result}" != "ZHW110 1234-AB5 ZBREW Hello World Unit Test Software V1.1" ]; then 
	echo "zbrew search hello failed with result: ${result}" >&2
	exit 2
fi
# Basic install / configure

zbrew install zhw110
rc=$?
if [ $rc != 0 ]; then
	echo "zbrew install failed with rc:$rc" >&2
	exit 3
fi

zbrew configure zhw110
rc=$?
if [ $rc != 0 ]; then
	echo "zbrew configure failed with rc:$rc" >&2
	exit 4
fi

exit 0
