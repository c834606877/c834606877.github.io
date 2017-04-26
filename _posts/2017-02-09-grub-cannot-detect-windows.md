---
layout: post
title: grub-mkconfig 没有Windows项

categories:
- Linux系统
- 应用技巧
tags: [grub，os-prober, windows]

author:
  login: lanbing
  email: c834606877@163.com
---


不知道什么时候开始,我的<code>grub2-mkconfig</code>

找不到Windows的启动项了,
说严重也不严重,但小问题堆起来也会成为大问题的
于是乎,追根溯源,
Windows 项原本是在<code>/etc/grub.d/30_os-prober</code>生成

查看其代码,发现使用了<code>os-prober</code>寻找其他系统.
运行发现没有输出,可以确定是这个东西在抽风了

回头一想,之前由于部分主板EFI记动的时候,会检测是否存在<code>/EFI/Microsoft/Boot/bootmfgw.efi</code>,如果存在的话,会直接启动他,所以将其改名了.
将其改回再测试,os-prober可心正常找到Windows项了

于是乎,<code>os-prober</code>要改的话基本没戏,还是写脚本吧,

<pre> vi /etc/grub.d/40_custom</pre>
直接将启动项加入就行了.


关于 grub 请详见[官方文档](https://www.gnu.org/software/grub/manual/grub.html#)!
