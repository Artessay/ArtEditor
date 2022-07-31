# Mini Editor 用户手册

## 基本介绍

Mini Editor是一款在命令行对文本进行轻松便捷地编辑的命令行编辑器，能够帮助您在命令行模式下启动文本编辑器对文本文档进行快速而有效的编辑。Mini Editor采用shell编程开发，不依赖其他任何现有的编辑器，您能够在只具备bash的情况下使用Mini Editor进行文本的阅读与编辑。与其他命令行编辑器相比，Mini Editor具有程序精简，功能齐全，高效易用，内存占用率低等特点，能够应用于众多特殊的应用场景。

## 环境配置

### 准备Linux类操作系统

* Linux用户：如果您使用的是Linux操作系统，那么您可以直接运行Mini Editor，理论上Mini Editor可以与任何版本的Linux操作系统兼容。如果您遇到了任何问题，欢迎及时与我们联系。
* Windows用户：如果您使用的是Windows操作系统，您可能需要通过安装WSL或者虚拟机才能支持Mini Editor的运行。WSL是由微软开发的适用于 Linux 的 Windows 子系统，目前支持Windows 10及以上版本的操作系统。关于WSL的使用可以参考官方的说明文档：https://docs.microsoft.com/zh-cn/windows/wsl/
* 其他操作系统用户：目前，Mini Editor仅支持在安装有bash命令行解释器的环境中运行。我们暂时还没有在Linux和Windows以外的操作系统中进行测试。如果您有任何好的想法或者意见可以与我们反馈。

### 添加环境变量（推荐）

如果您希望能够在系统中的任何地方方便的调用Mini Editor应用程序的话，那么我们非常建议您将Mini Editor程序所在目录添加到系统环境变量之中，这样可以使您使用Mini Editor更加方便。在Linux操作系统下，添加环境变量有如下几种方法：

1. **临时添加路径到目前的PATH**

   如果您只是想要临时修改环境变量体验一下的话，您可以采用这种方式添加环境变量。添加的方法为直接在命令行中输入 `PATH=<Mini Editor所在目录>:$PaTH` 即可。比如，如果您的Mini Editor程序是下载在/home/MiniEditor/ 目录下，那么您可以通过输入以下命令添加：

   ~~~bash
   PATH=/home/MiniEditor:$PATH
   ~~~

   需要注意的是，使用这种方法改变的环境变量只对当前会话有效。每当您登出或注销系统以后，PATH 设置就会失效。

2. **添加全局变量在/etc/profile文件中**
   使用管理员权限打开/etc/profile文件并在其中添加如下语句：

   ~~~bash
   export PATH="/home/MiniEditor:$PATH"
   ~~~


   这种方法可以使得该操作系统上所有用户的环境变量中都加入Mini Editor的环境变量，但需要您拥有管理员权限才可编辑。

3. **为当前用户永久修改PATH**
   打开当前用户主目录下的配置文件，比如在Ubuntu 22.04版本里的配置文件为~/.profile。修改其中的PATH行，将Mini Editor所在目录以类型的方式添加，便可以为当前用户永久修改环境路径.

## 使用方法

### 启动Mini Editor

​		在系统提示符号下输入minieditor.sh及文件名称后，Mini Editor便会打开相应的文件并进入Mini Editor全屏幕编辑画面。如果该文件不存在则会先自动创建一个空白的临时文件，保存后可以看到新创建的文本文件。例如下面这个例子：

~~~bash
$ ./minieditor.sh file
~~~

​		其中，\$为系统提示命令符，minieditor.sh的可执行程序位于当前目录下，file为您要编辑的文本文档的文件名称。如果minieditor.sh的可执行程序不在当前目录下的话，您需要改变该程序的引用目录。如果您已经将minieditor.sh文件所在路径添加到PATH的环境变量之中，那么您也可以直接输入`minieditor.sh file`正常运行使用Mini Editor。

​		这里有一点需要特别注意，就是您进入Mini Editor之后，首先将处于命令模式，您要切换到插入模式之后才能够输入文字。

**b) 切换至插入模式编辑文件**

​		在命令模式下按一下字母 i 或 I 就可以进入插入模式，这时候你就可以以插入的方式开始输入文字了。

**c) 从插入模式切换至命令模式**
		处于插入模式时只能一直输入文字，此时您输入的任何内容都会作为文本直接添加到文档之中。除非当您按下ESC键后可退出插入模式并转到命令模式。

### 底行模式介绍

​		在命令模式下，按下冒号键之后可以进入底行模式。在底行模式中，您可以输入相应的命令完成相关操作。底行模式中设计的操作主要与**文件的保存与退出**有关，目前，Mini Editor支持的底行模式命令如下：

| 命令 | 解释                      |
| ---- | ------------------------- |
| :w   | 保存当前文件              |
| :wq  | 保存并退出Mini Editor     |
| :q   | 退出Mini Editor           |
| :q!  | 不存盘强制退出Mini Editor |
| :x   | 相当于 :wq 的功能         |

