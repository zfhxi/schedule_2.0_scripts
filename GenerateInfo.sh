#! /bin/bash

# 目录变量
BASE_DIR=`cd ../ && pwd`
export SCRIPT_DIR=$BASE_DIR/scripts
export EXEC_DIR=$BASE_DIR/versions.alt/versions.orig
export OUTPUT_DIR=$BASE_DIR/outputs
export TEST_DIR=$BASE_DIR/test
MAKE_LOG=$BASE_DIR/make_process.log

# 如果不存在文件件，创建
function make_dir(){
    if [ ! -d $1 ];then
        mkdir -p $1
        return 0
    else
        return 1
    fi
}
export -f make_dir

# 拷贝正确版本，并命名为v0
if [ ! -f $EXEC_DIR/v0/schedule.c ];then
    make_dir $EXEC_DIR/v0
    cp $BASE_DIR/source.alt/source.orig/schedule.c $EXEC_DIR/v0/
fi

# 重命名runall.sh
if [ -f $SCRIPT_DIR/runall.sh ];then
    make_dir $SCRIPT_DIR/dat
    mv $SCRIPT_DIR/runall.sh $SCRIPT_DIR/dat/all_cases.dat
    mv $SCRIPT_DIR/gettraces.sh $SCRIPT_DIR/dat/
fi

# 编译产生各版本的可执行文件
cd $SCRIPT_DIR && make >> $MAKE_LOG 2>&1

# 参照 https://stackoverflow.com/questions/22009364/is-there-a-try-catch-command-in-bash 的try、catch
function try()
{
    [[ $- = *e* ]]; SAVED_OPT_E=$?
    set +e
}
export -f try
function catch()
{
    export ex_code=$?
    (( $SAVED_OPT_E )) && set +e
    return $ex_code
}
export -f catch

function generate_infofile(){
    ver_no=$1
    VER_EXEC_DIR=$EXEC_DIR/$ver_no
    # 创建必要的文件夹
    make_dir $VER_EXEC_DIR
    make_dir $OUTPUT_DIR/$ver_no
    make_dir $TEST_DIR/info/$ver_no
    for t_no in t{1..2650}
    do
        make_dir $TEST_DIR/gcov/$ver_no/$t_no
    done
    #遍历用例
    perl $SCRIPT_DIR/pl/get_input_args.pl $ver_no | while read cmd_line || [[ -n $cmd_line ]]
    do
        # Perl-one-liner提取用例编号
        test_case_no=`echo $cmd_line | perl -lne '/\/(t[0-9]+)$/ && print $1'`
        # 生成 .gcda 文件
        try
        (
            eval $cmd_line
        )
        catch || {
            # 产生段错误
            if [ $ex_code == 139 ];then
                echo "SIGSEGV" > $OUTPUT_DIR/$ver_no/$test_case_no
                continue
            fi
        }
        src_file=$VER_EXEC_DIR/schedule.c
        # 生成 .c.gcov 文件
        cd $VER_EXEC_DIR && gcov $src_file
        # 生成 .info 文件
        lcov -b $VER_EXEC_DIR -d $VER_EXEC_DIR -c -o $TEST_DIR/info/$ver_no/$test_case_no.info --rc lcov_branch_coverage=1
        # 删除gcda 文件，防止累积
        rm $VER_EXEC_DIR/schedule.gcda
        # 保留.gcov文件
        mv $src_file.gcov $TEST_DIR/gcov/$ver_no/$test_case_no/
    done
}
export -f generate_infofile

# 在不同版本上并发运行2560个测试用例
for vern in v{0..9}
do
    echo $vern
done | parallel generate_infofile
