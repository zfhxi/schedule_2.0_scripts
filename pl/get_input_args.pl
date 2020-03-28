#! /usr/bin/perl

open(in,"<dat/all_cases.dat");
$exec_f="../source/schedule.exe";
$input_d="../inputs/input";
$output_d="../outputs";
$INPUT_DIR="/home/julian/Projects/SoftWareTest/schedule/inputs/input";
$OUTPUT_DIR="/home/julian/Projects/SoftWareTest/schedule/outputs";
$EXEC_FILE="/home/julian/Projects/SoftWareTest/schedule/versions.alt/versions.orig/".$ARGV[0]."/schedule.exe";

# $line my be like:
#
# ../source/schedule.exe 2 3 5  < ../inputs/input/inp.46 > ../outputs/t2
while($line=<in>){
    chomp($line);
    if($line=~/^\.\.\/source\/schedule.exe/){
        $line=~s/$exec_f/$EXEC_FILE/g; #替换可执行程序
        $line=~s/$input_d/$INPUT_DIR/g; #替换输入路径
        $line=~s/$output_d/$OUTPUT_DIR\/$ARGV[0]/g; #替换输出路径
        print $line."\n";
    }
}
close(in)