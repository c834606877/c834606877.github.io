---
layout: post
title: 在arty a7-35t FPGA开发板上运行Sifive开源RiscV处理器简单指导

categories:
- RiscV


tags: [RiscV, Sifive]

author:
  login: lanbing
  email: c834606877@163.com
---


要在FPGA开发板上调通RiscV主要需要两方面知识，一方面是简单的电子电路知识，二是软件层工具链和嵌入式开发知识。

在ARTY 35T FPGA开发板上运行RiscV还需要一个支持RiscV处理器核的JTag调试器，用于调试和下载程序。
官方使用的是Olimex ARM-USB-TINY-H。

主要流程分为三个部分：
1. 生成用于烧录到FPGA开发板上包含整个RiscV Soc的mcs文件
2. 安装RiscV gcc工具链，生成并上传软件代码程序。
3. 调试和测试软件程序

运行环境
整个过程使用Ubuntu 16.04完成，并且建议使用实体机器运行，100g以上硬盘空间，原因主要有几点：
1. 生成Sifive fe310处理器需要用到linux环境。
2. vivado 目前只支持Ubuntu1604而且是较老的Ubuntu1604.3
3. 减小USB插拔转换不必要的麻烦。
4. 运行效率和GUI体验。

### 一、安装和下载必要的软件

在开始之前需要准备好以下软件。

1. vivado HLx    -->    用于生成arty的mcs文件和fpga烧写 大小17G左右
   https://www.xilinx.com/support/download.html

2. sifive/freedom    -->    Github RiscV SoC 源代码

3. sifive/freedom-e-sdk  -->      Github Sifive提供的软件开发SDK 代码

4. 预编译gcc工具链和riscv OpenOCD  -->    由Sifive官方网站Tools提供。

   https://www.sifive.com/boards/

5. Digilent/vivado-boards -->       Github vivado arty开发板文件

6. Adept 2        --> Arty FPGA开发板驱动

   https://reference.digilentinc.com/reference/software/adept/start

下载和安装可以同时进行以节约时间

<!--more-->

#### 安装vivado

将vivado下载后解压。
```
cd 安装文件目录
sudo ./xsetup
```
选择安装 Vivado HL WebPACK 版本，并在安装选项中确保Artix-7系列设备已勾选。

安装目录在/opt即可。

#### 安装arty 35t板级文件

从github克隆下来之后，复制到vivado-boards目录下

```shell
git clone https://github.com/Digilent/vivado-boards
cp -rv ./vivado-boards/new/board_files/*  /opt/Xilinx/Vivado/2018.3/data/boards/board_files/
```

####安装GCC 工具链与OpenOCD

```sh
cd /opt/
wget -c https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.2.0-2019.02.0-x86_64-linux-ubuntu14.tar.gz
wget -c https://static.dev.sifive.com/dev-tools/riscv-openocd-0.10.0-2019.02.0-x86_64-linux-ubuntu14.tar.gz
tar -xf riscv64-unknown-elf-gcc-8.2.0-2019.02.0-x86_64-linux-ubuntu14.tar.gz
tar -xf riscv-openocd-0.10.0-2019.02.0-x86_64-linux-ubuntu14.tar.gz
```

#### 为GCC和OpenOCD和Vivado设置系统环境变量

将以下四行添加加 `~/.bashrc`文件尾部

```
export RISCV=/opt/riscv64-unknown-elf-gcc-8.2.0-2019.02.0-x86_64-linux-ubuntu14
export PATH=/opt/Xilinx/Vivado/2018.3/bin:$PATH
export RISCV_PATH=/opt/riscv64-unknown-elf-gcc-8.2.0-2019.02.0-x86_64-linux-ubuntu14
export RISCV_OPENOCD_PATH=/opt/riscv-openocd-0.10.0-2019.02.0-x86_64-linux-ubuntu14
```

> 注意：配置路径视自身具体情况而定



#### 为 Olimex Jtag 指定udev规则

```shell
vi /etc/udev/rules.d/99-openocd.rules
添加以下两行：
SUBSYSTEM=="tty", ATTRS{idVendor}=="15ba",ATTRS{idProduct}=="002a", MODE="664", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="15ba",ATTR{idProduct}=="002a", MODE="664", GROUP="plugdev"
```



#### 为arty安装USB驱动Adept 2

从以下 网址 下载Adept 2 runtime 和 Utilities deb安装包 

https://reference.digilentinc.com/reference/software/adept/start

使用apt安装可解决依赖问题。

```
cd ~/Downloads
apt install ./*.deb
```



#### 下载Freedom与Freedom-e-sdk 源代码

````shell
git clone --recursive https://github.com/sifive/freedom
git clone --recursive https://github.com/sifive/freedom-e-sdk
````

如果国内下载比较慢的话，可以从以下镜像Git网址下载

https://gitee.com/organizations/cnrv-sifive

该源为国内CNRV团队在oschina上的同步镜像更新



### 二、生成mcs文件，编译固件并下载

#### 生成mcs

sifive 源代码主要由scala语言编写，bootrom由c语言编写。

故第一次进行生成的时候，程序会自动下载安装chisel。

需要确保当前系统已安装 openjdk-8-sdk、sbt等内容。

```shell
sudo apt install openjdk-8-sdk sbt
```

切换到 freedom 目录下,参数verilog用于将scala转换成verilog，参数mcs用于将生成的verilog转换成mcs

```
cd freedom
make BOARD=arty -f Makefile.e300artydevkit clean
make BOARD=arty -f Makefile.e300artydevkit verilog
make BOARD=arty -f Makefile.e300artydevkit mcs
```



#### 烧写FPGA固件MCS

打开vivado，在Flow中，打开Hardware Manager

![img](/post_res/2019-04-05-riscv-start-guide.assets/Vivado_Hardware.png) 

右键 xc7a35t，Add Configuration Memory Device ，选择`n25q128-3.3v-spi-x1_x2_x4 `

![img](/post_res/2019-04-05-riscv-start-guide.assets/Vivado_MemoryDevice.png) 

选择生成的mcs文件，勾选Erase、Program、Verify。



#### 编译下载固件

切换到克隆的freedom-e-sdk文件夹

```
cd freedom-e-sdk

make BSP=metal PROGRAM=hello TARGET=freedom-e310-arty clean
make BSP=metal PROGRAM=hello TARGET=freedom-e310-arty software
make BSP=metal PROGRAM=hello TARGET=freedom-e310-arty upload
```





