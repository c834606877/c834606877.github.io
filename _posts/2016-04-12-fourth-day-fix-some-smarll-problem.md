---
layout: post
title: The Fourth Day, fix some small bugs
tags:  [jekyll,MyPress,iziy]
categories: [本博动态]
author: LanBing
---

### 第四天

修改了Blog一些细节，还修补一些代码逻辑Bug，
Jplayer 循环播放页面音乐，
Sidebar滚动固定box 单个box
附着在jquery元素里边的对象在使用 jquery.clone 时，对象并不会clone，
导致jplayer fixed box 里边的元素按钮没有反应，

另外 Gallery.html 下竟然在输出内容时还有使用 <code>{% raw %}{{content}}{% endraw %}</code>的，
忘记了 <code>{% raw %}{{content}}{% endraw %}</code> 和 <code>{% raw %}{{content}}{% endraw %}</code>的使用了

之前由于没有分清 这两变量，导致 内容，死循环 输出，或者无内容输出，花了一个多小时，
<!--more-->

### Blog 小记
===

还是调试技巧没有掌握，碰到花费太多时间的Bug，还不如整理思路，重写一遍代码来的快了。

至此，花了四天的时间将Blog成功转化为静态，以及功能的增加，
接下来就是找个好用的 Markdown Tool 安静的Log My Press 了。

===

能有如此效率还是归功于Jekyll功劳，
[Jekyll](http://www.jekyllrb.com/) 的 Free 精神，GNU 理念，
组件的专一性与复用性，不用重新造轮子，
节省了大量处理代码逻辑的时间，以及额外的学习成本，



