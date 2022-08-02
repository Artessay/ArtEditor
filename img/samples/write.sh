#!/bin/bash

# 备用屏幕

# \033 表示八进制下的ASCII码33，对应ESC键 Escape

tput smcup          # 进入备用屏幕
echo -e '\E7'       # 保存光标的位置
echo -e '\033[?47h' # 切换到备用屏幕

# tput cnorm          # 设置光标可见

echo "morning"

tput cup 0 0
echo "$(tput cols)"
echo "$(tput lines)"

lines=$(tput lines)
tput cup $lines 0
echo "final"

# tput cup $($liens-1) 0
# echo "good"
 
tput cup 2 0
 
echo "aaaaaaaaaaaaa"
echo "aaaaaaaaaaaaa"
echo "aaaaaaaaaaaaa"
 
sleep 3
tput cup 7 10

# tput civis          # 设置光标不可见

tput smul           # 开始添加下划线
 
echo "dddddddddddddd"
echo "bbbbbbbbbbbbbb"

tput rmul           # 取消添加下划线

echo "cccccccccccccc"
 
sleep 3
 
echo -e '\E[2J'     # 清除屏幕
echo -e '\033[?47l' # 切换回正常屏幕
echo -e '\E8'       # 恢复光标位置
tput rmcup          # 退出备用屏幕

# smcup
# \E7 saves the cursor's position
# \E[?47h switches to the alternate screen
# rmcup
# \E[2J clears the screen (assumed to be the alternate screen)
# \E[?47l switches back to the normal screen
# \E8 restores the cursor's position.