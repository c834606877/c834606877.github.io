---
layout: post
title: Ubuntu 17.04 apt 无法更新，repository '...' does not have a Release file

categories:
- Linux

tags: [Linux, Ubuntu, zesty, apt, release]

author:
  login: lanbing
  email: iziy@mypre.cn
---


这阵子打算换Arch的时候，想在Ubuntu最后折腾一番，没想到apt update的时候出现了其怪的事情。


```
lanbing@LanBing-Ubuntu:~$ sudo apt update
Hit:1 http://ppa.launchpad.net/webupd8team/sublime-text-3/ubuntu zesty InRelease
Ign:2 http://cn.archive.ubuntu.com/ubuntu zesty InRelease
Ign:3 http://cn.archive.ubuntu.com/ubuntu zesty-security InRelease
Ign:4 http://cn.archive.ubuntu.com/ubuntu zesty-updates InRelease
Err:5 http://cn.archive.ubuntu.com/ubuntu zesty Release
  404  Not Found [IP: 91.189.91.23 80]
Err:6 http://cn.archive.ubuntu.com/ubuntu zesty-security Release
  404  Not Found [IP: 91.189.91.23 80]
Err:7 http://cn.archive.ubuntu.com/ubuntu zesty-updates Release
  404  Not Found [IP: 91.189.91.23 80]
Reading package lists... Done
E: The repository 'http://cn.archive.ubuntu.com/ubuntu zesty Release' does not have a Release file.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
E: The repository 'http://cn.archive.ubuntu.com/ubuntu zesty-security Release' does not have a Release file.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
E: The repository 'http://cn.archive.ubuntu.com/ubuntu zesty-updates Release' does not have a Release file.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
```

尝试了国内的几个主流源：
```
https://mirrors.tuna.tsinghua.edu.cn/ubuntu/
http://mirrors.aliyun.com/ubuntu/
http://ftp.sjtu.edu.cn/ubuntu/
```
均出现了类似的错误，后改为官方的源，同样出现此错误，还莫名其妙多出几百个Ign。
仔细到源目录下分析
发现确实不存在http://cn.archive.ubuntu.com/ubuntu/dists/zesty/Release

原来官方把17.04 zesty这个版本的源移到了old-release。
然而国内大部分源也是同步了官方的源，导致了找不到相关源的信息。


遂将source.list源修改成官方的
```
http://old-releases.ubuntu.com/ubuntu
```
于是apt update可以顺利更新了。

但问题又来了，由于官方的源在国外，更新速度太慢，眼看着50M的带宽不满足于此。

最后，发现中科大的镜像源提供了old-release，于是：
```
sudo vi /etc/apt/source.list

将源地址换为：
http://mirrors.ustc.edu.cn/ubuntu-old-releases/ubuntu



lanbing@LanBing-Ubuntu:~$ cat /etc/apt/sources.list
###### Ubuntu Main Repos
deb http://mirrors.ustc.edu.cn/ubuntu-old-releases/ubuntu/ zesty main universe 

###### Ubuntu Update Repos
deb http://mirrors.ustc.edu.cn/ubuntu-old-releases/ubuntu/ zesty-updates main universe 


```


参考：
>> ![http://www.cnblogs.com/jiangz/p/4076811.html]http://www.cnblogs.com/jiangz/p/4076811.html

