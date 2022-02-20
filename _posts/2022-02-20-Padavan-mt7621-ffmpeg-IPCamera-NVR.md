---
layout: post
title: 在Padavan上实现支持RTSP网络摄像头的录像机功能

categories:
- 网络应用
- 应用技巧

tags: [Padavan, MT7621, IPCamera, OpenWrt, NVR, ffmpeg]

author:
  login: lanbing
  email: c834606877@163.com
---



基于mt7621处理器的路由器通常都具有一个可扩展的USB接口，可以转接U盘，硬盘或者USB网卡之类。

既是路由器也是一个小型网络存储器，可省去额外配置一个nas，相比nas功能比较少，但也具有一定的可配置性。

这里简单介绍如何在运行类openwrt系统的路由器上实现网络录像机(NVR)的功能。

如今网络上的云摄像头已经卖到100元上下了，有萤石云摄像头，360摄像头，小米摄像头，TP-Link等，但这类型的摄像头都需要额外购买云存储服务才存储回放录像，显然这部分附加服务不具有性价比。

按照专物专用的原则，一台群晖也可以解决，但毕竟要多出一个东西。因此在路由器上实现类似NVR功能是最经济的做法。

很多云摄像头的商品描述页面，并不会直接写明支持RTSP传输，但会写支持NVR功能。

据我了解，TPLink全系均支持NVR功能，莹石云摄像机官方未显式支持但C2C/C3C/C6C等几个型号存在RTSP协议。

下面开始正文。

<!--more-->

运行在路由器上的openwrt是支持entware的，而entware作为一个基础运行环境，移植了大量开源应用程序，包括libx264, ffmpeg等。

这里介绍如何安装entware并且进行rtsp数据拉取存储。

1. 在路由器配置界面开启SSH登录配置，并通过ssh登录到路由器

2. 创建/opt 并且用一部分内存挂载为内存文件系统

   mkdir  /opt && mount -t tmpfs -o size=50m tmpfs /opt

3. 下载并安装entware运行环境，

```bash
   wget  http://bin.entware.net/mipselsf-k3.4/installer/generic.sh -O /tmp/entware_installer.sh
   chmod +x /tmp/entware_installer.sh
   sh /tmp/entware_installer.sh
```



4. 该脚本会安装opkg工具，可能通过运行opkg来确定环境是否安装成功，另外请注意
```
   wget  http://bin.entware.net/mipselsf-k3.4/installer/generic.sh -O /tmp/entware_installer.sh
   chmod +x /tmp/entware_installer.sh
   sh /tmp/entware_installer.sh
   ```


5. 该脚本会安装opkg工具，可能通过运行opkg来确定环境是否安装成功

6. 下面安装ffmpeg

````bash
   opkg install ffmpeg
````

7. opkg 会安装软件所需要的依赖。另外请注意entware.net作为国外网站，并且entware官方目前不允许作为镜像网站的存在，因此，可能出现偶然性的失败。多

8. 安装好ffmpeg后，可通过 ffmpeg命令来查看ffmpeg的编译选项和版本信息。

```
   /tmp # ffmpeg -decoders
   ffmpeg version 4.3.2 Copyright (c) 2000-2021 the FFmpeg developers
     built with gcc 8.4.0 (OpenWrt GCC 8.4.0 r1808-45c16d86)
     configuration: --enable-cross-compile --cross-prefix=mipsel-openwrt-linux-gnu- --arch=mipsel --cpu=mips32r2 --target-os=linux --prefix=/opt --pkg-config=pkg-config --enable-shared --enable-static --enable-pthreads --enable-zlib --disable-doc --disable-debug --disable-lzma --disable-vaapi --disable-vdpau --disable-outdevs --disable-altivec --disable-vsx --disable-power8 --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-fast-unaligned --disable-runtime-cpudetect --disable-x86asm --enable-gnutls --enable-libopus --enable-small --enable-libshine --enable-gpl --enable-libx264
     libavutil      56. 51.100 / 56. 51.100
     libavcodec     58. 91.100 / 58. 91.100
     libavformat    58. 45.100 / 58. 45.100
     libavdevice    58. 10.100 / 58. 10.100
     libavfilter     7. 85.100 /  7. 85.100
     libswscale      5.  7.100 /  5.  7.100
     libswresample   3.  7.100 /  3.  7.100
     libpostproc    55.  7.100 / 55.  7.100
```


9. 在摄像头方面，假设已经拿到了rtsp的流地址，可能过vlc等软件验证。这里演示的rtsp地址如下。

```rtsp://192.168.123.112/stream1```

10. 使用ffmpeg保存录像内容。

```
    ffmpeg -i rtsp://192.168.123.112/stream1 -acodec copy -vcodec copy test.mp4
```

    这里要注意的是，acodec和vcodec都使用rtsp stream原本传输的音视频格式直接保存。而不进行任何编解码格式的转换，这是为了避免引入大量cpu资源，特别是vcodec。除非在mp4不支持包含某些codec的情况下，才需要进行转码，并且关注此期间的cpu负载情况。






