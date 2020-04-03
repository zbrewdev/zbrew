#!/bin/sh
#set -x
#
# Run through each of the tests in the test bucket that aren't 
# explicitly excluded, and return the highest error code
#
# Override the ZBREW_SRC_HLQ to ensure test datasets go to ZBREWV (for verification) instead of ZBREW
#
export ZBREW_SRC_HLQ=ZBREWVS.
export ZBREW_SRC_ZFSROOT="${ZBREW_TMP}/zbrewvs/"
export ZBREW_TGT_HLQ=ZBREWVT.
export ZBREW_TGT_ZFSROOT="${ZBREW_TMP}/zbrewvt/"

. zbrewsetenv
export PATH=$ZBREW_ROOT/testtools:$PATH

. zbrewtestfuncs
runtests "${mydir}/tests" "$1"
exit $?

