---
layout: post
title: Use DWM in Gnome Desktop Environment without Gnome-shell

categories:
- Linux

tags: [Gnome，DWM, Linux, Ubuntu]

author:
  login: lanbing
  email: iziy@mypre.cn
---



自从换上轻量级的桌面管理器`DWM`之后，屏幕利用率得到了提升。但是，由于在dwm仅仅是一个桌面管理器，并不具备其它一些实用功能，比如Ubuntu的NightMode，控制中心等，只有在Gnome环境下才能使用。



之前使用 [CustomXSession](https://wiki.ubuntu.com/CustomXSession),调用`/etc/X11/Xsession`，接着调用~/.xsesseion脚本启动dwm，比如ibus,gtk,相关的配置均在用户目录下的`.xsession`脚本中完成。



而现在通过`gnome-session --session=dwm-gnome`方式调用dwm-gnome脚本，由dwm-gnome调用dwm启动，此外，在 `/usr/share/gnome-session/sessions/`下建立同名session文件，模仿gnome.session，填写RequiredComponents，并且去除`org.gnome.Shell`，这些组件的启动将会由Gnome-Session进行统一启动管理。



自动安装方案在ArchLinux下有相应关的包可供下载:

```pacman -S dwm-gnome```



Ubuntu 可以通过Makefile进行安装:

dwm-gnome: [https://github.com/palopezv/dwm-gnome](https://github.com/palopezv/dwm-gnome)

