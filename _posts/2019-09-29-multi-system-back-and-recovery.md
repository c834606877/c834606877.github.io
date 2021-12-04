---
layout: post
title: 一例多系统共存下的无陨迁移

categories:
- 系统应用


tags: [系统应用]

author:
  login: lanbing
  email: c834606877@163.com
---









四年前买的固态如今不知道什么原因，开机会有一定概率主板检测不到固态，需要多次重启才检测到。

然而最近这种情况概率越来越大了，于是决定换一块三星的，毕竟数据重要。现在的固态价格比起四年前大约降低了一倍多,可能是TLC技术的普及吧。



### 系统环境

原系统使用了128G固态msata接口＋500G机械，都使用的是GPT分区。原来加固态的时候就把机械上的Windows迁移到到固态，顺便把MBR分区转成了GPT，以兼容UEFI启动。

其中固态上为了三个分区，分别为（EFI分区，windows系统区，Ubuntu分区），机械硬盘5个分区，分别为（EFI分区，MacOS分区（原windows所在）以及D,E,F分区）

### 迁移环境

现在新换的固态为120G，原机械硬盘内容不动。需要将旧固态内容迁移到新固态。

<!--more-->

### 操作方法

笔记本只有一个msata接口和sata2.5坟硬盘接口。没有多余的位置可供盘对盘拷贝。且拷贝不能自身系统启动的过程中进行。

因此，在MacOS下使用dd命令将整块固态内容进行完整备份，存到机械硬盘上，这一步不能使用压缩。后续需要直接读取备份文件。

```
dd if=/dev/sda of=disk.bak
```



拆下原固态，换上新固态，同样使用DD命令，从备份文件恢复到新固态。

至此，新固态上的Windows可以直接开机了，dd命令可以完全恢复硬盘内容，包括分区表，当然包括分区信息和UUID。

### 遇到的问题

由于固态从大容量，迁移到小容量，需要对硬盘空间少了几个g，dd命令进行恢复后，EFI和windows分区处在固态的前一部分，而处理固态后部分的Ubuntu分区，少恢复了几个g，导致分区表中对Ubuntu分区的分区信息错乱，比如分区表中的对分区记录的分区结束扇区指向为原固态的最后一个扇区，而新固态没有这么多盲区，导致分区表3的尾部盲区指针发生指向错误。



然而Grub还是好用的，通过Grub引导Ubuntu Live iso进入

使用`sudo fdisk -l `查看分区表信息，fdisk无法直接修改分区表具体参数， 但可以通过删除分区和创建分区进行修改，将第三个分区删除，并创建一个新分区，分区起始扇区为原来起始盲区，分区结束扇区为固态最后一个扇区。w保存并退出。

由于ext4文件系统中的superblock同样存储了分区的扇区信息，对此，通过`fsck`进行修复，然而，由于少了几个g的存储空间，必定存在内容丢失的情况。因此，此方法并不可取，遂将分区重新格式化。



考虑挂载disk.bak，通过cp命令对整个系统进行拷贝。

挂载disk.bak方法为：

```
sudo kpartx -a disk.bak
sudo mount /dev/mapper/loop1p3 /mount/sda3 -o loop,ro
```



拷贝之后，修改`/etc/fstab`中,根分区的UUID,以及grub.cfg中修改ubuntu启动分区和内核ROOT启动参数。



### 注意

一、Ubuntu Live iso与disk.bak文件不能在同一个分区下，否则由于grub的iso的挂载机制，导致无法访问iso所在分区。

二、cp命令拷贝整个分区时， 需要加-a选项，完整拷贝文件包括标签，修改日期，所有者和权限。