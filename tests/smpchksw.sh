#!/bin/sh
#
# Basic test to ensure smpchksw is working ok
#
. zbrewfuncs
mydir=$(callerdir ${0})
#set -x

#
# The following are valid for a z/OS 2.3 ADCD distro
#
# smpchksw  igy620.global.csi hadb620 ui60666 ui60666 ui52160
export CSI=IGY620.GLOBAL.CSI
export FMID=HADB620
export PTFLIST="ui60666 UI52160"

# Happy path
result=`smpchksw ${CSI} ${FMID} ${PTFLIST}`
rc=$?
if [ $rc -gt 0 ]; then 
	echo "smpchksw failed to verify that ${FMID} has ${PFTLIST} PTFs installed" >&2
	exit 1
fi

# Invalid CSI

errout=/tmp/$$.smpchksw.stderr
export CSI=IGY930.GLOBAL.CSI

result=`smpchksw ${CSI} ${FMID} ${PTFLIST}` 2>${errout}
rc=$?
if [ $rc -eq 0 ]; then
	echo "smpchksw should have failed to find ${CSI} CSI." >&2
	exit 2
else
	expected="Unable to determine global zone for: ${CSI}"
	grep "${expected}" ${errout} >/dev/null
	if [ $? -gt 0 ]; then
		actual=`cat ${errout}`
		zbrewtest "smpchksw failed with incorrect message" "${expected}" "${actual}"
		exit 3
	fi
fi
rm ${errout}

# FMID not found   
export CSI=IGY620.GLOBAL.CSI
export FMID=HADB120

result=`smpchksw ${CSI} ${FMID} ${PTFLIST}` 2>${errout}
rc=$?
if [ $rc -eq 0 ]; then
	echo "smpchksw should have failed to find ${FMID} FMID." >&2
        exit 2
else
        expected="FMID ${FMID} is not in any target zone in ${CSI}" 
 	grep "${expected}" ${errout} >/dev/null
        if [ $? -gt 0 ]; then
		actual=`cat ${errout}`
                zbrewtest "smpchksw failed with incorrect message" "${expected}" "${actual}"
      		exit 3
	fi
fi
rm ${errout}

# Some PTFs missing
export FMID=HADB620
export BADPTF=UQ60666
export PTFLIST="${BADPTF} UI52160"
result=`smpchksw ${CSI} ${FMID} ${PTFLIST}` 2>${errout}
rc=$?
if [ $rc -eq 0 ]; then
        echo "smpchksw should have failed to find ${BADPTF} PTF." >&2
        exit 2
else
	expected="The missing PTFs are: ${BADPTF}"
        grep "${expected}" ${errout} >/dev/null
	if [ $? -gt 0 ]; then
		actual=`cat ${errout}`
                zbrewtest "smpchksw failed with incorrect message" "${expected}" "${actual}"
		exit 3
        fi
fi
rm ${errout} 

# Too few parms
result=`smpchksw ${CSI} ${FMID}`  2>${errout}
rc=$?
if [ $rc -eq 0 ]; then
        echo "smpchksw should have failed with too few parms" >&2
 	exit 2
else
        expected="Too few parameters specified"
        grep "${expected}" ${errout} >/dev/null
	if [ $? -gt 0 ]; then
 		actual=`cat ${errout}`
                zbrewtest "smpchksw failed with incorrect message" "${expected}" "${actual}"
 		exit 3
        fi
fi

exit 0
