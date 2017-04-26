---
layout: post
title: Open Here In Teminal From Nautilus

categories:
- Linux系统
tags: [nautilus]

author:
  login: lanbing
  email: c834606877@163.com
---



Linux 下的文件管理器 nautilus 可以很容易在终端中打开通过命令

    [lanbing@LanBing-Laptop ~]$ nautilus .

但是要想在 nautilus 中打开 Terminal 却很麻烦 于是google了一下 发现软件包：nautilus-open-terminal 功能如其名，果断：

    [lanbing@localhost ~]$ sudo dnf search  nautilus-open-terminal
    [sudo] password for lanbing: 
    Last metadata expiration check performed 1 day, 5:43:29 ago on Wed Apr 13 14:49:06 2016.
    ===================== N/S Matched: nautilus-open-terminal ======================
    nautilus-open-terminal.x86_64 : Nautilus extension for an open terminal shortcut
    [lanbing@localhost ~]$ sudo dnf install nautilus-open-terminal -y

安装后在 文件管理器 中右键 即可 方便打开 Terminal 了
