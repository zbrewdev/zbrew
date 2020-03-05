#!/bin/sh
#
# Basic test to ensure Parent bomread working ok
#
. zbrewfuncs
mydir=$(callerdir ${0})
#set -x

# First, make sure the zhw repo has been installed

zbrew_dir="${mydir}/../../zbrew"
if ! [ -e "${zbrew_dir}" ]; then
	echo "Need to install zbrew to run this test" >&2
	exit 1
fi


actual=`readparent bomtest <${zbrew_dir}/tests/bomtest.json`
zbrewtest "Bill of Materials (BoM) file parsing failed" "0" "$?" 

expected="PARENT1"
zbrewtest "Unexpected datasets" "${expected}" "${actual}"


exit 0
