---
layout: post
title: Linux下的是日志自动打包分割工具

categories:
- Linux


tags: [Linux]

author:
  login: lanbing
  email: c834606877@163.com

---


在VPS上经常需要跑一些程序或脚本，自然会产生出很多日志。
但要是单单为一个几十行代码的程序去加一个日志管理的功能也显得臃肿。

造轮子是不可能造轮子的。

于是，又查了一遍system log相关的内容，有rsyslogd等等，
但不方便使用，而且是系统级别的。
后来发现像nginx,httpd，等等都是有通过一个名为logrotate的工具，自动对日志文件进行整理。

```
man logrotate

```

写得有些不知所云，英语是个二把刀。
花了几些时间整理一下用法。
程序功能比较简单，配置文件(/etc/logrotate.d/*)的参数有两大方面:

- 一是控制日志整理周期，保存方式等等。
- 二是对原程序的输出做接管，处理（通过kill发送信号量）。

日志输出程序只需输出日志到指定位置既可，其它所有对日志的整理操作由logrotate来完成。


---

未完，待续。
