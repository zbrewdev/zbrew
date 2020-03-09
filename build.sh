#!/bin/sh
#
# Build the binaries (right now, this is pretty trivial - just 'include' rexx and include file into single output file for 2 JSON services)
#
. zbrewfuncs
mydir=$(callerdir ${0})

cd ${mydir}/bin
cat readbom.rexx readjson.include >readbom
cat readchild.rexx readjson.include >readchild
cat readparent.rexx readjson.include >readparent
cat readprops.rexx readjson.include >readprops
cat readreq.rexx readjson.include >readreq
chmod u+x readbom
chmod u+x readchild
chmod u+x readparent
chmod u+x readprops
chmod u+x readreq
