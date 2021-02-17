---
layout: post
title: 在国内环境下安装Discourse

categories:
- 网络应用
- 应用技巧

tags: [DisCourse]

author:
  login: lanbing
  email: c834606877@163.com
---




Discourse的版本升级与维护都是基于github来完成的，而Discourse本身又是基于ruby编写。

使用包括腾讯云的CVM、轻量服务器以及阿里云的ECS都存在国外网站访问慢的问题，主要是为了扶持国内git仓库做的限流操作。

在clone托管在github上的discourse时，可以通过将clone链接替换github.com为github.com.cnpmjs.org来加速对github的访问，比如：

将`git clone https://github.com/discourse/discourse_docker.git` 替换为 `git clone https://github.com.cnpmjs.org/discourse/discourse_docker.git `

除此之外，在运行./discourse-setup时，安装程序同样会在docker中安装一些额外的的项目，

比如：gem update，同样需要添加ruby的镜像。

可以通过修改配置文件来添加ruby镜像地址，主要涉及到的文件有
<!--more-->

```
discourse/templates/web.template.yml
discourse/containers/app.yml
```

查找上述文件中调用gem update的地方之前添加如下配置镜像站点的语句：

```
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
```

对于bundle可以使用`bundle config mirror.https://rubygems.org https://gems.ruby-china.com`来添加镜像网站。

主要修改如下：

```yml
diff --git a/templates/web.template.yml b/templates/web.template.yml
index 28fb22d..bb0010c 100644
--- a/templates/web.template.yml
+++ b/templates/web.template.yml
@@ -86,6 +86,9 @@ run:
       cd: $home
       hook: code
       cmd:
+        - git remote -v
+        - git remote set-url origin https://github.com.cnpmjs.org/discourse/discourse.git
+        - gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
         - git reset --hard
         - git clean -f
         - git remote set-branches --add origin master
@@ -145,6 +148,7 @@ run:
       hook: web
       cmd:
         # ensure we are on latest bundler
+        - gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
         - gem update bundler
         - find $home ! -user discourse -exec chown discourse {} \+

@@ -152,6 +156,9 @@ run:
       cd: $home
       hook: bundle_exec
       cmd:
+        - su discourse -c 'gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/'
+        - su discourse -c 'gem update bundler'
+        - su discourse -c 'bundle config mirror.https://rubygems.org https://gems.ruby-china.com'
         - su discourse -c 'bundle install --deployment --retry 3 --jobs 4 --verbose --without test developme

   - exec:
...skipping...
diff --git a/templates/web.template.yml b/templates/web.template.yml
index 28fb22d..bb0010c 100644
--- a/templates/web.template.yml
+++ b/templates/web.template.yml
@@ -86,6 +86,9 @@ run:
       cd: $home
       hook: code
       cmd:
+        - git remote -v
+        - git remote set-url origin https://github.com.cnpmjs.org/discourse/discourse.git
+        - gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
         - git reset --hard
         - git clean -f
         - git remote set-branches --add origin master
@@ -145,6 +148,7 @@ run:
       hook: web
       cmd:
         # ensure we are on latest bundler
+        - gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
         - gem update bundler
         - find $home ! -user discourse -exec chown discourse {} \+

@@ -152,6 +156,9 @@ run:
       cd: $home
       hook: bundle_exec
       cmd:
+        - su discourse -c 'gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/'
+        - su discourse -c 'gem update bundler'
+        - su discourse -c 'bundle config mirror.https://rubygems.org https://gems.ruby-china.com'
         - su discourse -c 'bundle install --deployment --retry 3 --jobs 4 --verbose --without test developme

   - exec:
~
```


**关于邮箱设置的问题**

论坛通常需要有一个邮箱服务器，用于发送各种验证码，登录消息或者密码找回，消息提醒等功能。

网易的免费企业邮箱（ym.163.com）可以满足这个需求，使用qq邮箱开启smtp服务也是可以，当然也可以购买收费的邮箱。

网易免费企业邮箱默认是开启smtp服务的，下面是设置`app.yml`的例子：
Discourse好像不提供支持ssl的连接方式，这里直接使用smtp服务了。
注意这里要显示关闭start_tls功能。

```
  DISCOURSE_SMTP_ADDRESS: smtp.ym.163.com
  DISCOURSE_SMTP_PORT: 25
  DISCOURSE_SMTP_USER_NAME: mail@getblog.cn
  DISCOURSE_SMTP_PASSWORD: "password"
  DISCOURSE_SMTP_ENABLE_START_TLS: false           # (optional, default true)
  DISCOURSE_SMTP_DOMAIN: getblog.cn    # (required by some providers)
```

另外，网站管理员的邮箱不可与 `DISCOURSE_SMTP_USER_NAM`相同，否则可能会收不到注册邮件。


