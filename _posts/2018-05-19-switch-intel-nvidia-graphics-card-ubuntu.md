---
layout: post
title: Ubuntu下如何切换Intel和Nvidia显卡

categories:
- Linux


tags: [Ubuntu, N卡, 核显, 切换 ]

author:
  login: lanbing
  email: c834606877@163.com

---



> 原文：[How To Switch Between Intel and Nvidia Graphics Card on Ubuntu](https://www.linuxbabe.com/desktop-linux/switch-intel-nvidia-graphics-card-ubuntu)
>
> 翻译水平有限，还望批评指正，都㚏2020s了，有关解决方案大家还是自行Google吧。



在笔记本上如何查看核显和N卡是折腾显卡的第一步。这篇文章展示在Ubuntu理如何和谐的切换Intel核显和N卡。

## 你应该使用哪块显卡？

对于游戏和3D绘图等要求大量图形计算来说，应该切换至N卡。

如果你对游戏和3D绘图不感觉兴趣，那么，Intlel核显将满足你的日常使用，并且比起N卡更省电。



###  ＃1 查看电脑上哪些显卡

在Ubuntu下可以非常简单的做这个事：

```
lspci -k | grep -E -A2 -i 'VGA|3D'
```

![https://www.linuxbabe.com/wp-content/uploads/2016/04/Selection_010-1.png](/post_res/2018-05-19-switch-intel-nvidia-graphics-card-ubuntu.assets/1.png)



### #2 查看正在使用哪块显卡

Ubuntu 默认会使用Intel核显。

如果你以前对显卡驱动做过改动，又不记得了，那么可以在图形界面下，`系统设置` >` 细节` （`system settings` > `details`）中查看。



### #3 安装Nvidia显卡驱动

Ubuntu本身集成了N卡开源驱动nouveau在Linux内核里，但此驱动缺少3D加速的支持. 要发挥显卡性能，我们可以用`software-properties-gtk`程序去安装合适的驱动。

![Software & Updates_ additional drivers](/post_res/2018-05-19-switch-intel-nvidia-graphics-card-ubuntu.assets/Softwareandupdates.png)



你可以选择最新的版本，应用更改。

也可以通过下列命令，查看推荐的驱动版本：

```
 sudo ubuntu-drivers devices
```

![How To Switch Between Intel and Nvidia Graphics Card on Ubuntu](/post_res/2018-05-19-switch-intel-nvidia-graphics-card-ubuntu.assets/2.png)

下列命令将会自动安装Nvidia驱动。

 ```
sudo ubuntu-drivers autoinstall
 ```

在合适的驱动安装成功后，重新打开`系统设置` >` 细节` （`system settings` > `details`），你将会看到新安装的驱动已经选择上了，如果没有的话，请自行选择，并应用修改。

![https://www.linuxbabe.com/wp-content/uploads/2016/04/Software-Updates_013.png](/post_res/2018-05-19-switch-intel-nvidia-graphics-card-ubuntu.assets/Softwareandupdates.png)

现在我们已经安装好了合适的N卡驱动了，但是，我们仍然在使用Intel核显。

### #4 切换到N卡

在你选择好了N卡驱动后，可能需要重启你的电脑，以启用PRIME支持。如果PRIME没有启动，可能会出现下面的信息：

```
Message: PRIME: is it supported? no
```

重启之后，可以从应用列表中打开`Nvidia X Server Settings`，或者从命令行打开：

```
#: nvidia-settings
```

![NVIDIA X Server Settings_ prime profiles](/post_res/2018-05-19-switch-intel-nvidia-graphics-card-ubuntu.assets/NVIDIA-X-Server-Settings_014.png)

在PRIME Profiles` 选项卡中，选择你想切换的显卡， 重启电脑。

你就可以在`系统设置` >` 细节` （`system settings` > `details`）中看到N卡了。

想要切换回Intel核显，只需要在上图中点击Intel即可。



也可以通过命令行的方式，切换到核显：

```
sudo prime-select intel
```

或N卡：

```
sudo prime-select nvidia
```

查看哪块显卡正在使用：

```
prime-select query
```



## 如何和卸载N卡驱动

有时个你Nvidia安装失败，或者没有成功，黑屏了，没有办法进入图形界面，或者出现以下错误：

```
driver ebridge is already registered aborting
```

这种情况你需要完全的卸载N卡驱动，通过运行下列命令，完全移除nvidia相关包：

```
sudo apt purge nvidia-*
```

