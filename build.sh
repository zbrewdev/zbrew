#!/bin/sh
#
# Build the binaries (right now, this is pretty trivial - just 'include' rexx and include file into single output file for 2 JSON services)
#
. zbrewfuncs
mydir=$(callerdir ${0})

cd ${mydir}/bin
cat readbom.rexx readjson.include >readbom
cat readprops.rexx readjson.include >readprops
chmod u+x readbom
chmod u+x readprops


