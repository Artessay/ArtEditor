# 程序：命令行编辑器
# 作者：邱日宏 3200105842
# 日期：2022年7月

HelpDoc()
{
    echo "
Mini Editor (2022 July)

Usage: minieditor.sh [arguments] [file ..]       edit specified file(s)
   or: minieditor.sh [arguments] -               read text from stdin

Arguments:
   --                   Only file names after this
   -v                   Vi mode (like "vi")
   -e                   Ex mode (like "ex")
   -E                   Improved Ex mode
   -s                   Silent (batch) mode (only for "ex")
   -d                   Diff mode (like "minieditordiff")
   -y                   Easy mode (like "eminieditor", modeless)
   -R                   Readonly mode (like "view")
   -Z                   Restricted mode (like "rminieditor")
   -m                   Modifications (writing files) not allowed
   -M                   Modifications in text not allowed
   -b                   Binary mode
   -l                   Lisp mode
   -C                   Compatible with Vi: 'compatible'
   -N                   Not fully Vi compatible: 'nocompatible'
   -V[N][fname]         Be verbose [level N] [log messages to fname]
   -D                   Debugging mode
   -n                   No swap file, use memory only
   -r                   List swap files and exit
   -r (with file name)  Recover crashed session
   -L                   Same as -r
   -A                   Start in Arabic mode
   -H                   Start in Hebrew mode
   -T <terminal>        Set terminal type to <terminal>
   --not-a-term         Skip warning for input/output not being a terminal
   --ttyfail            Exit if input or output is not a terminal
   -u <minieditorrc>    Use <minieditorrc> instead of any .minieditorrc
   --noplugin           Don't load plugin scripts
   -p[N]                Open N tab pages (default: one for each file)
   -o[N]                Open N windows (default: one for each file)
   -O[N]                Like -o but split vertically
   +                    Start at end of file
   +<lnum>              Start at line <lnum>
   --cmd <command>      Execute <command> before loading any minieditorrc file
   -c <command>         Execute <command> after loading the first file
   -S <session>         Source file <session> after loading the first file
   -s <scriptin>        Read Normal mode commands from file <scriptin>
   -w <scriptout>       Append all typed commands to file <scriptout>
   -W <scriptout>       Write all typed commands to file <scriptout>
   -x                   Edit encrypted files
   --startuptime <file> Write startup timing messages to <file>
   -i <minieditorinfo>  Use <minieditorinfo> instead of .minieditorinfo
   --clean              'nocompatible', minieditor defaults, no plugins, no minieditorinfo
   -h  or  --help       Print Help (this message) and exit
   --version            Print version information and exit

Additional Remarks:
    Not all of the arguments are supported by Mini Editor now.
"
}

# 命令行编辑器参数初始化
InitEditor()
{
    # 状态模式
    state="Command"     # 设定当前初始状态，为command mode

    # 标记是否修改过
    modified="false"

    # 刷新文本标记
    refresh="true"

    # 行号与列号，默认从1开始
    let row=1       # 行号为1
    let col=1       # 列号为1
}

