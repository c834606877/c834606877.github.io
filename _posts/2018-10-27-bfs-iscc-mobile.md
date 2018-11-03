---
layout: post
title: bfs-iscc 2018 Mobile 分析

categories:
- Android


tags: [Android]

author:
  login: lanbing
  email: c834606877@163.com
---



题目是上上周末，同学发来的，当时分析了一阵，没有出最终结果。

直到上周末，才将关键加密部分，分析出来。

今天将分析过程记录于此。



### 一、前言



安卓的题目，多少会结合jni来个so，或者动态载入dex，再加一些加密手段，隐藏入口等等，本题目基本都调试方法都涉及到了。

但是，就单单解题来说，掌握一些常用的调试方法，逆向基础不弱，通过勤加苦练，也是可以在赛场上取得好成绩的。如今安全意识的普及，现实情况下，app多数会进行代码混淆，甚至不惜性能加个比较复杂的vm壳。



本题前后总共花有差不多15个小时的时间，但难度不高，层层剥壳，均有迹可寻。



### 二、程序信息

```
程序名：signed.apk
md5：56de5d88051a6f44d0e83e843172a6f9
sha1：084f1b51f8ac3b167b748ac24c474a00688c5652
大小：2.79 MB
```

下载地址：[点击下载](/post_res/2018-10-27-bfs-iscc-mobile.assets/signed.apk)

信息如下：

![1540645435208](/post_res/2018-10-27-bfs-iscc-mobile.assets/1540645435208.png)


<!--more-->


### 三、程序入口

通过APKIDE工具，很方便的将apk，解析出来。

app主要内容结构如下:

![1540645645377](/post_res/2018-10-27-bfs-iscc-mobile.assets/1540645645377.png)

关键文件有：`libcore.so`，`libreinforce.so`，`protected.jar`

从Manifest文件找到，主要启动类为`WrapperApplication`，而此类，只做了一件事情。就是加载`libreinforce.so`。

因此，通过IDA，查看此lib的行为如下。

![1540647448260](/post_res/2018-10-27-bfs-iscc-mobile.assets/1540647448260.png)

动态载入libcore.so，并且调用了一个名为resume的方法。

以及如下程序段，

![1540646262930](/post_res/2018-10-27-bfs-iscc-mobile.assets/1540646262930.png)

主要流程有：

1、读取asset中的protected.jar

2、解密protected.jar为origin.dex

3、加载此dex。

解密函数实现很简单，就按位取反。

因此，得到了一个主要的dex文件。

将此dex拖入jd工具中：

![1540644447469](/post_res/2018-10-27-bfs-iscc-mobile.assets/1540644447469.png)



这是一个校验程序，流程为：

1、获取输入字符串，长度为3的倍数。

2、进行加密变换。

3、将加密结果与`OYUGMCH>YWOCBXF))9/3)YYE`进行比较。

（有点像Hill加密）

本以为解密到此为止，没想到，作者将一个关键的加密函数进行了转移到了一个native实现中。

由于些lib之前调用了`libcore.so`的内容，猜测此函数的实现在另一动态库`libcore.so`中。



通过IDA逆向此`libcore.so`，找到resume函数的实现。如下：

![1540647733397](/post_res/2018-10-27-bfs-iscc-mobile.assets/1540647733397.png)

经过一番研究分析，发现些处使用了一个安卓的热补丁修复机制。

> 关于热补丁机制的描述是这样的：
>
> 在不进行版本更新的情况下，动态的屏蔽掉程序原来存在BUG的函数，使用新的函数替代。
>
> 新函数一般存在于另一个so中

热补丁的流程主要有：

```
1、通过函数名找到原来函数的地址偏移（ArtMethod->dex_code_item_offset_）。
2、将新函数地址偏移替换原函数地址偏移。
```

而上述程序也为类似主要流程如下：

```
1、分析安卓虚拟机为dalvik还是art，二者热补丁方式不一样。
2、解密解析补丁函数表(decryptAndParse)
3、执行补丁操作
```

在`decryptAndParse`函数中，对补丁表做了加10的操作，意为解密。

![1540648158699](/post_res/2018-10-27-bfs-iscc-mobile.assets/1540648158699.png)

