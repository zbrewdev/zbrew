#!/bin/sh
. zbrewsetenv

ZHW110DIR="${ZBREW_WORKROOT}/zbrew-zhw/zhw110/"
if ! [ -e "${ZHW110DIR}" ]; then
        echo "Need to install zhw repo to run this test" >&2
        exit 1
fi
../../zbrew-zhw/tests/zhwoverride.sh