# 启动命令行编辑器
StartEditor()
{
    # echo $# $1    # 调试信息

    # 参数合法性判断
    # if [[ ($# -ge 2) ]] # 目前Mini Editor暂时仅支持一次编辑一个文件
    #     then    # 如果参数的个数超过2个
    #         echo -e "\033[31m[ERROR]\033[0m\t无效的参数，目前Mini Editor暂时仅支持一次编辑一个文件
    #     请输入'minieditor.sh --help'获取更多信息" # 提示无效参数输入
    #         exit 1  # 退出程序
    # fi

    if [[ ($# -eq 0) || ($# == 1 && $1 == "--help") ]]
        then            # 如果用户没有输入任何参数或是输入了--help
            HelpDoc     # 那么就显示帮助文档
            exit 0
    fi

    # 参数处理
    file=${!#}          # 获取需要编辑的文件
    efile=${file}_edit  # 设置临时文件
    while [ -e $efile ]   # 如果临时文件恰好重名
    do
        efile=${efile}_edit   # 则反复添加_edit后缀确保没有同名文件
    done
    # echo $efile       # 调试信息

    
    if [ -e $file ]         # 判断文件是否存在
        then                # 如果原文件已存在
            if [ ! -r $file -o ! -w $file ]  # 判断用户的读写权限
                then
                    echo -e "\033[31m[ERROR]\033[0m\t 你不具有 $file 的读写权限，无法打开文档"
                    exit 1
            fi

            if [ ! -f $file ]   # 判断文件类型
                then
                    echo -e "\033[31m[ERROR]\033[0m\t $file 不是普通文件，无法打开文档"
                    exit 1
            fi
            
            cp $file $efile     # 拷贝临时文档准备编辑

        else                # 如果原文件不存在
            touch $efile        # 创建临时文档准备编辑
    fi
    
    InitEditor
}

# 退出命令行编辑器
EndEditor()
{
    # 退出时删除编辑使用的临时文件
    rm $efile
    # echo "Bye~"
}

Render()
{
    # 参数检查
    if [[ ($# != 1) || (! -f $1) ]]
        then
            echo "Render 参数错误"
            return 1
    fi

    # 清屏      但是清屏还是太慢了一点
    if [[ $refresh == "true" ]]
        then    # 仅当刷新时清屏
            tput clear     # 清除屏幕
    fi

    tput civis          # 暂时隐藏光标

    # 初始化变量
    render_file=$1             # 内容暂存文件
    let LineCount=1     # 行号统计，默认从1开始
    rows=$(tput lines)  # 当前屏幕行数
    cols=$(tput cols)   # 当前屏幕列数

    # 底行打印提示信息
    tput cup $((rows-1)) 0    # 定位屏幕最后一行
    tput el
    printf "== $state Mode ==\t      row: $row  col: $col        $ErrorMessage"
    ErrorMessage=""

    # 循环显示文本
    tput cup 0 0        # 定位屏幕顶行
    if [[ $refresh == "true" ]]
        then            # 只有插入模式下发生修改了才需要刷新文本
            # cat $render_file | while read line
            # do
            #     echo $line  # 为了提升打印的速度，暂时取消行号显示功能
            #     # printf "\033[35mLine%3d\033[0m: $line\n" $LineCount
            #     # (( LineCount = LineCount + 1 ))
            # done
            cat $render_file

            refresh="false" # 恢复刷新标记
    fi

    tput cup $((row-1)) $((col-1))        # 重新将光标移到原来的位置
    tput cnorm                            # 重新显示光标
    return 0
}

# 运行状态
FiniteStateMachine()
{
    # 创建新屏幕
    tput smcup          # 进入备用屏幕
    echo -e '\E7'       # 保存当前光标的位置
    echo -e '\033[?47h' # 切换到备用屏幕

    # 定义Internal Field Separator，区别回车，空格与制表符
    IFS=

    # 无限循环
    while :
    do
        Render $efile

        case "$state" in
            Command)    # 命令模式
                # echo "Command Mode"

                stty -echo      # 关闭命令回显
                read -s -n1 op  # 读入控制字符

                case $op in
                    :)
                        state="LastLine"
                        ;;
                    [iI] | [aA] | [oO])    # 插入模式
                        if [[ $op == [aA] ]]    # 追加则为从光标后一个字符开始插入
                            then
                                ((col = col + 1))
                        fi

                        if [[ $op == [oO] ]]    # 打开则为将光标移动到末尾的插入
                            then
                                total_line=$(cat $efile | wc -l)    # 原文件总行数
                                echo >> $efile      # 追加一行新行
                                row=$((total_line + 1)) # 移动光标
                                col=1                   # 移动光标
                        fi

                        state="Insert"
                        ;;
                    [rR])           # 替换模式
                        state="Replace"
                        ;;
                    [kK])   # 向上移动
                        row=$((row>1?row-1:1))
                        ;;
                    [jJ])   # 向下移动
                        row=$((row<(rows-2)?row+1:rows-2))
                        ;;
                    [hH])   # 向左移动
                        col=$((col>1?col-1:1))
                        ;;
                    [lL])   # 向右移动
                        col=$((col<(cols-1)?col+1:cols-1))
                        ;;
                    *)
                        state="Command"
                        ;;
                esac
                ;;

            Insert)     # 插入模式
                # echo "Insert Mode"

                modified="true"     # 标记发生了修改
                refresh="true"      # 标记刷新

                stty echo           # 打开命令回显
                read -n1 character
                if [[ $character == $'\e' ]]    # 如果输入的是ESC键
                    then
                        state="Command"     # 跳转到命令模式
                        continue            # 继续
                fi
                
                # 文本更新
                tmp=$(mktemp miniedit.XXXX)
                LineCount=0
                while read line
                do
                    (( LineCount = LineCount + 1 )) # 行号++

                    if [[ $row != $LineCount ]]
                        then 
                            echo $line >> $tmp  # 正常情况下为普通复制
                        else
                            # 插入新行
                            ((col = col - 1))   # 在当前光标前插入字符

                            if [[ $(printf "%d" \'$op) == 127 ]]    # 退格键特殊处理
                                then    # 如果输入的是退格键
                                    new_line=${line:0:$((col-1))}{line:$col}        # 则删除前一个字符
                                else    # 如果输入的不是退格键

                                    if [[ $character == '' ]]    # 回车键特殊处理
                                        then    # 行号和列号需要重定位
                                            new_line=${line:0:$col} # 记录光标前的内容
                                            echo $new_line >> $tmp  # 输出
                                            new_line=${line:$col}   # 光标后的内容另起一行
                                            # ((row = row + 1))   # 行号加1
                                            # ((col = 1))         # 列号为1
                                        else

                                            new_line=${line:0:$col}$character${line:$col}   # 则正常输入
                                            ((col = col + 2))   # 插入字符后光标右移
                                    fi
                                    
                            fi
                                                        
                            echo $new_line >> $tmp
                    fi
                done < $efile   # 重定向

                mv $tmp $efile  # 消除临时文件并更新文件
                ;;

            Replace)     # 替换模式
                # echo "Replace Mode"

                modified="true"     # 标记发生了修改
                refresh="true"      # 标记刷新

                stty echo           # 打开命令回显
                read -n1 character
                if [[ $character == $'\e' ]]    # 如果输入的是ESC键
                    then
                        state="Command"     # 跳转到命令模式
                        continue            # 继续
                fi
                
                # 文本更新
                tmp=$(mktemp miniedit.XXXX)
                LineCount=1     # 行号匹配
                while read line
                do
                    if [[ $row != $LineCount ]]
                        then 
                            echo $line >> $tmp  # 正常情况下为普通复制
                        else
                            # 插入新行
                            new_line=${line:0:$((col-1))}$character${line:$col}
                            col=$((col + 1))   # 插入字符后光标右移
                            echo $new_line >> $tmp  # 对于也要替换部分更新
                            
                            if [[ $character == '' ]]    # 回车键特殊处理
                                then    # 行号和列号需要重定位
                                    ((row = row + 1))   # 行号加1
                                    ((col = 1))         # 列号为1
                            fi
                    fi
                    (( LineCount = LineCount + 1 )) # 行号++
                done < $efile   # 重定向
                mv $tmp $efile  # 消除临时文件并更新文件
                ;;

            LastLine)   # 底行模式
                # echo "Last Line Mode"

                # 显示底行的：提示输入底行命令
                tput cup $((rows-1)) 0
                tput el
                stty echo           # 打开命令回显
                read -p ":" lastop

                # 清楚输入的底行命令
                tput cup $((rows-2)) 0
                tput el

                # 根据命令进行决策
                case $lastop in
                    w)      # 保存当前文件
                        cp -f $efile $file  # 用修改文件覆盖原文件
                        state="Command"     # 回到命令模式
                        modified="false"    # 修改状态恢复
                        ;;

                    wq | x) # 保存并退出Mini Editor
                        cp -f $efile $file  # 用修改文件覆盖原文件
                        break               # 退出
                        ;;

                    q)      # 退出Mini Editor
                        if [[ $modified == "true" ]]
                            then
                                ErrorMessage="\033[31m[ERROR]\033[0m\t文件尚未保存，无法退出"
                                state="Command"     # 回到命令模式
                            else
                                break       # 退出
                        fi
                        ;;

                    q!)     # 不存盘强制退出Mini Editor
                        break
                        ;;
                    *)
                        ErrorMessage="\033[31m[ERROR]\033[0m\t无法识别的命令"
                        state="Command"     # 回到命令模式
                        ;;
                esac
                ;;
            *)
                # 其他情况则为模式错误
                ErrorMessage="\033[31m[ERROR]\033[0m\tUnrecognized Mode"
                break
                ;;
        esac

    done

    echo -e '\E[2J'     # 清除屏幕
    echo -e '\033[?47l' # 切换回正常屏幕
    echo -e '\E8'       # 恢复光标位置
    tput rmcup          # 退出备用屏幕
}

StartEditor $@

FiniteStateMachine

EndEditor