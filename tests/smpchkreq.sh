#!/bin/sh
#
# Basic test to ensure requisite checking works
#
. zbrewsetenv

# First, make sure the zhw repo has been installed

ZHW110DIR="${ZBREW_WORKROOT}/zbrew-zhw/zhw110/"
if ! [ -e "${ZHW110DIR}" ]; then
	echo "Need to install zhw repo to run this test" >&2
	exit 1
fi

# zhw has a pre-req on either LE 2.2 or LE 2.3
# zhw has a co-req on CICS 5.2 and Assembler 1.6

# first, unset any CSI's that might be specified
# this should fail because at least one pre-req LE has to be provided
unset ZBREW_CEE220_CSI
unset ZBREW_CEE230_CSI
unset ZBREW_DFH520_CSI
unset ZBREW_ASM160_CSI

actual=`smpchkreq zhw110 ${ZHW110DIR}/zhw110req.json 2>&1`
rc=$?
expected="The following pre-requisite product ids had no CSI specification for any release:
  CEE
At least one pre-requisite product release must have a CSI specification provided"

if [ $rc -eq 0 ]; then
	zbrewtest "Requisite checks for ZHW110 should have failed because no LE CSI specified" 
fi
if [ $rc -eq 8 ]; then
	zbrewtest "Requisite checks for ZHW110 had unexpected output" "${expected}" "${actual}"
fi

# Specify a pre-req CSI dataset for LE 2.3 and co-req Assembler 1.6 but not the others
# This should pass because a pre-req LE is specified and co-reqs do not need to be specified
export ZBREW_CEE230_CSI="MVS.GLOBAL.CSI"

actual=`smpchkreq zhw110 ${ZHW110DIR}/zhw110req.json`
rc=$?
expected=""

if [ $rc -gt 0 ]; then
	zbrewtest "Requisites for ZHW110 not as expected" "${expected}" "${actual}"
fi

exit 0
