#!/bin/sh
. zbrewsetenv 

zbrewdeploy $1 zbrew.bom
exit $? 
