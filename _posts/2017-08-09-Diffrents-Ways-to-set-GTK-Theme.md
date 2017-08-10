---
layout: post
title: Linux下各种修改GTK主题的方法

categories:
- Linux
- GTK
tags: [Linux，GTK Theme]

author:
  login: lanbing
  email: c834606877@163.com
---



>  X为了提供更加灵活桌面的实现，使得Linux下桌面环境比较繁杂，这也衍生出众多Coder对自己Linux桌面进行定制的程序。有功能全面的Desktop Env，比如GNOME，KDE，LightDM，也有轻量功能强大的Window Manage，比如owesome，dwm。



在图形桌面环境下，各个Desktop Env都提供了相应对自身主题的修改，比如gnome-tweak-tool、unity-tweak-tool，通过修改Shell Theme可以切换不同的主题。



命令行下的修改可以通过 <code>gsettings set org.gnome.desktop.interface gtk-theme “Mytheme” </code>来完成。



Linux发行版安装之后会默认自带部分主题，更多好看的可以在 [Gnome Look](http://www.gnome-look.org) 、[KDE Look](http://www.kde-look.org) 下载。



主题的安装，一般将主题包下载解压至/usr/share/themes/ 或~/.local/share/themes/下即可被各种Tweak程序检测到。



但是，以上方法仅仅是对相应Desktop Env下主题的修改。一旦更换了桌面环境或者窗口管理器，这些效果将消失。



其实，GTK本身提供修改主题的方法：



一、可以通过修改程序运行时环境参数<code>GTK_THEME</code>来临时修改单个程序的主题，比如运行使用Adwaita:light替代Ubuntu下Firefox的橘红色主题：<code>env GTK_THEME=Adwaita:light firefox</code>

二、可以通过修改<code>/etc/gtk-3.0/settings.ini</code>或<code>~/.config/gtk-3.0/settings.ini</code>文件中gtk-theme-name项，进行全局修改。



此外，文件还提供了icon图标以及sound声音的修改。