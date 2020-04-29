#!/bin/sh
#
# Basic tests to ensure add and remove of datasets from PARMLIB works
# Test will:
# -Create a load module that prints out 'hello world' in pds <temp-load>(HW)
# -Add <temp-load> to the LLA              
# -Run the hello-world program via mvscmd without STEPLIB and verify it is found
# -Create a temporary dataset, <temp-csv> with a CSVLLARM member             
# -Put a 'REMOVE(<temp-load>)' into the CSVLLARM member of <temp-csv>
# -Use 'MODIFY LLA,UPDATE=RM' to remove the <temp-load> dataset from the LLA
# -Verify that running hello-world program now fails because it can't find the module
#

. zbrewsetenv

nextllname() {
	cur="$1"
	num=${cur#ZBREW*}
	if [ "${num}" = "${cur}" ]; then
		echo "ZBREW1"
	else
		if `isinteger ${num}`; then
		        next=`expr $num + 1`
		        echo "ZBREW${next}"
	        else
	                echo "ZBREW1"
 		fi
	fi
}

opout="${ZBREW_TMP}/opercmd.$$.out"
llaresults=`opercmd 'd lla'` 2>${opout}
lladatasets=`echo "$llaresults" | awk 'BEGIN { header=0; } { if (header) { print substr($0,60,44) } } / ENTRY/ {header=1}'`
curllname=`echo "$llaresults" | grep 'LNKLST SET' | awk ' { print $3; }'`
nextllname=`nextllname "${curllname}"`
endllname=`nextllname "${nextllname}"`

#set -x

export base="$$hw"
export tmpsrc="${ZBREW_TMP}/${base}.c"
export tmpo="${base}.o"
export TMPLOAD=`mvstmp`
export TMPCSV=`mvstmp`
export LNKLST="$nextllname"
export ENDLST="$endllname"

drm -f ${TMPLOAD} ${TMPCSV}
rm -f ${tmpsrc} ${tmpo}

dtouch -ru "${TMPLOAD}"
dtouch "${TMPCSV}"

echo 'int main() { puts("Hello world"); return(0); }' >${tmpsrc}
(export STEPLIB="${ZBREW_CBCHLQ}.SCCNCMP:$STEPLIB"; c89 -o"//'${TMPLOAD}(hw)'" ${tmpsrc})
zbrewtest "Unable to compile hello-world" "0" "$?"

opercmd "SETPROG LNKLST DEFINE NAME(${LNKLST}) COPYFROM(CURRENT)" >>${opout} 2>&1 
opercmd "SETPROG LNKLST ADD NAME(${LNKLST}) DSNAME(${TMPLOAD})" >>${opout} 2>&1
opercmd "SETPROG LNKLST ACTIVATE NAME(${LNKLST})" >>${opout} 2>&1	

sh -c "(export PATH=$PATH; mvscmd --pgm=HW --sysprint=*)" | grep -q 'Hello world'
zbrewtest "Unable to run hello-world. opercmd output in: ${opout}" "0" "$?"

parmlibAddDataset "${TMPCSV}"	
zbrewtest "Unable to update (add dataset) parmlib" "0" "$?"

decho "REMOVE(${TMPLOAD})" "${TMPCSV}(CSVLLARM)"
zbrewtest "Unable to update ${TMPCSV} dataset" "0" "$?"

opercmd "MODIFY LLA,UPDATE=RM" >>${opout} 2>&1

parmlibRemoveDataset "${TMPCSV}"	
zbrewtest "Unable to update (remove dataset) parmlib" "0" "$?"

opercmd "SETPROG LNKLST DEFINE NAME(${ENDLST}) COPYFROM(CURRENT)" >>${opout} 2>&1 
opercmd "SETPROG LNKLST DELETE NAME(${ENDLST}) DSNAME(${TMPLOAD})" >>${opout} 2>&1
opercmd "SETPROG LNKLST ACTIVATE NAME(${ENDLST})" >>${opout} 2>&1
opercmd "SETPROG LNKLST UNDEFINE NAME(${LNKLST})" >>${opout} 2>&1

sh -c "(export PATH=$PATH; mvscmd --pgm=HW --sysprint=dummy)"
zbrewtest "Was able to find hello-world. opercmd output in: ${opout}" "15" "$?"

rm -rf ${tmpsrc} ${tmpo} ${opout}
drm -f ${TMPLOAD} ${TMPCSV}

exit 0
