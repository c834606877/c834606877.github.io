---
layout: post
title: Change Gnome Shell theme after ubuntu upgraded to 1710

categories:
- Linux

tags: [Ubuntu，Gnome, GDM, Theme]

author:
  login: lanbing
  email: c834606877@163.com
---



由于Ubuntu非LTS版，官方维护周期为9个月，遂更新了Ubuntu从17.04到17.10。

然而更新之后Gnome的桌面管理器（GDM），主题被修改成了类Ubuntu风格橘红色。

这种奇葩的风格，也许只有Ubuntu的创始者们才喜欢吧。



最初想法是寻找到gnome-look上找到原版gdm主题，果然发现了很多好看的主题，类XP，类WIN789，类osx。但花虽美，却不是我想要的。



随着google一通之后，发现解决方案也简单，

```bash
sudo update-alternatives --config gdm3.css
There are 2 choices for the alternative gdm3.css (providing /usr/share/gnome-shell/theme/gdm3.css).

  Selection    Path                                          Priority   Status
------------------------------------------------------------
* 0            /usr/share/gnome-shell/theme/ubuntu.css        10        auto mode
  1            /usr/share/gnome-shell/theme/gnome-shell.css   5         manual mode
  2            /usr/share/gnome-shell/theme/ubuntu.css        10        manual mode

Press <enter> to keep the current choice[*], or type selection number:
```



GDM在`/etc/alternatives/`目录下有设置了一些可选项，其中就包括了控制gnome-shell主题的配置选项，而更新的Ubuntu只是新增了该选项，并增加了优先级。



如此，可以比较方便的通过`update-alternatives`命令来修改gdm主题了。



参考

> [Ubuntu GNOME Shell in Artful: Day 11](https://didrocks.fr/2017/09/11/ubuntu-gnome-shell-in-artful-day-11/)
