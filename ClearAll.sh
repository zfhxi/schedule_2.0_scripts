#! /bin/bash

# 目录变量
BASE_DIR=`cd ../ && pwd`
EXEC_DIR=$BASE_DIR/versions.alt/versions.orig
OUTPUT_DIR=$BASE_DIR/outputs
TEST_DIR=$BASE_DIR/test
# 如果不存在文件件，创建
function make_dir(){
    if [ ! -d $1 ];then
        mkdir -p $1
    fi
}

# 拷贝正确版本，并命名为v0
if [ ! -f $EXEC_DIR/v0/schedule.c ];then
    make_dir $EXEC_DIR/v0
    cp $BASE_DIR/source.alt/source.orig/schedule.c $EXEC_DIR/v0/
fi

# 清除目录
make_dir $OUTPUT_DIR
rm -rf $OUTPUT_DIR/*
rm -rf $TEST_DIR/*
# 清除日志
rm -rf $BASE_DIR/*.log
rm -rf $BASE_DIR/*.xls

make clean
