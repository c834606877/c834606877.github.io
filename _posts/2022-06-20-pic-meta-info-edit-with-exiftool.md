---
layout: post
title: 图片伪造技术 - 使用exiftool对图片描述信息进行增删查改

categories:
- 应用技巧
- 网络应用



tags: [应用技巧, 网络应用]

author:
  login: lanbing
  email: c834606877@163.com
---





通常，一张图片本身包含其所应该包括的图像像素内容以外，还包含了很多其它描述该图片元信息，比如图片大小，图片拍摄设备，拍摄时间，焦距，地理位置等，若经过中间处理，还可能包含剪辑软件名称，版本号，版权等信息。

图片在互联网上转发的过程中，也可能经过服务器的有陨/无损压缩，格式转换，大小裁剪，水印添加。根据服务器所使用的不同处理程序也有可能对元数据进行增删改等操作。

因此简单通过分析图片的元数据可以获得除本身所能代表的信息以外，还可能可以初步确定图片是否直接来自于手机或相机拍摄，是否经过修改之类。

exIftool是一个功能强大的命令行执行工具，exiftool.org，支持对大量常见的图片格式进行操作。具体信息见其官方网站说明。

一张经过ps处理的图片文件头如下：

![1_raw_meta_info_ps_processed](/post_res/2022-06-20-pic-meta-info-edit-with-exiftool.assets/1_raw_meta_info_ps_processed.png)


<!--more-->


一张原始手机拍摄图片的元信息如下：

![2_raw_meta_info_photo](/post_res/2022-06-20-pic-meta-info-edit-with-exiftool.assets/2_raw_meta_info_photo.png)



通过exIftool可能查看完整信息：

```
LandeMBP:Downloads lanbing$ exiftool -t IMG_20220616_210608_3.jpg
ExifTool Version Number 12.42
File Name   IMG_20220616_210608_3.jpg
Directory   .
File Size   1301 kB
File Modification Date/Time   2022:06:16 23:41:54+08:00
File Access Date/Time   2022:06:16 23:41:55+08:00
File Inode Change Date/Time   2022:06:16 23:41:54+08:00
File Permissions  -rw-r--r--
File Type   JPEG
File Type Extension  jpg
MIME Type   image/jpeg
JFIF Version   1.02
Exif Byte Order   Big-endian (Motorola, MM)
Make  HUAWEI
Camera Model Name ELE-AL00
Orientation Unknown (0)
X Resolution   72
Y Resolution   72
Resolution Unit   inches
Software ELE-AL00 10.0.0.195(C00E85R2P11)
Modify Date 2022:06:16 21:06:10
Y Cb Cr Positioning  Centered
Exposure Time  1/100
F Number 1.8
Exposure Program  Program AE
ISO   80
Exif Version   0210
Date/Time Original   2022:06:16 21:06:10
Create Date 2022:06:16 21:06:10
Components Configuration   Y, Cb, Cr, -
Shutter Speed Value  1/999963296
Aperture Value 1.8
Brightness Value  0
Exposure Compensation   0
Max Aperture Value   1.8
Metering Mode  Multi-segment
Light Source   Daylight
Focal Length   5.6 mm
Maker Note Unknown Text ##**qrf
Sub Sec Time   559638
Sub Sec Time Original   559638
Sub Sec Time Digitized  559638
Flashpix Version  0100
Color Space sRGB
Exif Image Width  2736
Exif Image Height 3648
Sensing Method One-chip color area
File Source Digital Camera
Scene Type  Directly photographed
Custom Rendered   Custom
Exposure Mode  Auto
White Balance  Auto
Digital Zoom Ratio   1
Focal Length In 35mm Format   27 mm
Scene Capture Type   Standard
Gain Control   None
Contrast Normal
Saturation  Normal
Sharpness   Normal
Subject Distance Range  Unknown
GPS Version ID 2.2.0.0
GPS Latitude Ref  North
GPS Longitude Ref East
GPS Altitude Ref  Below Sea Level
GPS Time Stamp 13:06:08

```

以下是一些简单exiftool应用命令：


```
copy某文件的TAG信息到别一文件：
exiftool --TAG -TagsFromFile src.jpg desc.jpg

移除文件所有元信息：
exiftool -all= -CommonIFD0= --icc_profile:all target.jpg

移除文件xmp元信息：
exiftool -xmp:all= IMG_20220616_210608_3.jpg
```




