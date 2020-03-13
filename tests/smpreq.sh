#!/bin/sh
#
# Basic test to ensure requisite checking works
#
. zbrewfuncs
mydir=$(callerdir ${0})
props="${mydir}/../zbrewglobalprops.json"
zbrewpropse zbrew config "${props}"
#set -x

# First, make sure the zhw repo has been installed

ZHW110DIR="${ZBREW_WORKROOT}/zbrew-zhw/zhw110/"
if ! [ -e "${ZHW110DIR}" ]; then
	echo "Need to install zhw repo to run this test" >&2
	exit 1
fi
actual=`readreq zhw110 <${ZHW110DIR}/zhw110req.json`
expected="PREREQ CEE ZOS220 HLE77A0 UI30573 UI31702 UI33265 UI43053 UI45429 UI43458 UI49699 UI53511 UI53889 UI54726 UI56507 UI61245 UI29282
PREREQ CEE ZOS230 HLE77B0 UI50167 UI53807 UI53820 UI56511 UI61244
PREREQ CEE ZOS240 HLE77C0 HLE77C0
COREQ DFH DFH520 HCI6900 UI22206 UI30410
COREQ ASM ASM160 HMQ4160 UK47103 UK59311"

zbrewtest "Requisites for ZHW110 not as expected" "${expected}" "${actual}"

exit 0
