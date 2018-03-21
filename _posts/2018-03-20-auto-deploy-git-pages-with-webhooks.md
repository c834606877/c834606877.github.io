---
layout: post
title: 利用git WebHooks自动部署Pages（Coding Pages）

categories:
- Linux

tags: [jekyll，git pages, Coding Pages, linux]

author:
  login: lanbing
  email: iziy@mypre.cn
---

github pages服务由于安全性的考虑，对其原生jekyll的支持插件进行了过滤。使得只能使用其有限的插件，而且无法使用自定义的插件。这导致了很多问题，比如不能按自己的规则生成归档文件或者分类目录，甚至部署爬虫之类等等。

具体详见: [https://pages.github.com/versions/](https://pages.github.com/versions/)

而国内几大git服务商（Coding，码市之类），也对支持的插件进行了限制，所以在多数情况下，还是选择在本地搭建Jekyll环境，生成静态页面直接上传。

但这极大限制了Jekyll的Markdown in Anywhere便利性，需要在不同的系统上都装上Jekyll的开发环境。


##　现在讨论一种利用中间生产服务器代替本地发布过程的方法。


依赖：一台部署gh-hooks-server的VPS


既然选择不使用git的原生jekyll，也那么需要两个branch，
一个用于jekyll源码的存放，
一个用于托管静态代码

通过一台中间服务器，当源branch进行了更新，则通过webhook自动通知gh-hooks-server，使其执行pull、push操作。

VPS的jekyll环境的搭建不再赘述【首先安装rvm，ruby, 再装jekyll以及插件比如jekyll-paginate】

下面演示安装gh-hooks-server并启动
```
git clone https://github.com/c834606877/gh-hooks-server.git
cd gh-hooks-server
python setup.py install

ghhooks -a updatemypre:/home/lanbing/updatemypre.sh --secret s3cret

 
```

程序启动后会侦听8011端口，处理`http://0.0.0.0:8011/ghhooks/updatemypre`的请求信息，当请求密码通过后，执行对应的bash脚本。

故，我们只需要对源Branch的push消息发送webhook，当gh-hooks-server接收收post消息后，pull 源 Branch，jekyll编译，然后push到Pages Branch。

为了兼容手动发布，编写了一个`makefile`，用于本地自动发布的脚本：

```
temp-folder = /tmp/jekyll-temp-site/
repo = git@git.coding.net:iziy/iziy.git

JEKYLL = jekyll

s:
        ${JEKYLL} server
build:
        ${JEKYLL} build -d ${temp-folder}

deploy: build
        cd ${temp-folder} ;\
        git init ${temp-folder} ;\
        git checkout -b coding-pages ;\
        git remote add origin ${repo} ;\
        git add -A ${temp-folder} ;\
        git commit -m "deployed by make" ;\
        git push origin coding-pages --force

push:
        git add -A
        git commit -m "pushed by make"
        git push


clean:
        rm -rf ${temp-folder}
```

而对于webhook响应的脚本为`updatemypre.sh`:

```
#!/usr/bin/bash

echo "webhook enter!"

source /usr/local/rvm/scripts/rvm

cd iziy
git pull
make deploy

```