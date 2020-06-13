#!/bin/sh
#
# Basic test to ensure zbrew refresh of packages works
#
. zbrewsetenv
set -x

# Change ZBREW_REPOROOT to point to a test directory so as not to affect the 'real' repos
export ZBREW_REPOROOT="${ZBREW_TMP}/refreshtest"
rm -rf "$ZBREW_REPOROOT"
mkdir -p "$ZBREW_REPOROOT"

# First, refresh with no 'repo' directory. This should create a src repo because zbrew is source based

zbrew refresh zhw
rc=$?
zbrewtest "Failed to refresh zhw (src create)" "0" "$rc"

# Verify that the zbrew-zhw directory exists and that it has a .git directory inside it
zbrewtest "Did not find zbrew-zhw after refresh" "zbrew-zhw" `ls $ZBREW_REPOROOT`
zbrewtest "Did not find .git after refresh" "$ZBREW_REPOROOT/zbrew-zhw/.git" `ls -ad $ZBREW_REPOROOT/zbrew-zhw/.git`

# Next, refresh again. This should update the src repo because the src code is already there
out=`zbrew refresh zhw`
rc=$?
zbrewtest "Failed to refresh zhw (src update)" "0" "$rc"

echo "$out" | grep -q "Already up-to-date."
rc=$?

# Check the output and ensure it did a 'pull' and that no updates were found
zbrewtest "zbrew refresh (src update) failed. Full output: ${out}" "0" "$rc"

# Finally, 'pretend' to already have a binary repo by just creating the root directory and ensure it pulls from bintray

rm -rf "$ZBREW_REPOROOT/zbrew-zhw"
mkdir -p "$ZBREW_REPOROOT/zbrew-zhw"
zbrew refresh zhw 
rc=$?
zbrewtest "Failed to refresh zhw (bin create)" "0" "$rc"

# Verify that the zbrew-zhw directory exists and that it DOES NOT have a .git directory inside it
zbrewtest "Did not find zbrew-zhw after refresh" "zbrew-zhw" `ls $ZBREW_REPOROOT`

ls "$ZBREW_REPOROOT/zbrew-zhw/.git" >/dev/null 2>/dev/null
rc=$?
zbrewtest "Found .git after binary refresh" "1" "$rc"

rm -rf "$ZBREW_REPOROOT"
exit 0