通过分析`decryptAndParse`函数，可以发现

```
1Lcom/example/originapplication/ProtectedClass;getEncrypttext(Ljava/lang/String;)Ljava/lang/String;1416140
```

程序对上述提到的关键加密函数进行了热补丁，而新函数的位置为`1416140`，此位置为相对protect.dex的函数偏移。

因此，我们通过IDA，逆向此dex，跳转到1416140(159BCC)处。

![1540649092014](/post_res/2018-10-27-bfs-iscc-mobile.assets/1540649092014.png)

发现了函数的字节码，但IDA没有显示出此函数。

按照dalvik的官方beyecode表示方式，我们在IDA中手动转换代码块。

![1540649157192](/post_res/2018-10-27-bfs-iscc-mobile.assets/1540649157192.png)

得到了，加密函数的smali语法表示方法。

实际上，这是一种隐藏函数体的方法。

涉及到dex文件内容的具体编排方式了。

dex可以认为是一堆函数的集合，其中包含了涉及到的字符串，函数原型（函数签名），类定义，函数属性，偏移等等内容。

具体内容，详见google网站，对dex文件格式的具体描述。

我们找到dex文件中关于`ProtectedClass`类定义的部分

![1540649947157](/post_res/2018-10-27-bfs-iscc-mobile.assets/1540649947157.png)

类定义数据在偏移`0xa9db3`处：

![1540650019431](/post_res/2018-10-27-bfs-iscc-mobile.assets/1540650019431.png)



这部分包含了，类成员各种属性，有public private native static等等。

参考`getString`和`verifyKey`，将加密函数`getEncryptText`的属性改为`public static` ,并且重新计算相对偏移。

将修改后的dex再次载入jd工具。

![1540650501314](/post_res/2018-10-27-bfs-iscc-mobile.assets/1540650501314.png) 

此时，便可以正确的显示出，加密函数的内容了。

此加密为Hill加密，并且这是csdn中的一个例程。

参考地址: https://blog.csdn.net/qiyu93422/article/details/46942351

作者连变量名都没有改的直接将代码粘过来，修改的key数据。

但是作者对此Hill加密的机制好像并不熟悉，设置的key为非可逆数组。无法通过求逆运算，解出flag。

```
#include "stdio.h"
#include "string.h"

int key[][3] = {
	    {17, 12, 3},
		{21, 12, 9},
		{17, 14, 6}
};
char cytext[] = "OYUGMCH>YWOCBXF))9/3)YYE";

void get_dec_text(char *ct )
{
	int t1,t2,t3;
	for(char i='0'; i <='z'; i++)
		for(char j='0'; j <='z'; j++)

			for(char k='0'; k <='z'; k++)
			{
				t1 =(( key[0][0] * (i - 'A') + key[0][1]*(j - 'A') + key[0][2]*(k - 'A')  ) % 26) + 'A';
				t2 =(( key[1][0] * (i - 'A') + key[1][1]*(j - 'A') + key[1][2]*(k - 'A'))   % 26) + 'A';
				t3 =(( key[2][0] * (i - 'A') + key[2][1]*(j - 'A') + key[2][2]*(k - 'A') )  % 26 )+ 'A';
				if(ct[0] == t1 && ct[1] == t2 && ct[2] == t3)
				{
					printf("%c %c %c \n", i , j ,k);
				}
			}
    printf("-----------\n");
}
int main()
{
	for(int i=0; i < strlen(cytext); i+=3)
	{
		get_dec_text(&cytext[i]);
	}
	return ;
}
```



尝试使用暴力方法，每三个字母一组，但得出的匹配字符过多，无法进一步分析。

此题！无解！！！



### 四、总结

实际上在当天发现`getEncryptText`这个函数名的时候，因函数名相同，就发现了csdn关于Hill加密的例程。

使用其提供的解密算法解出flag不正确。但无法真正确定加密，只得接着分析。



此外，程序名为signed.apk，可以看出做了二次签名处理，因为在程序编译后是无法获得函数补丁表的。作者libcore.so库中的函数补丁表是在dex文件编译好后，重新计算函数地址，再填进表。





