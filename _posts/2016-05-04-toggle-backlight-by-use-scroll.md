---
layout: post
title: 在Linux下 使用Scroll键开关键盘背光灯

categories:
- Linux系统
- MCU
tags: [机械键盘，背光，Scroll开关，]

author:
  login: lanbing
  email: c834606877@163.com
---



花了4天半的时间鼓捣好了一个机械键盘，

找了一个老外大牛写的stm32－based 键盘矩阵扫描器，改改装在了键盘上边

dfu功能，移植在keil下没有被识别，估计一阵子也没有多少时间来折腾，暂时先用着，

因为io口不够用，多区背光给改成了Scroll键开关，

但是，发现 Scroll 键 在高版本linux下给屏蔽了，

国内百度了半天没找到好的解决方案

转到google 发现
[Why is the Scroll Lock key disabled in Cinnamon/Linux/Xorg?](http://unix.stackexchange.com/questions/164245/why-is-the-scroll-lock-key-disabled-in-cinnamon-linux-xorg)
一文给出了详细的方法
<!--more-->
通过
<pre>xmodmap -pm</pre>
查看当前系统 mod键映射情况
<pre>[lanbing@LanBing-Laptop ~]$ xmodmap -pm
xmodmap:  up to 4 keys per modifier, (keycodes in parentheses):

shift       Shift_L (0x32),  Shift_R (0x3e)
lock        Caps_Lock (0x42)
control     Control_L (0x25),  Control_R (0x69)
mod1        Alt_L (0x40),  Alt_R (0x6c),  Meta_L (0xcd)
mod2        Num_Lock (0x4d)
mod3
mod4        Super_L (0x85),  Super_R (0x86),  Super_L (0xce),  Hyper_L (0xcf)
mod5        ISO_Level3_Shift (0x5c),  Mode_switch (0xcb)</pre>

其中mod3 这行是空的
通过这 条命令启用 Scroll Lock：
<pre>modmap -e "add mod3 = Scroll_Lock"</pre>

测试ok

<pre>[lanbing@LanBing-Laptop ~]$ xmodmap -pm
xmodmap:  up to 4 keys per modifier, (keycodes in parentheses):

shift       Shift_L (0x32),  Shift_R (0x3e)
lock        Caps_Lock (0x42)
control     Control_L (0x25),  Control_R (0x69)
mod1        Alt_L (0x40),  Alt_R (0x6c),  Meta_L (0xcd)
mod2        Num_Lock (0x4d)
mod3        Scroll_Lock (0x4e)
mod4        Super_L (0x85),  Super_R (0x86),  Super_L (0xce),  Hyper_L (0xcf)
mod5        ISO_Level3_Shift (0x5c),  Mode_switch (0xcb)
</pre>

让它每回开机都自动运行，
将这行放入~/.Xmodmap中

<pre>add mod3 = Scroll_Lock</pre>
或者
<pre>cd ~
echo >.Xmodmap "add mod3 = Scroll_Lock"</pre>
or
<pre>cd ~
echo >> .bashrc 'modmap -e "add mod3 = Scroll_Lock" '</pre>

这种方式在系统启动之后，会自动载入配置，

但是在重新插拔USB键盘后，系统会清空配置，需要手动重新载入

通过修改 <code>/usr/share/X11/xkb/symbols/us</code>文件

在 <code>xkb_symbols "basic" {</code>区段尾部添加如下：

<pre>modifier_map Mod3   { Scroll_Lock };</pre>


使配置永久生效。
