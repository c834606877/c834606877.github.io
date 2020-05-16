---
layout: post
title: 黑苹果实现iPhone/iPad快充功能

categories:
- 系统应用


tags: [系统应用]

author:
  login: lanbing
  email: c834606877@163.com
---





通常，iphon或iPad连接苹果电脑的USB口时，会使用快充功能，充电功率可以达到2.1A，在[关于本机->系统报告->USB-iPad]中可以看到可用电流为500mA，加上额外的操作电流1600mA，总共2.1A。

然而在MacOS 10.13中USB的电源管理部分，由之前的AppleBusPowerControllerUSB变成了AppleBusPowerController，对应的电源描述属性也有所变化，在tonymacx86.com上RehabMan大佬已经详细阐述了这个问题：

[[Guide] USB power property injection for Sierra (and later) ](https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266/)

也就是EC的问题。

然而，在我的k610d笔记本上，显示EC被正常识别，AppleBusPowerController也正常加载，USB接上iPad后，额外的所需电流只有900mA，起初没太在意，直到后来把网卡换成BCM943后，额外的所需电流变成了850mA，再到后来接上鼠标后，  额外的操作电流 (mA)变成了650mA，于是不能再忍了。

今天，查看主板USB供电部分，三个接口，左侧USB有一块1.5A限流芯片，右边一个USB3.0和一个USB2.0供电部分直接接到了S5态的19v转5v的DC-DC上，芯片型号为nb671，查看数据手册发现，该芯片持续电流可达6A，峰值电流可达9A，分出2A来充电也是绰绰有余了，不会造成沁硬件损伤。



由于重新修改SSDT-UIACaml中电源电流供应参数，将USB总电流供应由3200ma提升为4100ma，这样在有耗电设备增加时，也不会由于总供电量不足而减少iPad的快充供电。

参考https://www.tonymacx86.com/threads/cant-charge-ipad-using-usb-ports-el-capitan.230465/