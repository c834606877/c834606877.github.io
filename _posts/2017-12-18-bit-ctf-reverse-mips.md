---
layout: post
title: 北理研究生CTF Reverse 之 mips

categories:
- CTF
- 逆向

tags: [ECNU, BIT, Reverse]

author:
  login: lanbing
  email: c834606877@163.com
---



这次北理面向在读研究生举办CTF大赛，直接线下赛，时长12小时，其中选择填空1小时，关卡题2小时（之后加时2小时），9小时攻防，攻防赛题在先知安全有提到。

由于第一届，邀请的学校队伍属于中等偏下水平。最后，24支队伍只有9个分数为正，另有近一半左右队伍线下攻防没有拿分。

主办方声称原则上不提供外网环境。

逆向题只有一道，而且为mips架构第一次遇到。手上没有运行环境，只能静态调，花了一个多小时才搞清楚流程，之后时间不够只能做罢，后来发现当场也没有人做出。

赛后再分析一遍其实还是挺简单的。


先附上解密代码，回舍，日后有时间再补。

程序： [mips](/post_res/ctf_bit_wp/mips)

![gdb-reverse-key](/post_res/ctf_bit_wp/bit-ctf-reverse-mips-1.png)


```c
#include <stdint.h>
#include <stdio.h>


void dec(uint32_t *val, uint32_t *k)
{
	uint32_t delta = 0x9e3779B9;
	uint32_t sum = 0xb8ab04e8;
	uint32_t v1 = val[1], v0=val[0];
	for(int i = 0; i < 40; i++)
	{
		v1 -= ((v0 << 4 ^ v0 >> 5) + v0) ^ (sum + k[(sum >> 11) & 3]);
		sum -= delta;
		v0 -= ((v1 << 4 ^ v1 >> 5) + v1) ^ (sum + k[sum & 3]);
	}
	printf("0x%x~~~\n", sum);
	val[0] = v0;
	val[1] = v1;

	return ;

}
int main()
{
	uint32_t key[4]={
		0x2bc12411, 0x0deadbee, 0x0276630b, 0x014f53f5
		};
	uint32_t value[]={
		0x9a5e3731, 0x2ed28785,
		0xeb26da7d, 0x82b06241,
		0x21d9dcd4, 0x44bdda49,
		0x15f62308, 0x7b0546ee,
		0xf6b4a519, 0x71c0d531
		};
	for(int i =0; i< 10; i+=2)
	{
		dec(&value[i],key);
	}
	printf("%s\n", value);
	//printf("0x%8x, 0x%8x\n", value[0], value[1]);
	return 0;
	
}

```