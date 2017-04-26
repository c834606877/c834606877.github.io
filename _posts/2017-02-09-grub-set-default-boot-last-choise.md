---
layout: post
title: 让 Grub2 记住上次选择的启动项

categories:
- Linux系统
- 系统技巧
tags: [Linux系统, Fedora]

author:
  login: lanbing
  email: c834606877@163.com
---


linux 下可以碰到各种各样的问题,今天解决了一部分,明天也许又会冒出一些新的问题,
但是,更重要的是,fix it and remenber it!

linux 使用配置文件进行管理,其中gurb 的配置文件有, <code>/etc/default/grub</code>和<code>/etc/grub.d/</code>

前者存储grub变量,后者为生成一个完整,grub.cfg配置的脚本,

此外,还有一个官方给的<code>/boot/grub2/grubenv</code>

<!--more-->
然而,在我的Fedora 24上 并没有<code>/etc/default/grub</code>手动创建也没有用,原来需要使用

<pre>grub2-editenv /etc/default/grub create
grub2-editenv /etc/default/grub set GRUB_DEFAULT=saved
grub2-editenv /etc/default/grub set GRUB_SAVEDEFAULT=true
</pre>

这样才能被grub所识别,
其实可以直接使用官方给的路径更简单,

重新生成grub.cfg 覆盖原有文件:

<pre>sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo cp /boot/grub2/grub.cfg /boot/efi/EFI/fedora/grub.cfg
</pre>

重启查看效果

文档是个好东西,就看会不会使用了
[官方文档](https://www.gnu.org/software/grub/manual/grub.html#)
