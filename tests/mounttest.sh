#!/bin/sh
#
# Basic test to ensure zbrewmount works for both mount and unmount
#

function crtzfs {
    dsname=$1
	cmdout="${ZBREW_TMP}/cmd.out"
	touch "${cmdout}"
	
	# define a VSAM ZFS dataset 
	mvscmdauth --pgm=IDCAMS --sysprint="${cmdout}" --sysin=stdin <<zzz
	  DEFINE CLUSTER(NAME(${dsname}) -
	  LINEAR TRACKS(10 10) SHAREOPTIONS(3))
zzz
	rc=$?
	if [ $rc -gt 0 ]; then
		echo "Error creating ZFS Linear Cluster:  $rc" >&2
		cat "${cmdout}" >&2
		return $rc
	fi
	mvscmdauth --pgm=IOEAGFMT --args="-aggregate ${dsname} -compat" --sysprint="${cmdout}"
	rc=$?
	if [ $rc -gt 0 ]; then
		echo "Error formatting ZFS: $rc" >&2
		cat "${cmdout}" >&2
		return $rc
	fi
	rm -f "${cmdout}"
}

function cleanup {
    drm -f "${ZBREW_SRC_HLQ}ZHW110*.**"
    drm -f "${ZBREW_TGT_HLQ}ZHW110*.**"
    rm $err 2>/dev/null
}

function assert {
    expected=$1
    actual=$2
    if ! [ $expected -eq $actual ]; then
	    echo "$(cat $err)"
    fi
}

#main
. zbrewsetenv

export ZBREW_SRC_HLQ=ZBREWTS.
export ZBREW_SRC_ZFSROOT=/zbrew/mts/
export ZBREW_TGT_HLQ=ZBREWTT.
export ZBREW_TGT_ZFSROOT=/zbrew/mtt/

err="${ZBREW_TMP}/err.out"
cleanup

crtzfs ${ZBREW_SRC_HLQ}ZHW110.SZHWHFS
crtzfs ${ZBREW_SRC_HLQ}ZHW110.SZHWHFS2
touch "${err}"

#test1: a valid case
#-------------------------------------------------
zbrewmount -m -s ZHW110 2>$err
rc1=$?
assert 0 $rc1
zbrewtest "mount ZHW110 at source" "0" "$rc1"
zbrewmount -u -s ZHW110 2>$err
rc2=$?
assert 0 $rc2
zbrewtest "unmount ZHW110 at source" "0" "$rc2"

#test2: trying to mount target which ZFS DS does not exist yet
#-------------------------------------------------
zbrewmount -m -t ZHW110 2>$err
rc3=$?
assert 2 $rc3
zbrewtest "mount ZHW110 at target" "2" "$rc3"

#test3: now should be valid
#-------------------------------------------------
crtzfs ${ZBREW_TGT_HLQ}ZHW110.SZHWHFS
crtzfs ${ZBREW_TGT_HLQ}ZHW110.SZHWHFS2

zbrewmount -m -t ZHW110 2>$err
rc4=$?
assert 0 $rc4
zbrewtest "mount ZHW110 at target" "0" "$rc4"
zbrewmount -u -t ZHW110 2>$err
rc5=$?
assert 0 $rc5
zbrewtest "unmount ZHW110 at target" "0" "$rc5"

#cleanup
cleanup

exit 0