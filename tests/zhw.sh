#!/bin/sh
. zbrewsetenv

ZHWDIR="${ZBREW_REPOROOT}/zbrew-zhw/"
if ! [ -d "${ZHWDIR}" ]; then
        echo "Need to install zhw repo to run this test" >&2
        exit 1
fi

#
# Override the ZBREW_SRC_HLQ to ensure test datasets go to ZHWT instead of ZBREW
#
export ZBREW_SRC_HLQ=ZBREWZS.
export ZBREW_SRC_ZFSROOT=/zbrew/zhwzs/
export ZBREW_TGT_HLQ=ZBREWZT.
export ZBREW_TGT_ZFSROOT=/zbrew/zhwzt/

${ZHWDIR}tests/zhwoverride.sh
exit $?

