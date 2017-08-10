---
layout: post
title: 在Ubuntu 17.04 下DWM的安装

categories:
- Linux

tags: [Linux，DWM]

author:
  login: lanbing
  email: c834606877@163.com
---





比较简单的安装方法莫过于通过apt来安装了。

<pre>sudo apt-get install dwm</pre>

这样的安装方式，虽然提供了四种不同的已经配置好的<code>dwm.default</code> <code>dwm.maintainer</code> <code>dwm.web</code> <code>dwm.winky</code>，但相对于dwm的自定义空间基本上是没有的，毕竟dwm的自定义是通过源码重新编译来完成的。



DWM的源码可以从作者的[SuckLess网站](http://dwm.suckless.org)下载，网站也提供了一些简单的使用方法，对于一般人来说也足够了。



下载解压至相应路径即可以进行，make install

注意，由于新版本的freetype2库的改动，

需要更新config.mk文件，将中下面两行进行注释:

<pre>#OpenBSD (uncomment)

FREETYPEINC = ${X11INC}/freetype2</pre>

即启用<code>FREETYPEINC = /usr/include/freetype2</code>



如果还缺少其它头文件，可以利用apt-file search youfile.h进行查找，并安装相应软件包。



如果make install成功。此时，dwm已经被安装到<code>/usr/local/bin</code>目录下。



参照:[CustomXSession](https://wiki.ubuntu.com/CustomXSession) Ubuntu下标准自定义session的配置方法。



在~/.xinitrc 文件中定入以下内容：

<pre>

#!/bin/bash

# enable ibus
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export QT4_IM_MODULE=ibus
export CLUTTER_IM_MODULE=ibus
export XMODIFIERS=@im=ibus



exec /usr/local/bin/dwm

</pre>

重启Ubuntu即可在登录选项中看到预先设置dwm选项。



此外，也可以在命令行界面下执行<code>startx</code>命令启动dwm。