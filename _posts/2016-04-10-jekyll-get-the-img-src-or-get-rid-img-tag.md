---
layout: post
title: 提取一篇文章里边的 图片链接，以及除去文章里边的 img 标签
date: 2016-04-10
type: audio
published: true
status: publish
categories:
- jekyll
tags: [jekyll]
meta:
  _edit_last: '1'
  views: '8'
author:
  login: lanbing
  email: c834606877@163.com
  display_name: lanbing

---


从接触 Jekyll 到现在有两整天了

发现 Jekyll 对逻辑处理方面不太善长，许是我没有认真去了解吧，

plugin 也许是很强大的东西 ， 虽然不会ruby，但是因为对python的熟悉，还是有很大的帮助的，

之后打算结合国内七牛CDN对资源加速，估计要用到 plugin 希望ruby的语法对新手的亲和度不会让我太失望。

因为 原主题支持不同类型的Post，所以 对Jekyll也想实现这个功能，

做 完了标准的Post 接下来该做 Gallery 了
碰到的问题是，该如何提取Post文章里边的 img 中的src 以及如何 去除 文章里边的img

因为要挪动IMG的位置到文章最前面

因此记下方法
去除 img 标签 如下：

<pre>
{% raw %}
{% for sp in content | split:"<img "%}
    {% for con in sp | split:">" %}
        {% if con contains 'src="' or con contains "src='" %}
        {% else %}
          {% if con contains "href=" %}
            {{con}}>
          {% else %}
            {{con}}
          {% endif %}
        {% endif %}
    {% endfor %}
{% endfor %}
{% endraw %}
</pre>

去除 IMG 方法就是 按 <img 以及 > 切割 除去 含有 src 属性的 项 
剩下的 对 因为 > 切割 破坏的a 标签 补上 >
<!--more-->
对 提取 img 标签 如下：
{% raw %}
<pre>
{% assign images = content | split:"<img " %}
{% for image in images %}
    {% assign html = image | split:">" | first %}
    {% assign tags = html | split:" " %}
    {% for tag in tags %}
      {% if tag contains 'src="' or tag contains "src='" %}
          {% assign src = tag | split: '"' | last%}
          &lt;li data-thumb="{{src}}">&lt;img src="{{src}}" title="{{page.title| strip_newlines}}" alt="{{page.title| strip_newlines}}"/></li>
      {% endif %}
    {% endfor %}
{% endfor %}
</pre>
{% endraw %}
取出 img 标签 里边的 属性组 对src 属性 按 ‘“’ 分割， 
注意 此处不能用＝号分割 ， 因为 图片链接当中有可能有＝号