​		这里有一点需要注意的是，当您输入`:q`命令想要退出Mini Editor时，您应该确保您所有的编辑均已经进行了保存。否则Mini Editor会提示您“文件尚未保存，无法退出”。如果您在发生编辑后想要退出Mini Editor，您应该使用`:wq`或`:x`命令保存最新的编辑成果并退出，或者使用 `:q!`不保存文档强制退出编辑器。



命令模式操作
1）. 插入模式
按 i 切换进入插入模式后，是从光标当前位置开始输入文件；
按 a 进入插入模式后，是从光标所在位置的下一个位置开始输入文字；
按 o 进入插入模式后，是插入新的一行，从行首开始输入文字。
2）. 从插入模式切换为命令行模式
按 ESC 键。
3）. 移动光标
vi可以直接用键盘上的光标来上下左右移动，但正规的vi是用小写英文字母 h 、 j 、 k 、 l ，分别控制光标左、下、上、右移一格。
按 Ctrl+b ：屏幕往后移动一页。
按 Ctrl+f ：屏幕往前移动一页。
按 Ctrl+u ：屏幕往后移动半页。
按 Ctrl+d ：屏幕往前移动半页。
按数字 0 ：移到当前行的开头。
按 G ：移动到文章的最后。
按 $ ：移动到光标所在行的行尾。
按 ^ ：移动到光标所在行的行首。
按 w ：光标跳到下个字的开头。
按 e ：光标跳到下个字的字尾。
按 b ：光标回到上个字的开头。
按 #l ：光标往后移的第#个位置，如：5l,56l .
4）. 删除文字
x ：每按一次，删除光标所在位置的后面一个字符。
#x ：删除光标所在位置的后面#个字符，例如， 6x 表示删除光标所在位置的后面6个字符。
X ：每按一次，删除光标所在位置的前面一个字符。
#X ：删除光标所在位置的前面#个字符，例如， 20X 表示删除光标所在位置的前面20个字符。
dd ：删除光标所在行。
#dd ：从光标所在行开始删除#行。
5）. 复制
yw ：将光标所在之处到字尾的字符复制到缓冲区中。
#yw ：复制#个字到缓冲区。
yy ：复制光标所在行到缓冲区。
#yy ：复制从光标所在行往下#行文字，例如， 6yy 表示复制从光标所在行往下6行文字。
p ：将缓冲区内的字符贴到光标所在位置。
注意：所有与 y 有关的复制命令都必须与 p 配合才能完成复制与粘贴功能。
6）. 替换
r ：替换光标所在处的字符。
R ：替换光标所到之处的字符，直到按下 ESC 键为止。
7）. 回复上一次操作
u ：如果您误执行一个命令，可以马上按下 u ，回到上一个操作。按多次 u 可以执行多次恢复。
8）. 更改
cw ：更改光标所在处的字到字尾处
#cw ：例如，「3cw」表示更改3个字
9）. 跳至指定的行
Ctrl+g 列出光标所在行的行号。
#G ：移动光标至文件的第#行行首，例如， 15G 表示移动光标至文件的第15行行首。
底行模式操作
在使用底行模式之前，请记住先按 ESC 键确定您已经处于命令行模式下后，再按冒号 : 即可进入底行模式。
A) 列出行号
set nu ：在文件中的每一行前面列出行号。
B) 跳到文件中的某一行
\# ： \# 号表示一个数字，在冒号后输入一个数字，再按回车键就会跳到该行了，如输入数字15，再回车，就会跳到文章的第15行。
C) 查找字符
/关键字 ：先按 / 键，再输入您想寻找的字符，可以按 n 寻找下一个关键字。
?关键字 ：先按 ? 键，再输入您想寻找的字符，可以按 n 寻找上一个关键字。

为了让我们的提示信息等更加丰富且便于用户阅读，我为我的命令行编辑器的提示信息添加了丰富多彩的颜色。在shell中，可以使用 ANSI 颜色编码来指定输出的颜色，例如，下面列出了一些常见的颜色编码：

30 (黑色), 31 (红色), 32 (绿色), 33 (黄色), 34 (蓝色), 35 (洋红), 36 (青色), 37 (白色).



进入Mini Editor的主界面之后，我们可以开到整个界面的基本样式与人们常用的编辑器样式差不多。在界面上方显示的是打开的等待编辑或查看的文档。在界面的最后一行会显示当前Mini Editor所处在的模式，Mini Editor中光标所在的行号与列号。如果用户在使用过程中有发生了一些错误，比如输入了不存在的命令或未保存文档就想要退出等，则还会在界面下方显示相应的错误信息。Mini Editor打开后默认进入的是命令模式。

## 联系我们

本项目由浙江大学学生邱日宏独立开发完成。如果您在使用过程中遇到了任何问题，或是对我们的项目有任何好的建议，您可以通过邮箱3200105842@zju.edu.cn与我们联系，非常感谢您对项目的支持与建议！
