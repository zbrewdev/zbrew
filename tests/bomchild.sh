#!/bin/sh
#
# Basic test to ensure Parent bomread working ok
#
. zbrewsetenv

zbrew_dir="${mydir}/../../zbrew"
if ! [ -e "${zbrew_dir}" ]; then
	echo "Need to install zbrew to run this test" >&2
	exit 1
fi

actual=`readchild bomtest <${zbrew_dir}/tests/bomtest.json`
zbrewtest "Bill of Materials (BoM) file parsing failed" "0" "$?"

expected=" CHILD1 CHILD2 CHILD3"
zbrewtest "Unexpected datasets" "${expected}" "${actual}"


exit 0
