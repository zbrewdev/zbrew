#!/bin/sh
#
# Basic test to ensure JSON parser working ok
#

. zbrewsetenv

# First, make sure the zhw repo has been installed

zbrewzhw_dir="${ZBREW_REPOROOT}/zbrew-zhw"
if ! [ -e "${zbrewzhw_dir}" ]; then
	echo "Need to install zhw repo to run this test" >&2
	exit 1
fi


actual=`readbom zhw110 <${zbrewzhw_dir}/zhw110/zhw110bom.json`
zbrewtest "Bill of Materials (BoM) file parsing failed" "0" "$?" 

expected="SZHWHFS ZFS 10 10 T usr/lpp/IBM/zhw/zhw110/ usr/lpp/IBM/zhw/zhw110/ hw,sepzfs
SZHWHFS2 ZFS 10 10 T usr/lpp/IBM/zhw/zhw110/sepzfs/ usr/lpp/IBM/zhw/zhw110/sepzfs/ 
SZHWSM PDSE FB 80 15 2 T
AZHWSM PDSE FB 80 15 2 D
AZHWHFS PDSE FB 80 15 2 D"

zbrewtest "Unexpected datasets" "${expected}" "${actual}"

exit 0
