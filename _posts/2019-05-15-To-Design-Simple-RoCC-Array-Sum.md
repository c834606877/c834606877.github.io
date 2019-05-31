---
layout: post
title: 设计一个简单的RiscV协处理器RoCC（数组求和）一

categories:
- RiscV


tags: [RiscV, RoCC]

author:
  login: lanbing
  email: c834606877@163.com
---



>　从系统效率和功能可复性方面来讲，当要使得协处理器能够处理更多的应用情景时，应当将目标事物，拆分成一系列更小的重复通用的事物处理过程，在上层软件中再进行事物处理的组装。而当要使得协处理器以系统效率为主，比如低功耗，则需将系统功能整体设计为一个功能单一的模块，做为专用处理器。

本文叙述一个简单的协处理器设计过程，用以加深对RoCC接口的理解。



RoCC加速器模块是由LazyRoCC类继承而来，该模块包含一个由LazyRoCCModuleImp继承而来的实例。

依葫芦画瓢，我们先设计一个加速器模块的外壳，用以可以被Rocket核调用。

```scala



class ArraySumCoP(opcodes: OpcodeSet)(implicit p: Parameters) extends LazyRoCC(opcodes) {
  override lazy val module = new ArraySumCoPImp(this)
}

class ArraySumCoPImp(outer: ArraySumCoP)(implicit p: Parameters) extends LazyRoCCModuleImp(outer)
    with HasCoreParameters {
    val cmd = Queue(io.cmd)
        ...
        ...
        ...
        
}

```

由于LazyRoCCModuleImp中已经包含了一个RoCCIO的接口，我们可以在实现中直接使用此接口。

RoCCIO接口由多组不同的Wire和bundle组成，具体信息参考上一篇文章：[RoCC接口介绍](https://mypre.cn/2019/04/08/RiscV-RoCC)

其中，cmd包含了Custom指令调用时，加速器接收到的内容，参数如下：

- cmd.inst，为32位指令内容，由以下组成：cmd.inst.[opcode, rd, rs1, rs2, funct, xd, xs1, xs2
- cmd.rs1，为源寄存器1内容
- cmd.rs2， 为源寄存器2内容

此外，`LazyRoCC`类包含了两个`TLOutputNode`实例: `atlNode`和`tlNode`，分别通过Tilelink总线的方式连接到L1缓存，和L2缓存

mem实例用于直接访问L1 Cache缓存，ptw直接访问页表，busy信号指明加速器是否正在处理指令以及一个中断信号。

本次,我们使用mem接口来实现对内存数据的访问和存储。

<!--more-->

**mem接口的使用说明**

mem是一个HellaCacheIO实例，有req和resp两个实例。以下是调用流程：

1. 判断mem接口是否正在使用

   根据io.mem.req.ready 拉高则表示mem正在响应请求，当请求结束，io.mem.req.ready将会置低。

2. 发起mem请求

   根据io.mem.req.valid拉高表示请求mem，mem如果能响应请求则会立即拉高io.mem.req.ready。

   因此在请求mem的同时需要准备好请求参数，包括addr(请求内存地址)，tag(请求标签)，cmd(请求命令读或写)，typ(数据宽度,1,2,4,8.... bytes)，data(如果为写,则传入要写的内容)

3. 响应请求成功

   当mem成功响应请求，即mem.req.ready拉高的时候，将会触发io.mem.req.fire()。

   代码示例：

   ```scala
   when(io.mem.req.fire()){
       state := s_mem_resp
   }
   ```

4. mem数据接收

   当mem准备返回数据时，将会拉高io.mem.resp.valid线，我们可以对该线设置上升沿触发器，并接收数据。

   代码示例：

   ```scala
   when(io.mem.resp.valid){
       r_date := io.mem.resp.bits.data
       r_tag  := io.mem.resp.bits.tag
       state := s_what_next_to_do
   }
   ```




**设计指令功能格式及数据输入**

RoCC指令操作数可以通过rs1和rs2寄存器数据输入，rd寄存器数据输出。

因此，我们将rs1设置为内存数组起始地址，rs2设置为需要计算的数组前n个元素的内存大小。

当指令的功能号为0时，rd做为计算结果返回寄存器。

当指令的功能号为1时，rd做为计算结果返回寄存器，并且将结果写入内存数组第n+1个元素的位置。

代码示例：

```scala
val addr = Reg(UInt(width = xLen))
val end_addr = Reg(UInt(width = xLen))
val current_sum = Reg(UInt(width = xLen))
val funct = io.cmd.bits.inst.funct
val doWriteBack = (funct === UInt(1))


```

当指令被执行的时候，我们将操作数传入我们的内部寄存器：

```scala

when (io.cmd.fire()) {
    addr := io.cmd.bits.rs1
    end_addr := io.cmd.bits.rs1 + io.cmd.bits.rs2

    current_sum := UInt(0)
    
}
```







**指令执行流程设计**

我们通过一个```state```状态转换的方式控制指令执行过程。

当我们的协处理器处理空闲状态时，将state设置为```s_idle```

当需要发起内存请求时，将state设置为```s_mem_req```

当等待接收内存数据时，将state设置为```s_mem_resp```

当指令运行结束，指令返回时，将state设置为s_resp



**指令返回**

当指令功能执行结果后，需要对指令结果进行返回。

依照Decouple方式，准备好要返回的数据，然后将io.resp.valid 拉高，同时将io.busy置为低，等待io.resp.fire()触发即可。

代码示例：

```scala
when (io.resp.fire()){
    state := s_idle
}

io.resp.valid := (state === s_resp)
io.resp.bits.rd := io.cmd.bits.inst.rd
io.resp.bits.data := current_sum

io.busy := (state =/= s_idle)

io.interrupt := Bool(false)

```

完整设计，待续～