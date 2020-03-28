### description

软件测试实验中用shell为西门子数据集的schedule_2.0编写的测试脚本


#### environment

ArchLinux (kernel 5.4)
gcc 9.3.0
perl

#### requirements

lcov 1.14 (生成可视化前端)
parallel (用于多线程)

#### file lists

* `pl`: Perl脚本文件夹
    * `get_input_args.pl`: 替换原runall.sh中的对应路径
    * `get_overall_coverage_info.pl`: 根据`merge_info_right.log`日志，解析得到各版本在所有用例下的覆盖信息
* `ClearAll.sh`: 清空脚本生成的一切文件
* `Compare.sh`: 比较各版本对应用例的输出结果
* `GenerateInfo.sh`: 用lcov生成覆盖信息的info文件，会新建test目录并生成*.gcov，*.info文件
* `MergeInfo.sh`: 用genhtml生成覆盖信息的可视化前端，会在test目录下生成html结果目录
* `RunAll`：执行上述的所有脚本

### to use

将scripts文件夹拷贝覆盖到schedule下的scripts，然后`./RunAll.sh`。

#### outputs
`gen_info_right.log`: 执行`GenerateInfo.sh`所产生的输出信息（不含报错信息）
`gen_info_error.log`: 执行`GenerateInfo.sh`所产生的的错误日志（例如：段错误）
`merge_info_righ.log`: 合并`GenerateInfo.sh`所产生的info文件时的输出信息
`merge_info_error.log`: 合并`GenerateInfo.sh`所产生的info文件时的错误日志
`compare_result.xls`: 执行`Compare.sh`产生的对比结果，各版本的各用例相对于正确版本的结果，如果与正确结果相同，则表格中对应为0，否则为1，并且计算各版本failure用例数以及百分占比。
