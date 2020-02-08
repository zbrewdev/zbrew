#!/bin/sh

. zbrewfuncs
mydir=$(callerdir ${0})

# First, make sure the zhw repo has been installed

${mydir}/../../zbrew/build.sh # required if first ever run

ZHW110DIR="${mydir}/../../zbrew-zhw/zhw110/"
if ! [ -e "${ZHW110DIR}" ]; then
        echo "Need to install zhw repo to run this test" >&2
        exit 1
fi
../../zbrew-zhw/tests/zhwoverride.sh

