#!/bin/sh
#
# Basic test to ensure zhw can be installed and configured
#
. zbrewfuncs
mydir=$(callerdir ${0})
#set -x

# First, make sure the zhw repo has been installed

ZHW110DIR="${mydir}/../../zbrew-zhw/zhw110/"
if ! [ -e "${ZHW110DIR}" ]; then
	echo "Need to install zhw repo to run this test" >&2
	exit 1
fi

# Clear up any jetsam from a previous run
zbrewpropse zbrew config ${mydir}/../properties/zbrewprops.json
zbrewpropse zhw110 install ${ZHW110DIR}zhw110install.json

# Clear up any jetsam from a previous run
MOUNT="${ZFSROOT}${ZFSDIR}"
unmount "${MOUNT}" 2>/dev/null
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
