#! /bin/bash
# 目录变量
BASE_DIR=`cd ../ && pwd`
export TEST_DIR=$BASE_DIR/test
export HTML_PATH=$TEST_DIR/html
# 如果不存在文件件，创建

function make_dir(){
    if [ ! -d $1 ];then
        mkdir -p $1
    fi
}

export -f make_dir

function merge_infofile_by_version(){
    info_files=""
    for info_file in `ls $TEST_DIR/info/$1/*.info`
    do
        info_files="$info_files -a $info_file"
    done
    make_dir $HTML_PATH/$1
    lcov $info_files -o $HTML_PATH/$1/info_all.info
    # well, you may need to  specify --rc lcov_branch_coverage=1 in your ~/.lcovrc or /etc/locvrc
    genhtml -o $HTML_PATH/$1 $HTML_PATH/$1/info_all.info --rc genhtml_branch_coverage=1
}

export -f merge_infofile_by_version

for ver_no in {0..9}
do
    echo v$ver_no
done | parallel merge_infofile_by_version