#!/bin/sh
#
# Basic test to ensure JSON parser working ok
#
. zbrewfuncs
mydir=$(callerdir ${0})
#set -x

# First, make sure the zhw repo has been installed

zbrewzhw_dir="${mydir}/../../zbrew-zhw"
if ! [ -e "${zbrewzhw_dir}" ]; then
	echo "Need to install zhw repo to run this test" >&2
	exit 1
fi

actual=`readprops ZHW110 install <${zbrewzhw_dir}/zhw110/zhw110install.json`
zbrewtest "Properties file parsing failed" "0" "$?" 

expected="ZFSROOT=/zbrew/
ZFSDIR=usr/lpp/IBM/zhw/zhw110/
LEAVES=hw"

zbrewtest "Unexpected properties" "${expected}" "${actual}"

actual=`readbom zhw110 <${zbrewzhw_dir}/zhw110/zhw110bom.json`
zbrewtest "Bill of Materials (BoM) file parsing failed" "0" "$?" 

expected="SZHWHFS ZFS 10 10 T
SZHWSM PDSE FB 80 15 2 T
AZHWSM PDSE FB 80 15 2 D"

zbrewtest "Unexpected datasets" "${expected}" "${actual}"

exit 0
