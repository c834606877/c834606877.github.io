---
layout: post
title: Linux Sound Server 

categories:
- Linux

tags: [ArchLinux]

author:
  login: lanbing
  email: c834606877@163.com
---



ArchLinux下使用DWM有两个月了，但是声音模块一直是很大的问题。

一开始以为DELL Vsion3668的声卡驱动不同寻常，毕竟之前在Windows下的驱动就装了老费劲了。

之前CTF校赛加上嵌入式论文讨论班一阵忙活，空出时间继续搞ArchLinux，没有声音一直很难受。

查文档发现原来是pulseaudio没有启动，这是Linux下的声音Server。


Linux下的声音系统比较杂，现今多数使用ALSA;

ALSA是一个集成了声卡驱动和底层接口的东西，而pulseaudio是声音服务器，应用程序要想输出声音需要往pulseaudio里边送。



于是:
```bash
vim ~/.xinitrc
```

```bash
pulseaudio --start
```

启动声间服务器。


参考：
> https://wiki.archlinux.org/index.php/Sound_system
> https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture
