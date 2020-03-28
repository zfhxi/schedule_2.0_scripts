#! /bin/bash

# 目录变量
BASE_DIR=$(cd ../ && pwd)
OUTPUT_DIR=$BASE_DIR/outputs
COMPARE_RESULT=$BASE_DIR/compare_result.xls

cat /dev/null > $COMPARE_RESULT

# 打印表头
echo -e "case\\\ver\c" >> $COMPARE_RESULT
for v_no in v{1..9}
do
    echo -e "\t$v_no\c" >> $COMPARE_RESULT
done
echo "" >> $COMPARE_RESULT

# 打印每个用例各版本的正误，正确则为0，错误则为1
fail_cases=(0 0 0 0 0 0 0 0 0)
tmp_line=""
for t_no in t{1..2650}
do
    tmp_line=$t_no
    for no in {1..9}
    do
        delta=`diff $OUTPUT_DIR/v0/$t_no $OUTPUT_DIR/v$no/$t_no`
        # 如果输出结果位SIGSEV，那么是段错误，判定为错误的输出
        if [ $(cat $OUTPUT_DIR/v$no/$t_no| perl -lne 'print /SIGSEGV/ ? "1" : "0"') -eq 1 ];then
            ((fail_cases[$no-1]++))
            tmp_line=$tmp_line"\t1"
        # 如果不是段错误，却文件内容不同，那么是错误输出结果
        elif [ "$delta" != "" ]; then
            ((fail_cases[$no-1]++))
            tmp_line=$tmp_line"\t1"
        # 不是段错误，文件内容相同，正确的输出结果
        else
            tmp_line=$tmp_line"\t0"
        fi
    done
    echo -e $tmp_line >> $COMPARE_RESULT
    tmp_line=""
done
# 插入总失败用例数以及所占百分比
tmp_line="failures"
percents="percent"
for((i=0;i<9;i++));
do
    tmp_line=$tmp_line"\t"${fail_cases[$i]}
    pct=`awk 'BEGIN{printf "%.2f%%\n",('${fail_cases[$i]}'/'2650')*100}'`
    percents=$percents"\t"$pct
done
sed -i "2i$percents" $COMPARE_RESULT
sed -i "2i$tmp_line" $COMPARE_RESULT
