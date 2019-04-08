---
layout: post
title: RiscV-RoCC(RiscV协处理器, Rocket Custom Coprocessor) 介绍

categories:
- RiscV


tags: [RiscV, RoCC]

author:
  login: lanbing
  email: c834606877@163.com
---





RiscV作为一个新的开源指令集架构,由Aspire Lab开放,具有简单开放的特点,主要用于教育研究.

一个最主要的特点是其ISA通过支持自定义指令的方式，支持自定义硬件加速器，用于专用领域的计算加速设计。

本文简单介绍RiscV的RoCC，以及其与RiscV处理器核通信的接口RoCC Interface。



#### RiscV自定义指令

RiscV ISA定义了四种自定义指令用于与协处理器进行交互。

```asm
customX rd, rs1, rs2, funct
```

标准自定义指令格式如下：

![Screenshot from 2019-04-08 21-07-00](/post_res/2019-04-08-RiscV-RoCC.assets/1.png)

其中rs1,rs2 为源寄存器，rd为目的寄存器，xd,xs1,xs2为寄存器有效位，分别指明rd,rs1,rs2是否已使用。

opcode为四种不同的custom指令(custom-0/1/2/3/)

<!--more-->


#### RoCC Inferface(RoCC交互接口)

RoCC 接口由多组不同的Wire和bundle组成。如下图所示：

![Screenshot from 2019-04-08 21-16-30](/post_res/2019-04-08-RiscV-RoCC.assets/2.png)

其中cmd包含2个源寄存器的内容，和整条指令内容。resp包含目的寄存器。cmd和resp均为Decoupled接口。

协处理器可以直接通过HellaCacheIO接口访问处理器一级缓存。HellaCacheIO由req和resp两个Decoupled接口组成。

#### Decoupled接口简介

Decoupled接口是一种基于FIFO，类似ready/valid协议，如下图所示：

![Screenshot from 2019-04-08 22-06-07](/post_res/2019-04-08-RiscV-RoCC.assets/3.png)

请求方（发送方core A）准备好data信号和并拉高valid线，等待coreB响应ready信号线的拉高。如果CoreB可以立即响应，则可在同一周期内拉高信号。

参考：

https://inst.eecs.berkeley.edu/~cs250/sp16/disc/Disc02.pdf

https://webthesis.biblio.polito.it/6589/1/tesi.pdf





