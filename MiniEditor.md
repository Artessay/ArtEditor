<div class="cover" style="page-break-after:always;font-family:方正公文仿宋;width:100%;height:100%;border:none;margin: 0 auto;text-align:center;">
    <div style="width:60%;margin: 0 auto;height:0;padding-bottom:10%;">
        </br>
        <img src="img/ZJU-name.svg" alt="校名" style="width:100%;"/>
    </div>
    </br></br></br></br></br>
    <div style="width:60%;margin: 0 auto;height:0;padding-bottom:40%;">
        <img src="img/ZJU-logo.svg" alt="校徽" style="width:100%;"/>
	</div>
    </br></br></br></br></br></br></br></br>
    <span style="font-family:华文黑体Bold;text-align:center;font-size:20pt;margin: 10pt auto;line-height:30pt;">Mini Editor 设计文档</span>
    </br>
    </br>
    <table style="border:none;text-align:center;width:72%;font-family:仿宋;font-size:14px; margin: 0 auto;">
    <tbody style="font-family:方正公文仿宋;font-size:12pt;">
    	<tr style="font-weight:normal;"> 
    		<td style="width:20%;text-align:right;">题　　目</td>
    		<td style="width:2%">：</td> 
    		<td style="width:40%;font-weight:normal;border-bottom: 1px solid;text-align:center;font-family:华文仿宋"> Mini Editor 设计文档 </td>     </tr>
    	<tr style="font-weight:normal;"> 
    		<td style="width:20%;text-align:right;">授课教师</td>
    		<td style="width:2%">：</td> 
    		<td style="width:40%;font-weight:normal;border-bottom: 1px solid;text-align:center;font-family:华文仿宋"> 季江民 </td>     </tr>
    	<tr style="font-weight:normal;"> 
    		<td style="width:20%;text-align:right;">姓　　名</td>
    		<td style="width:2%">：</td> 
    		<td style="width:40%;font-weight:normal;border-bottom: 1px solid;text-align:center;font-family:华文仿宋"> 邱日宏</td>     </tr>
    	<tr style="font-weight:normal;"> 
    		<td style="width:20%;text-align:right;">学　　号</td>
    		<td style="width:2%">：</td> 
    		<td style="width:40%;font-weight:normal;border-bottom: 1px solid;text-align:center;font-family:华文仿宋">3200105842 </td>     </tr>
    	<tr style="font-weight:normal;"> 
    		<td style="width:20%;text-align:right;">日　　期</td>
    		<td style="width:2%">：</td> 
    		<td style="width:40%;font-weight:normal;border-bottom: 1px solid;text-align:center;font-family:华文仿宋">2022年 7月</td>     </tr>
    </tbody>              
    </table>
</div>





## 摘要

​		命令行编辑器作为在命令行对文本进行轻松便捷地编辑的工具，为人们的生活带来了很大的便利。Mini Editor作为一款命令行编辑器，能够帮助用户在命令行模式下启动文本编辑器对文本文档进行快速而有效的编辑。在有限状态机的模型架构和模型-视图-控制器模式下，Mini Editor可以根据当前所处的状态以及用户输入进行状态转移以实现丰富的功能。与其他命令行编辑器相比，Mini Editor具有程序精简，功能齐全，高效易用等特点，能够应用于众多文本查看与编辑的场景。

## 设计思想

​		为了实现一个命令行编辑器程序，**有限状态机**的模型对于其实现将是一个不错的选择。有限状态机（Finite-State Machine，FSM）是表示有限个状态以及在这些状态之间的转移和动作等行为的数学计算模型。在编辑器里，如果我们能够将不同状态下编辑器所处的状态进行记录，并且在每一种状态下，用户可以采用不同的输入并发送相应的状态转移，那么，我们就可以实现编辑器中“命令模式”、“插入模式”、“底行模式”等多种不同模式之间的转移与变化。

