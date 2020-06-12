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
    drm -f "${ZBREW_SRC_HLQ}$swname*.**"
    drm -f "${ZBREW_TGT_HLQ}$swname*.**"
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

export ZBREW_SRC_HLQ=ZBREWMS.
export ZBREW_SRC_ZFSROOT=/zbrew/mts/
export ZBREW_TGT_HLQ=ZBREWMT.
export ZBREW_TGT_ZFSROOT=/zbrew/mtt/

unset swname hfs1 hfs2
swname=ZHW110
hfs1=SZHWHFS
hfs2=SZHWHFS2

err="${ZBREW_TMP}/err.out"
cleanup

crtzfs ${ZBREW_SRC_HLQ}$swname.$hfs1
crtzfs ${ZBREW_SRC_HLQ}$swname.$hfs2
touch "${err}"

#test1: a valid case
#-------------------------------------------------
zbrewmount -m -s $swname 2>$err
rc1=$?
assert 0 $rc1
zbrewtest "mount $swname at source" "0" "$rc1"
zbrewmount -u -s $swname 2>$err
rc2=$?
assert 0 $rc2
zbrewtest "unmount $swname at source" "0" "$rc2"

#test2: trying to mount target which ZFS DS does not exist yet
#-------------------------------------------------
zbrewmount -m -t $swname 2>$err
rc3=$?
assert 2 $rc3
zbrewtest "mount $swname at target" "2" "$rc3"

#test3: now should be valid
#-------------------------------------------------
crtzfs ${ZBREW_TGT_HLQ}$swname.$hfs1
crtzfs ${ZBREW_TGT_HLQ}$swname.$hfs2

zbrewmount -m -t $swname 2>$err
rc4=$?
assert 0 $rc4
zbrewtest "mount $swname at target" "0" "$rc4"
zbrewmount -u -t $swname 2>$err
rc5=$?
assert 0 $rc5
zbrewtest "unmount $swname at target" "0" "$rc5"

#cleanup
cleanup

exit 0