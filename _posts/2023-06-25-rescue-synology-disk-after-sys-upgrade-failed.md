---
layout: post
title: 记一次黑群晖系统升级失败之后的数据恢复

categories:
- Linux
- 系统应用



tags: [Linux, 系统应用, Synology, 群晖系统]

author:
  login: lanbing
  email: c834606877@163.com
---



> 最近折腾了一下群晖系统的硬盘休眠, 由于不小心动到了硬盘的RAID设置, 导致系统认定系统盘和数据盘中的系统出现了diverge. 重启之后, 提示需要重装安装系统, 重装失败后系统丢失.

群晖系统要求的重装安装时,操作界面给出了两个选项: 迁移和重新安装.

![群晖崩溃出现的安装界面](/post_res/2023-06-25-rescue-synology-disk-after-sys-upgrade-failed.assets/1593233577-3809f6746ce8618.jpg)

> 虽然都提示*数据不会改动*, 因此没有太在意细节 . 而不小心点到了重新安装, 并且选到了自动更新,(没有手动从官网下载安装包), 没想到安装包没自动下载成功, 直接就安装失败了. 当时也没管,直接强制断电关机睡觉了(这也许是最好的保护软件损毁数据的方法), (原本只需抹去并从启动盘中重新sync一份系统到数据盘, 现在事情弄复杂了.)
>
> 第二天起来,发现惊奇的是, 群晖已经将所有系统整个/dev/dm0格式化了.. 
> 格式化这种敏感的操作, 居然不是放在最后等必要条件准备就绪才做. 这波操作让人着迷, 恐怕只有印度小伙能干出来.