​		在图形显示的处理上，我们采用了**模型-视图-控制器（MVC）模式**进行设计。在MVC的模式架构下，用户所看到的图形界面的显示与所要显示内容的控制分由不同的模块来完成。即使用户是在编辑模式下进行文本编辑时，用户所输入的文本也不是直接传输到屏幕上进行显示的，而是先经过控制器（controller）对用户输入的合法性等进行判断，确认用户的输入为合法输入且属于文本编辑范畴，然后将用户的输入送给临时存储的文本文件模型（model）并对该临时文本进行修改，最后显示模块（view）对该临时文本进行读取，并按要求渲染到屏幕之上，形成了用户所看到的文本内容。这样通过分离模型、视图、控制器的设计方法让用户的操作控制和显示都变得更为简单和容易，同时也能够让用户在各类模型之间进行自由的切换，而不必担心输入的控制字符作为文本被显示在了屏幕之上。

## 有限状态机控制模型

​		我们将命令行编辑器分为三种状态，分别是命令模式（command mode）、插入模式（Insert mode）和底行模式（last line mode）。各模式的功能简介及区分如下：

1) 命令模式（command mode）
    控制屏幕光标的移动，字符、字或行的删除，移动复制某区段及进入插入模式、底行模式。

2) 插入模式（Insert mode）
    用户只有在插入模式下才可以对文本进行编辑，按ESC键可回到命令模式。

3) 底行模式（last line mode）
    将文件保存或退出Mini Editor，如果未退出则回到命令模式。

​		关于有限状态机模型中各个模式更加详细的内容会在之后进行介绍，这里仅仅列出在Mini Editor设计过程中需要用到的三个模式以及它们内容的简介。下图中列出了Mini Editor的各个模式之间的关系以及它们之间相互转换的方法。

<img src="./img/state.jpg" style="zoom: 67%;" />



## 独立视图显示模块

​		作为一款文本编辑软件，如果单纯仅仅只是将文本在用户原来的终端窗口显示所能够带来的表现力是远远不能够满足我们的需求的。如果采用不断刷新输出文档在用户原来的终端窗口显示的话，不仅会使得用户原本的终端窗口显示快速刷屏收到污染让用户难以再找到编辑文档之前的相关终端输出，而且也不利于打印文档编辑器中相关信息的控制。

​		因此，在我们所设计的编辑器中采用了**独立视图显示**的方法

## 临时文件编辑存储



# 基本操作

**a) 进入Mini Editor**

​		在系统提示符号输入minieditor.sh及文件名称后，就进入Mini Editor全屏幕编辑画面。例如下面这个例子：

~~~bash
$ ./minieditor.sh file
~~~

​		其中，\$为系统提示命令符，minieditor.sh的可执行程序位于当前目录下，file为您要编辑的文本文档的文件名称。如果minieditor.sh的可执行程序不在当前目录下的话，您需要改变该程序的引用目录，或将minieditor.sh文件所在路径添加到PATH的环境变量之中，才可以正常运行使用Mini Editor。

​		这里有一点需要特别注意，就是您进入Mini Editor之后，是处于命令行模式，您要切换到插入模式才能够输入文字。

**b) 切换至插入模式编辑文件**

​		在命令模式下按一下字母 i 或 I 就可以进入插入模式，这时候你就可以以插入的方式开始输入文字了。

**c) 从插入模式切换至命令模式**
		处于插入模式时只能一直输入文字，此时您输入的任何内容都会作为文本直接添加到文档之中。除非当您按下ESC键后可退出插入模式并转到命令模式。

**d) 退出vi及保存文件**

​		在命令行模式下，按一下冒号键进入底行模式。在底行模式下，你可以输入相应的命令完成相关操作。目前，Mini Editor支持的命令如下：

| 命令 | 解释                      |
| ---- | ------------------------- |
| :w   | 保存当前文件              |
| :wq  | 保存并退出Mini Editor     |
| :q   | 退出Mini Editor           |
| :q!  | 不存盘强制退出Mini Editor |
| :x   | 相当于 :wq 的功能         |

​		这里有一点需要注意的是，当您输入:q命令想要退出Mini Editor时，您应该确保您所有的编辑均已经进行了保存。否则Mini Editor会提示您“文件尚未保存，无法退出”。如果您在发生编辑后想要退出Mini Editor，您应该使用:wq或:x命令保存最新的编辑成果并退出，或者使用 :q!不保存强制退出。



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