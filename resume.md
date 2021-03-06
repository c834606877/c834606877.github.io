---
layout: resume
permalink: /resume/
title: 陈子炎
subtitle: 华东师范大学/硕士/在读/嵌入式/C
---

# 联系方式

- 手机：180-1859-1659
- Email: iziy【AT】MyPre.Cn
- QQ: 834606877

----


# 个人信息

- 陈子炎 / 男 / 1995
- 硕士/在读/华东师范大学/计算机技术
- 研究生导师：沈建华
- 技术博客: MyPre.Cn
- 期望方向：嵌入式，FPGA，安全

----

# 技术项目

__研究生__：

- 基于Cotex-M4F处理器核的语音唤醒系统【包括训练、设备端实现】

  - 系统使用MFCC做为特征向量输入，DNN做为识别模型，使用tensorflow进行模型训练, 并在Cotex-M4F 200Mhz处理器核上面运行。
  - 系统tensorflow测试正向样本识别率为91%左右，每100小时误唤醒20次左右。
  - 模型经过量化，在实机测试正向样本识别率为87%左右，每100小时误唤醒60次左右。

- 基于RISC-V处理器核的语音唤醒混合架构研究与实现【毕业论文】

  - 在Arty-35T FPGA开发板上跑通RocketChip的RISC-V核并利用ROCC接口开发FFT，矩阵处理硬件加速模块。
  - 并将嵌入式唤醒词系统整合到FPGA上。

- 在Cotex-M架构中移植WebRTC音频相关算法：VAD、Noise Suppression、AEC。
- 在类树莓派上实现6麦阵列DoA(声源定位)算法
- 在Cotex-M架构上实现声波配网
- 在Cotex-M实现特定人关键词识别（MFCC+DTW）
- 在968e指令集处理器上实现PWM低音质语音输出
- 在stm32上编写一些简单的I2C驱动。
- 在RealTek BLE芯片上开发灯控应用。
- 基于CC3220的会议记录系统【设备端本地采集处理上传】

- 安全逆向相关：利用iOS 11.4.1下实现非越狱状态的触屏控制（SandBox Escape）。


- 目前正在做：高音质低成本MP3播放器（Layout调试阶段）

__本科__：

- 基于MODBUS协议的漏液检测管理系统（Flask）
- 基于STM32 F103的机械键盘主控制器（AD）
- 使用MFC编写校园宽带拨号上网客户端绿色版（解决免费Wifi）
- 校园视频下载器
- 编写简单Apk伪装校园宽带心跳检测（解决校园网路由器屏蔽）
- 本博客的重新搭建（Jekyll）

更多技术内容请浏览我的个人博客：『MyPre.Cn』

----


# 在学经历

__2017,10 ~ 2018,03__

1. 学习MSP432嵌入式芯片以及相关外设，结合PC机，实现了一个音频频域分析器。
   将MSP432外接一个话筒，ADC取得音频PCM，在MSP432上运行FFT算法。定义一个简单的串口协议与PC机连接。
   使用Python的Tkinter库绘图，实时展示频域分析结果。
2. 参加校CTF竞赛以及全国研究生信息安全竞赛并获奖。

__2018,04 ~ 2018,07__

1. 学习语音处理相关基础知识，在一个ST的芯片上实现一些语音处理基本算法。
2. 学习尝试学习相关例程与基本原理。
3. 学习CC3220 WIFI MCU，并基于该MCU开发一个会务记录系统的固件端。
   通过定义两个简单的TCP协议流，控制流与语音流，MCU采集本地音频信号，并上传到Web服务器后台。
   该项目参加了全国大学生物联网竞赛并获得全国一等奖。

__2018,07 ~ 2018,09__

1. 在上海庆科信息技术有限公司实习
   负责为故事机产品（180Mhz主频，Cotex-m4f）研发唤醒词功能包括测试。 负责为故事机产品开发声波配网功能，通过声音传输WiFi连接认证数据。 移植amr，speex编码解码库。
   开发一个可用于收集唤醒词的微信小程序及其接收后端（FLask）。
   以上功能均在其公版固件中上线使用，独立完成。 

__2018,09 ~ 2019,08__

1. 研究RiscV处理器核，在Arty-35T FPGA开发板上跑通RiscV RocketChip以及ROCC和FFT DSP。
   一些学习经历在博客中有提及。
2. 为庆科公司继续提供一些研发性工作的支持，比如一种超低成本的PWM语音实现等。
3. 基于RealTek的AmebaD芯片开发一些语音处理的工具。

__2019,12 ~ 2020,05__

在腾讯（北京）玄武实验室 前沿智能硬件安全研究 实习

1. 智能硬件相关的Root技术研究

2. 保密项目

   

----

# 技能清单

以下均为我在校期间了解并使用过的技能（熟悉程度由前到后）

- 编程语言：C / Python / C++ / scala
- Web开发： Flask / Bootstrap / Jekyll
- 数据库：SQLite / SQLAlchemy(ORMs)
- 操作系统： Ubuntu / ArchLinux / Centos 
- 安全：OD / IDA / x64dbg
- AI：Tensorflow
- MCU：STM32-f103 f412 TI-CC3220SF MSP432 AmebaD ARM968-E

----

# 在校情况

__研究生__:
1. 获“嘉韦思杯”华东师范大学首届网络安全夺旗赛（CTF）一等奖
2. 获首届全国研究生信息安全与对抗技术竞赛 （ISCC）全国 三等奖
3. 获第三届全国研究生信息安全与对抗技术竞赛 （ISCC）全国 二等奖
4. 获2018年全国大学生物联网设计竞赛(TI杯)  华东赛区 一等奖
5. 获2018年全国大学生物联网设计竞赛(TI杯)  全国一等奖
6. 获2019年全国大学生物联网设计竞赛(华为杯)  华东赛区 一等奖
7. 获2019年全国大学生物联网设计竞赛(华为杯) 全国二等奖
8. 获华东师范大学"优秀学生"“优秀毕业生”荣誉称号
9. 获华东师范大学志愿者服务证书


__本科__：

1. 获全国大学生信息素养大赛  全国二等奖  两次
2. 获 南昌工程学院 软件设计大赛 一等奖 
3. 获 软件资格证书 软件设计师 中级
4. 校科技创新单项奖 / 四次奖学金奖励 / 专业课成绩优秀
5. 分别在三个校学生部门担任学生干部两年、一年、半年
6. 优秀学生干部，三好学生等等 

更多内容请浏览我的个人博客：『MyPre.Cn』

此简历于 _2020/5/14_ 最后更新。




### you can contact me by the way of below:
<hr>

>
> 电子邮件：iziy【AT】mypre.cn
>
> 联系电话：15979400947
>
> QQ：834606877 
>
> 新浪微博：http://weibo.com/u/2717952951
>
> Home：江西省萍乡市
>
> For Now：ShangHai
