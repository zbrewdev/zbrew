#!/bin/sh
#
# Basic tests to ensure add and remove of datasets from PARMLIB works
# Test will:
# -Create a load module that prints out 'hello world' in pds <temp-load>(HW)
# -Add <temp-load> to the LLA              
# -Run the hello-world program via mvscmd without STEPLIB and verify it is found
# -Remove <temp-load> from the LLA
# -Verify that running hello-world program now fails because it can't find the module
#

. zbrewsetenv

#set -x
TMPLOAD=`mvstmp`
base="parmlib$$"
tmpsrc="${ZBREW_TMP}/${base}.c"
tmpo="${base}.o"
drm -f ${TMPLOAD}
rm -f ${tmpsrc} ${tmpo}

dtouch -ru "${TMPLOAD}"

echo 'int main() { puts("Hello world"); return(0); }' >${tmpsrc}
(export STEPLIB="${ZBREW_CBCHLQ}.SCCNCMP:$STEPLIB"; c89 -o"//'${TMPLOAD}(zhw)'" ${tmpsrc})
zbrewtest "Unable to compile hello-world" "0" "$?"
rm "${tmpsrc}" "${tmpo}"

llaAddDataset "${TMPLOAD}"
zbrewtest "Unable to load ${TMPLOAD} into LLA" "0" "$?"

sh -c "(export PATH=$PATH; mvscmd --pgm=ZHW --sysprint=*)" | grep -q 'Hello world'
zbrewtest "Unable to run hello-world" "0" "$?"

llaRemoveDataset "${TMPLOAD}"
zbrewtest "Unable to remove ${TMPLOAD} from LLA" "0" "$?"

sh -c "(export PATH=$PATH; mvscmd --pgm=ZHW --sysprint=dummy 2>/dev/null)"
zbrewtest "Was able to find hello-world" "15" "$?"

drm ${TMPLOAD}
zbrewtest "Unable to delete load module" "0" "$?"

exit 0
