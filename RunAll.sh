#! /bin/bash

START=$(date +%s)
BASE_DIR=`cd ../ && pwd`
SCRIPT_DIR=$BASE_DIR/scripts
$SCRIPT_DIR/ClearAll.sh > /dev/null
$SCRIPT_DIR/GenerateInfo.sh 2> $BASE_DIR/gen_info_error.log 1> $BASE_DIR/gen_info_right.log
$SCRIPT_DIR/MergeInfo.sh 2> $BASE_DIR/merge_info_error.log 1> $BASE_DIR/merge_info_right.log
$SCRIPT_DIR/Compare.sh > $BASE_DIR/compare_info.log 2>&1

END=$(date +%s)
time=$((END-START))
time=`expr $time / 1`
echo "cost $time s"
