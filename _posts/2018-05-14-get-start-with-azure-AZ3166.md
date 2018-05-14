---
layout: post
title: 在学习AZ3166碰到的一些常见问题，贴出来以免新手再绕弯路。

categories:
- MCU

tags: [AZ3166, AZURE, MXCHIP]

author:
  login: lanbing
  email: c834606877@163.com

---



一、Mico开发环境的搭建
===

Mico开发环境由三部分组成，
1. Mico Cube ： 用于在命令行下对mico-os 编译链接下载，以及对mico-os进行版本管理的工具，
这是个python工具，所以需要使用`pip install mico-cube` 进行安装，并且需要在环境中安装git，以用于版本管理和os的import。

2. Micoder：用于编译链接的组件，提供的gcc、gdb等交叉编译调试工具链：
这个需要和mico Cube配合使用，下载解压后，
需要使用 `mico config --global micoder D:\MXCHIP\MiCO_SDK\MiCO\MiCoder `进行配置，使得mico可以调用micoder，进行编译，链接，下载。
否则会报错`[mico]: can not found micoder`

3. Micoder IDE：用于在图形环境下进行版本管理，开发，还可以进行调试。
需要java运行环境，并且设置好path系统环境参数。
在安装Micoder IDE时会自动附带安装一个mico-os的sdk，

二、AZ3166对应mico-os的配置
===

在你的项目文件夹下通过命令
mico import mico-demos 
从aliyun的git上下载一最新的demos和os

从eclipse中导入mico-demos，
右键根项目(`mico-demos`) `Team->Switch To->Other :  Remote Tracking->origin/experiment `
右键`mico-os`：`Team->Switch To->Other :  Remote Tracking->origin/mico-os-4.0`

三、Build Targets 
===

添加编译命令可编译运行下载：

````b
application.wifi_uart@AZ3166 total download run JTAG=stlink-v2-1
````



这里对解释一下编译命令：

@前面的部分代表要编译的程序所在文件夹，用`.`代替`\`表示文件目录的结构层次。

@后面的部分代表要编译使用的板子库型号。



最后，Eclipse IDE，会组合成命令：

```
mico make application.wifi_uart@AZ3166 total download run JTAG=stlink-v2-1
```

并在因为只有在根目录中，才能同时相对的找到mico-os和其相关的库文件和程序，否则会报找不到mico-os等等编译错误。



四、添加AZ3166驱动组件
===

在一个现有的MiCO项目中添加AZ3166组件，并运行附带的示例程序。在进行以下操作之前，先确保MiCO Cude已经正确安装。
导入AZ3166组件

    进入一个MiCO项目的根目录，例如：cd helloworld。（如果本地没有现成的MiCO项目，可以使用mico new xxx创建一个项目,或者使用mico import xxx从版本库导入一个项目），
    执行指令：mico add https://code.aliyun.com/mico/drv_AZ3166.git，从远程版本库中下载组件并且添加到当前项目。

运行AZ3166示例

1.组件中内置示例程序：drv_AZ3166/demo，执行编译命令。

例如在MXCHIP Microsoft Azure IoT Developer Kit平台AZ3166上：

```  
mico make drv_AZ3166.demo@AZ3166@RTX total download JTAG=stlink-v2-1 run
```

详细的编译选项参考MiCO Cude

2.程序运行后，在设备OLED显示屏上显示传感器信息，并且在设备串口终端上显示传感器信息，例如：

```
50885 humidity = 52.90%, temp = 31.30C
50892 magnet =     84,    193,   -207
50899 lps22hb tmep = 32.00C, press = 1010.00hPa
50907 LSM6DSL [acc/mg]:       26,    -104,    1011
50915 LSM6DSL [gyro/mdps]:        0,   -1680,    1260

```


