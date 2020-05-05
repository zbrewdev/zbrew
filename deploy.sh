#!/bin/sh
. zbrewsetenv 

zbrewdeploy "$1" zbrewbin.bom
exit $? 
