open(in,"<../merge_info_right.log");
=pod
$var=<<"EOF";
Writing data to /home/julian/Projects/SoftWareTest/schedule/test/html/v4/info_all.info
Summary coverage rate:
  lines......: 98.8% (158 of 160 lines)
  functions..: 100.0% (18 of 18 functions)
  branches...: 95.5% (63 of 66 branches)
EOF
print $var."\n";
=cut
while($line=<in>){
    # 匹配到Writing data处
    if($line=~/^Writing\s+data\s+to\s+[\/a-zA-Z\s\_\.]+(v\d)/){
        $ver=$1;
        # 移动到覆盖信息处
        $line=<in>;
        if(($line=<in>)=~/\s+lines[\.:\s]+([\d\.%]+)/){
            $line_cov_rate=$1;
        }
        if(($line=<in>)=~/\s+functions[\.:\s]+([\d\.%]+)/){
            $fun_cov_rate=$1;
        }
        if(($line=<in>)=~/\s+branches[\.:\s]+([\d\.%]+)/){
            $branch_cov_rate=$1;
        }
        print $ver."\t".$line_cov_rate."\t".$fun_cov_rate."\t".$branch_cov_rate."\n";
    }
}
close(in);