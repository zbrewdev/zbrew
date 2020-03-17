#!/bin/sh
. zbrewsetenv

ZHWDIR="${ZBREW_WORKROOT}/zbrew-zhw/"
if ! [ -d "${ZHWDIR}" ]; then
        echo "Need to install zhw repo to run this test" >&2
        exit 1
fi
${ZHWDIR}/tests/zhwoverride.sh
exit $?

