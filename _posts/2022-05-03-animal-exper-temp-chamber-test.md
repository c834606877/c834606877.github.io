---
layout: post
title: 一款小型哺乳动物仓笼体温监测与活动检测的装置以及部署方案

categories:
- 网络应用
- MCU

tags: [MCU, 生物实验]

author:
  login: lanbing
  email: c834606877@163.com
---


本方案使用物联网技术，通过高精度嵌入式红外摄像头，持续采集仓笼内热源信号，以及动物运动状态，使用嵌入式MCU对感知数据进行前端采集与简单分析，通过Wifi网络上传到数据中心，可形成数据汇总，采集时间跨度短可几周，长则跨年。装置。可按照需求，定制化按时按天按月或按年，生成可视化温度变化曲线，成本低廉，可供学术研究参考，或生物实验佐证使用。

单套设备仅需人民币300～500左右，约合美元60～80，成本低廉。对于单个仓笼，可同时部署多套设备，多套设备数据融合处理，以达到最佳采样角度，确保检测无死角。

方案包含完整装置采购清单，设备运行程序以及设备程序烧录指导，设备联网方法，现场部署指导等一系列指导文档，以及售后指导服务。

方案主体框架如下：

![system_flow](/post_res/2022-05-03-animal-exper-temp-chamber-test.assets/system_flow.png)



一些国内用户的使用范例：

![example_all](/post_res/2022-05-03-animal-exper-temp-chamber-test.assets/example_all.png)

![view_2](/post_res/2022-05-03-animal-exper-temp-chamber-test.assets/view_2.png)

![example_view](/post_res/2022-05-03-animal-exper-temp-chamber-test.assets/example_view.jpg)

类似竞品论文参考：

https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.3000406
http://journals.plos.org/plosbiology/article/asset?unique&id=info:doi/10.1371/journal.pbio.3000406.s014



合作洽谈可联系：iziy#mypre.cn / c834606877#163.com