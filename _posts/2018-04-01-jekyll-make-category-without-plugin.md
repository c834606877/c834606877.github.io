---
layout: post
title: Jekyll make post categoly without using plugin

categories:
- Linux
- 生活随笔
- 心情日记
tags: [心情日记，生活随笔]

author:
  login: lanbing
  email: c834606877@163.com
---



> 在CMS中，tag和categoly的实现方式虽大体相同，但功能和用途却不同。
>
> 而当前各种Pages服务仅支持有限的官方插件，自定义插件功能更是可望而不可及，要满足文章自动分类功能实在要用插件完成，之前一直通过本地生成jekyll的方式进行部署。
>
> 近日在开发awesom-weblog的时候发现一种不用插件的方法来生成不同的分类的页面。



# 在不使用自定义插件的情况下，让Jekyll支持文章分类



__一、分类页渲染模版(Layout)__

由插件版到无插件的迁移会比较简单，已经有存在了分类页文章渲染模版(Layout)，无模块的可以参考首页模版进行修改。

示例（`categoly.html`）如下：

```html
<div id="content">
	  <div class="box archive-meta">
        <h3 class="title-meta">{{page.cat}}</h3>
      </div>
    {% for post in site.categories[page.cat] %}
            {% include posts.html%}
    {% endfor %}

</div>
```

这里用到的是site全局中的categories属性，该属性以字典的形式存储了所有分类，以及该分类下的post。

比如：我们只需要通过调用`site.categories['Linux']`便可以拿到该分类下的所有文章。



__二、为分类创建分类页而__



在layout已经创建好之后， 我们只需要通过该Layout对每个分类进行渲染，而渲染的方法，就是通过创建多个Layout的实现，使其传入不同的page.cat参数，便可生成不同的分类页面了。

一个Layout的实现如下：

添加categories目录，并在目录下创建一个名为`Linux.html`的文件：

```
---
layout: category
cat: Linux
---
```

此实现只需传入分类名无需带任何content，其它分类同样创建不同分类名文件，并传入分类名。

此外，可通过添加`permalink:`参数自定义目录生成的链接位置。



__三、自动创建分类页面__

由于分类页面实在简单，但如果分类较多的话，可能通过批量命令的方式，创建页面。



首先获取到博客的分类列表，形成txt文档，每行一个。

在categories目录下创建bash程序`autogencat.sh`：

```
#!/bin/bash

while read catname
do
	cp Linux.html $catname.html
	sed -i "s/Linux/${catname}/g"  ${catname}.html
done

```

添加执行权限并且执行：

```
chmod +x autogencat.sh
./autogencat.sh < catlist.txt
```

程序会将Linux.html做为生成模板，复制生成其它分类文件，以后新增分类只需要更新catlist.txt目录列表，运行脚本即可。

