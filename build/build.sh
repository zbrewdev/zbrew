#!/bin/sh
#
# Build the binaries (right now, this is pretty trivial - just 'include' rexx and include file into single output file for 2 JSON services)
#
. zbrewfuncs
mydir=$(callerdir ${0})

cd ${mydir}/../bin
cat zbrewjsonbom.rexx readjson.include >zbrewjsonbom
cat zbrewjsonprops.rexx readjson.include >zbrewjsonprops
chmod u+x zbrewjsonbom
chmod u+x zbrewjsonprops


