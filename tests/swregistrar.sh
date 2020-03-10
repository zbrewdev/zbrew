#!/bin/sh
#
# Basic test to ensure swregistrar works
#
. zbrewfuncs
mydir=$(callerdir ${0})
#set -x

export ZBREW_HLQ="ZBREWT."

p1="PRODUCT OWNER('IBM CORP')
        NAME('IBM APP DLIV FND')
        ID(5655-AC6)
        VERSION(*) RELEASE(*) MOD(*)
        FEATURENAME(*)
        STATE(ENABLED)"
id1='5655-ac6'

p2="PRODUCT OWNER('IBM CORP')               
        NAME('IBM IDz EE')              
        ID(5655-AC5)                    
        VERSION(*) RELEASE(*) MOD(*)    
        FEATURENAME(*)
        STATE(ENABLED)"
id2='5655-aC5'

p3="PRODUCT OWNER('IBM CORP')               
        NAME('IBM Z OPEN DEV')              
        ID(5737-I22)                    
        VERSION(*) RELEASE(*) MOD(*)    
        FEATURENAME(*)
        STATE(ENABLED)"
id3='5737-I22'

p4="PRODUCT OWNER('IBM CORP')
        NAME('IBM DBB')
        ID(5737-K80)
        VERSION(*) RELEASE(*) MOD(*)
        FEATURENAME(*)
        STATE(ENABLED)"
id4='5737-k80'

# 
# Test sad paths (check msgs when NL enablement done)
#

# Not enough parms
swregistrar >/dev/null 2>/dev/null
rc1=$?
swregistrar zhw110 >/dev/null 2>/dev/null
rc2=$?
swregistrar zhw110 enable >/dev/null 2>/dev/null
rc3=$?
swregistrar zhw110 disable >/dev/null 2>/dev/null
rc4=$?
swregistrar zhw110 enable id >/dev/null 2>/dev/null
rc5=$?

# Invalid parms
swregistrar zhw110 frindle id >/dev/null 2>/dev/null
rc6=$?

expected="8,8,8,8,8,8"
actual="$rc1,$rc2,$rc3,$rc4,$rc5,$rc6"

zbrewtest "All tests should have failed" "$expected" "$actual"

# Clean up
drm -f "${ZBREW_HLQ}PARMLIB"

# Basic test - no PDS yet. Register first product
swregistrar bgz100 enable ${id1} "${p1}"
rc7=$?
zbrewtest "Enable product" "0" "$rc7"

# Basic test - enabling a product already enabled produces an error
swregistrar bgz100 enable ${id1} "${p1}" >/dev/null 2>&1
rc8=$?
zbrewtest "Enable already enabled product" "8" "$rc8"

# Basic test - disable a product
swregistrar bgz100 disable ${id1} "${p1}" >/dev/null 2>&1
rc9=$?
zbrewtest "Disable enabled product" "0" "$rc9"

# Basic test - disable a disabled product (silent)
swregistrar bgz100 disable ${id1} "${p1}" >/dev/null 2>&1
rc10=$?
zbrewtest "Disable disabled product" "0" "$rc10"

# Enable all 4 products, then disable them in an odd order then make
# sure resultant product registration file just has a header

swregistrar bgz100 enable ${id1} "${p1}" >/dev/null 2>&1
rc11=$?
swregistrar bgz100 enable ${id2} "${p2}" >/dev/null 2>&1
rc12=$?
swregistrar bgz100 enable ${id3} "${p3}" >/dev/null 2>&1
rc13=$?
swregistrar bgz100 enable ${id4} "${p4}" >/dev/null 2>&1
rc14=$?

swregistrar bgz100 disable ${id4} "${p4}" >/dev/null 2>&1
rc15=$?
swregistrar bgz100 disable ${id2} "${p2}" >/dev/null 2>&1
rc16=$?
swregistrar bgz100 disable ${id1} "${p1}" >/dev/null 2>&1
rc17=$?
swregistrar bgz100 disable ${id3} "${p3}" >/dev/null 2>&1
rc18=$?
expected="0,0,0,0,0,0,0,0"
actual="$rc11,$rc12,$rc13,$rc14,$rc15,$rc16,$rc17,$rc18"
zbrewtest "Enable/Disable 4 products" "$expected" "$actual"

actual=`cat "//'${ZBREW_HLQ}PARMLIB(ifaprdzb)'"`
expected="/* NOTE: File generated by zbrew. Only use zbrew to change */"
zbrewtest "Enable/Disable 4 products - registration file wrong" "$expected" "$actual"

exit 0