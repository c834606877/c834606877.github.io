---
layout: post
title: linux下更新ibus-wubi输入法词库

categories:
- linux系统
- ibus
tags: [更新ibus输入法词库]

author:
  login: lanbing
  email: c834606877@163.com
---



> 参考 ubuntu Wiki：[https://wiki.ubuntu.com.cn/IBus](https://wiki.ubuntu.com.cn/IBus)
>
> IBus 全称 Intelligent Input Bus是下一代输入法框架（或者说“平台”）。
> 项目现托管于 Google Code - [https://code.google.com/p/ibus/](https://code.google.com/p/ibus/)
> 此项目包含了世界多数语言的文字输入需求——由世界多个国家开发者维护。



虽然世界上有那么多人在维护IBus，然而相对于国内的输入法市场，也算是相形见绌了。



输入法默认提供的词库，并没有经过人性化的处理，大部分异体字，以及不常用的词语，还有各类流行短语，比如“跑路”、“静静”、“微博”，部分字词还停还停留在上个世纪的感觉，

所以不得不变回我的Win7从QQ Wubi设置里边导出了一份txt格式的默认词库。（不得不说，腾讯的产品就剩下这点儿清白了）

<!--more-->

ibus的词库文件在 <code>/usr/share/ibus-table/tables/</code> 目录下，

<pre>lanbing@LanBing-Ubuntu:~$ ll -h /usr/share/ibus-table/tables/ 
total 14M
drwxr-xr-x 2 root root 4.0K Aug 13 13:17 ./
drwxr-xr-x 7 root root 4.0K Apr 12 11:12 ../
-rw-r--r-- 1 root root 5.0K Jan 14  2017 template.txt
-rw-r--r-- 1 root root 4.8M Dec 10  2016 wubi-haifeng86.db
-rw-r--r-- 1 root root 5.7M Dec 10  2016 wubi-jidian86.db</pre>

可见一个海峰五笔的词库为4.8M，极点五笔的词库在5.7M。

<pre>lanbing@LanBing-Ubuntu:~$ file /usr/share/ibus-table/tables/wubi-jidian86.db 
/usr/share/ibus-table/tables/wubi-jidian86.db: SQLite 3.x database, last written using SQLite version 3015002</pre>

通过查询，db文件是SQLitey文件数据库。



<pre>sqlite> .schem
CREATE TABLE ime (attr TEXT, val TEXT);
CREATE TABLE goucima

            (zi TEXT PRIMARY KEY, goucima TEXT);
CREATE TABLE pinyin
            (pinyin TEXT, zi TEXT, freq INTEGER);
CREATE TABLE phrases
        (id INTEGER PRIMARY KEY, tabkeys TEXT, phrase TEXT,
        freq INTEGER, user_freq INTEGER);</pre>


将原数据库备份，利用linux下SQLite图形化工具将QQ Wubi词库作为新表导入到数据库。再利用SQL语法进行去重和新增，最终得到了一个约3.8M的词库数据库文件。



最后重启ibus

```bash
lanbing@LanBing-Ubuntu:~$ ibus-daemon -drx
```



新的输入法没有了很多连字体都不支持（煞风景）的字词，流行常用词语也可以轻易打出，打字速度也更愉快了～



顺便提供一个，已经改好的版本。[下载](/post_res/wubi-haifeng86.db)



此外，IBus 提供三个主要配置命令：ibus-setup、ibus-daemon、ibus-table-createdb。



ibus-setup 输入法配置 提供图形化配置输入法选项设置



ibus-daemon 提供对ibus服务的管理



ibus-table-createdb 则是提供一个可供用户自动生成词库文件db的工具



关于自己创建词库的方式可以参考 Ubuntu Wiki 自定义码表输入法及设置:[https://wiki.ubuntu.com.cn/IBus#.E8.87.AA.E5.AE.9A.E4.B9.89.E7.A0.81.E8.A1.A8.E8.BE.93.E5.85.A5.E6.B3.95.E5.8F.8A.E8.AE.BE.E7.BD.AE.EF.BC.9A](https://wiki.ubuntu.com.cn/IBus#.E8.87.AA.E5.AE.9A.E4.B9.89.E7.A0.81.E8.A1.A8.E8.BE.93.E5.85.A5.E6.B3.95.E5.8F.8A.E8.AE.BE.E7.BD.AE.EF.BC.9A)

