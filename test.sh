#!/bin/sh
#*******************************************************************************
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2019. All Rights Reserved.
#
# Note to U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
#*******************************************************************************
#
# Run through each of the tests in the test bucket that aren't 
# explicitly excluded, and return the highest error code
#

. zbrewfuncs
mydir=$(callerdir ${0})

cd ${mydir}/tests

rm -f *.actual
#set -x

#
# Override the ZBREW_HLQ to ensure test datasets go to ZBREWT instead of ZBREW
#
export ZBREW_HLQ=ZBREWT.
export ZBREW_ZFSROOT="/ZBREWT/"

if [ -z $1 ] ; then
	tests=*.sh
else
	tests=${1}.sh
fi

if [ -z "${TEST_SKIP_LIST}" ]; then
	export TEST_SKIP_LIST=""
fi

maxrc=0
for test in ${tests}; do
	name="${test%.*}"
	if [ "${name}" = "test" ]; then
		continue;
	fi
	if test "${TEST_SKIP_LIST#*$name}" != "$TEST_SKIP_LIST"; then
		echo "Skip test ${name}"
	else
		echo "Run test ${name}"
		if [ -e ${name}.parm ]; then
			parms=`cat ${name}.parm`
		else
			parms=''
		fi
		if [ -e ${name}.expected ]; then 
			${test} ${parms} >${name}.actual 2>&1
			mdiff -Z ${name}.expected ${name}.actual
			rc=$?
		else 

			${test} ${parms} > /dev/null 2>/dev/null
			rc=$?
		fi 
		if [ ${rc} -gt ${maxrc} ]; then
			${test} -dv ${parms}
			echo "Failed test ${name}"
			exit $rc
            maxrc=${rc}
		fi
	fi
done
exit ${maxrc} 