Linux数据救援不同于win平台使用PE, 搜寻了一蕃LiveCD的解决方案, systemrescue(https://www.system-rescue.org/) 看起来可以不错,后续使用过程中也都满足了需求,.

基本的disk io操作工具都有,包括testdisk, photorec, parted, mdadm, cifs. 

注意: Ubuntu的server版liveCD似乎由于内核没有编译RAID模块, 无法操作raid分区, 已踩坑,不建议用作数据救援.


<!--more-->


##正文:

整个硬盘有系统盘和数据盘两块硬盘, 系统盘剩余空间做了数据用.在没有格式化之前系统盘SSD的分区layout是这样子的, 所有硬盘前两个分区分别为synology的system和swap分区, 分区大小一致. 系统盘除了sys/swap分区还有2个启动引导分区(ESP/FAT16)和1个数据分区(挂载到了/dev/DM3)

```bash
lanbing$ sudo gpt -r show /dev/disk3
     start      size  index  contents
         0         1         PMBR
         1         1         Pri GPT header
         2        32         Pri GPT table
        34      2014         
      2048   4980480      1  GPT part - A19D880F-05FC-4D3B-A006-743F0F84911E
   4982528   4194304      2  GPT part - A19D880F-05FC-4D3B-A006-743F0F84911E
   9176832     68736         
   9245568     40960      3  GPT part - C12A7328-F81F-11D2-BA4B-00A0C93EC93B
   9286528     81920      4  GPT part - 142F5F5D-B9E5-4433-87C0-68B6B72699C7
   9368448     68736         
   9437184  70903816      5  GPT part - A19D880F-05FC-4D3B-A006-743F0F84911E
.....      
 110485727        32         Sec GPT table
 110485759         1         Sec GPT header

lanbing$ sudo fdisk -l 
...
  /dev/disk3 (disk image):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        +5.4 GB     disk3
   1:                 Linux_RAID                         2.6 GB     disk3s1
   2:                 Linux_RAID                         2.1 GB     disk3s2
   3:                        EFI NO NAME                 21.0 MB    disk3s3
   4: 142F5F5D-B9E5-4433-87C0-68B6B72699C7               41.9 MB    disk3s4
   5:                 Linux_RAID                         38.3 GB   disk3s5
```

而被格式化之后, 现在系统盘只剩下system/swap分区 其它空间为free/状态. 数据盘的分区表还在, 但系统分区内容也已被清空空. 

```bash
lanbing$ sudo gpt -r show /dev/disk3
     start      size  index  contents
         0         1         PMBR
         1         1         Pri GPT header
         2        32         Pri GPT table
        34      2014         
      2048   4980480      1  GPT part - A19D880F-05FC-4D3B-A006-743F0F84911E
   4982528   4194304      2  GPT part - A19D880F-05FC-4D3B-A006-743F0F84911E
```




#### 备份

目前有一块2t SSD空间可以用来做全盘备份. 

备份方法, 全盘备份可以用dd.  注意, 不要使用gz, 或tar, 而是使用xz压缩, 如果真的用上了backup,那么结合nbd client/server可以实现decompress on the fly, 参考 [https://unix.stackexchange.com/questions/31669/is-it-possible-to-mount-a-gzip-compressed-dd-image-on-the-fly]

```bash
挂载samba备份目录
[root@sysrescue ~]# mount -t cifs -o username=lanbing //192.168.123.166/nas_bak /mnt/nas_bak/
Password for lanbing@//192.168.123.166/nas_bak: 


[root@sysrescue /mnt/nas_bak]# dd if=/dev/sdb bs=4MiB status=progress | xz -0 --threads=4 --block-size=4MiB --check=crc32  > sdb_full_raw_Block4MiB_-0-thread4.img.xz
328837627904 bytes (329 GB, 306 GiB) copied, 44534 s, 7.4 MB/s
562762350592 bytes (563 GB, 524 GiB) copied, 76977 s, 7.3 MB/s
705729396736 bytes (706 GB, 657 GiB) copied, 96124 s, 7.3 MB/s
780731940864 bytes (781 GB, 727 GiB) copied, 105951 s, 7.4 MB/s
799388205056 bytes (799 GB, 744 GiB) copied, 108518 s, 7.4 MB/s
800344506368 bytes (800 GB, 745 GiB) copied, 108636 s, 7.4 MB/s
874453663744 bytes (874 GB, 814 GiB) copied, 118417 s, 7.4 MB/s
934025363456 bytes (934 GB, 870 GiB) copied, 126278 s, 7.4 MB/s
949103886336 bytes (949 GB, 884 GiB) copied, 128327 s, 7.4 MB/s
965440700416 bytes (965 GB, 899 GiB) copied, 130582 s, 7.4 MB/s
971669241856 bytes (972 GB, 905 GiB) copied, 131489 s, 7.4 MB/s
972730400768 bytes (973 GB, 906 GiB) copied, 131654 s, 7.4 MB/s
984688361472 bytes (985 GB, 917 GiB) copied, 133392 s, 7.4 MB/s
991944507392 bytes (992 GB, 924 GiB) copied, 134390 s, 7.4 MB/s
1316285841408 bytes (1.3 TB, 1.2 TiB) copied, 153846 s, 8.6 MB/s 
3000533778432 bytes (3.0 TB, 2.7 TiB) copied, 167043 s, 18.0 MB/s
715397+1 records in
715397+1 records out
3000592982016 bytes (3.0 TB, 2.7 TiB) copied, 167044 s, 18.0 MB/s
```

备份过程历时两天..

#### 操作

首先使用testdisk 检测分区, 全盘检测之后, testdisk可以识别出系统盘中两个被抹去和一个数据分区.

分区表得以被重建. 并且通过恢复photorec可以恢复大部分系统分区的文件, 但是会丢失文件名.

似乎将ext4格式化成ext4后, backup的superblock的位置是相同的. 因此所有的superblock似乎全被replaced. 这点待确认.

之后,使用`mdadm -AsR` 可以扫描并自动组建raid盘. 数据分区确实没有丢失.

重装系统后, synology可以识别到两盘中的数据区内容.

然而在群晖的系统 web中显示硬盘已损毁(Crashed), 但数据内容还可以读取, mdadm -D显示存在Fault

```bash

admin@LanBingDisk:~$ cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
md3 : active raid1 sdh3[0]
      2925444544 blocks super 1.2 [1/1] [U]
      
md2 : active raid1 sdb5[0](E)
      35450880 blocks super 1.2 [1/1] [E]
      
md1 : active raid1 sdb2[0] sdh2[1]
      2097088 blocks [16/2] [UU______________]
      
md0 : active raid1 sdb1[0]
      2490176 blocks [16/1] [U_______________]
      
unused devices: <none>
admin@LanBingDisk:~$ sudo mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Mon Aug  8 12:01:00 2022
     Raid Level : raid1
     Array Size : 35450880 (33.81 GiB 36.30 GB)
  Used Dev Size : 35450880 (33.81 GiB 36.30 GB)
   Raid Devices : 1
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Mon Jun 19 18:12:45 2023
          State : clean, FAILED 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : LanBingDisk:2  (local to host LanBingDisk)
           UUID : 1730721b:cf36f199:1ddec39d:c541e0dd
         Events : 45

    Number   Major   Minor   RaidDevice State
       0       8       21        0      faulty active sync   /dev/sdb5
```

可以确定的是,磁盘并没有真正存在物理损毁. 而dmesg显示磁盘读取越界

```bash
[   44.037139] md: bind<sdb5>
[   44.039696] md/raid1:md2: active with 1 out of 1 mirrors
[   44.040566] md2: detected capacity change from 0 to 36301701120
[   44.082183] attempt to access beyond end of device
[   44.082190] sdb5: rw=0, want=70903688, limit=70901768
[   44.082196] md_error: sdb5 is being to be set faulty
[   44.082223] attempt to access beyond end of device
[   44.082227] sdb5: rw=0, want=70903688, limit=70901768
[   44.082230] md_error: sdb5 is being to be set faulty
```

io跑飞了, 原因大概是testdisk并没有正确的判断出sdb5的分区大小.

通过阅读linux的raid模块的源码, raid分区大小至少应该为`max(AvailDevSize,UsedDevSize) + DataOffset  ` 个sectors.  貌似通常`AvailDevSize==UsedDevSize`然而因为分区大小的问题,两者会出现不相等的情况.

遂重新进入LiveCD, 增大分区大小, 重启进synology后,问题依旧 但dmesg已经没有report io跑飞的问题.

然而,`mdadm -D` 结果仍然显示存在Fault.

通过查阅, 原来RAID中的faulty状态不仅存在于内核内存还存在于disk中raid partition的superblock(metadata)中.

mdadm 提供了为disk设置faulty状态的功能, 但没有提供清除faulty状态. 而faulty状态是因为partition size设置不对引起的, 并不是真正在的物理错误.   而按照群晖的提示, 需要删除硬盘重新添加...

一种比较危险的方法是删除raid后, 重新从disk创建raid阵列, 并且通过option强制raid忽略faulty状态...

可能会有数据丢失的风险. 不过亲测有效.

https://serverfault.com/questions/495392/remove-faulty-state-in-raid-1



```
admin@LanBingDisk:/$ sudo umount /volume1
admin@LanBingDisk:/$ sudo mdadm -S /dev/md2
mdadm: stopped /dev/md2
admin@LanBingDisk:/$ sudo mdadm --create --assume-clean --level=1 --force --raid-devices=1 /dev/md2 /dev/sdb5 
mdadm: /dev/sdb5 appears to be part of a raid array:
       level=raid1 devices=1 ctime=Mon Aug  8 12:01:00 2022
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md2 started.
admin@LanBingDisk:/$ sudo mount /dev/md2 /volume1/
admin@LanBingDisk:/$ ls /volume1/
@appstore     @database  @eaDir  photo                     surveillance                 @synologydrive           @tmp
aquota.group  docker     homes   @pkg-SynologyMom.core.gz  @surveillance                @SynologyDriveShareSync  video
aquota.user   @docker    music   @S2S                      @SynologyApplicationService  synoquota.db   
```

Synology Web 报告系统已经恢复, 但是数据盘系统不存在,需要修复. 点击修复即可. 

这点暂时不修复,这样不会使得var/log目录被频繁写入日志而影响机械盘休眠.

### 结论

如果系统崩溃不可避免,那么掌握一些数据恢复的技巧,是对抗数据丢失的最好的方式. 

此外, 在通用的计算机系统概念中, 一个正在使用过程中的系统分区是无法直接格式化的.

可能群晖的kernel/init过程检测到了系统异常后,没有从正常路径启动系统. 而是进入了可以运行在RAM的recovery模式. 而在recovery模式下,安装条件还没有完全满足时, 就已经将dm0格式化, 并且用户主动断电,造成系统盘失效.

显然这不是一个stat-of-art的设计,因为没有考虑到在系统升级的过程中可能发生的异常. 这不仅造成了自己的不便,还提高的自己的售后成本.

一来架构设计迁就了底层技术架构(可能是群晖的设计思想), 二来负责技术开发过程的工程师没有足够的风险意识.


关于Linux/Raid的文章目前比较少,加之多数文章年代久远,很多文章也已经过时. 

后续有空再详细分析一下Linux/Raid本身的运行机制,概念,以及相关的操作工具,常见问题等等.

