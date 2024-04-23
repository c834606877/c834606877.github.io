---
layout: post
title: 多站共存的Nginx配置下使用腾讯云CDN加速Discourse出现乱码的问题

categories:
- 网络应用
- 应用技巧

tags: [DisCourse]

author:
  login: lanbing
  email: c834606877@163.com
---


上文讲述了[在国内环境下加速Discourse的部署](/2021/02/17/Discourcs-setup-on-cvm-ecs)过程。

Discourse官方并不建议在同一主机上部署多个站点，但也提供了方案：[Running other websites on the same machine as Discourse](https://meta.discourse.org/t/running-other-websites-on-the-same-machine-as-discourse/17247)。

按照官方的提供方案部署，通常可以正常将Discourse运行在standlone模式下，再通过Nginx反代访问。https的实现通过certbot也可以简单完成。


以下是nginx配置exsample:

<!--more-->

```

server {
    listen 80; listen [::]:80;
    server_name forum.example.com;  # <-- change this

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;  listen [::]:443 ssl http2;
    server_name forum.example.com;  # <-- change this

    ssl_certificate      /var/discourse/shared/standalone/ssl/ssl.crt;
    ssl_certificate_key  /var/discourse/shared/standalone/ssl/ssl.key;
    ssl_dhparam          /var/discourse/shared/standalone/ssl/dhparams.pem;
    ssl_session_tickets off;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA;

    http2_idle_timeout 5m; # up from 3m default
    client_max_body_size 0;

    location / {
        proxy_pass http://unix:/var/discourse/shared/standalone/nginx.http.sock:;
        proxy_set_header Host $http_host;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```


其中，需要注意的是，X-Forwarded-Proto用于将前端nginx接收到的请求ssl/no_ssl类型传递到后端，后端根据https或者是http生成包含不同静态资源链接的内容.

在一次今年4月的一次更新中，Discourse社区的[一次改动](https://review.discourse.org/t/feature-remove-compress-brotli-optional-behavior/2786) 决定，只要前端连接为https，后端则会__无条件__使用brotli压缩数据并返回内容。返回的Header包含 `Content-Encoding: br`。

Brotli是一种专门为http协议优化过的压缩方式，比gzip压缩率提升20%左右。虽然brotli算法在实际使用中已经存在五六年多了，主流浏览器早已支持，也相当成熟。
浏览器在访问https页面时，通常会在请求header中包含：`Accept-Encoding: gzip, deflate, br`，br即brotli。

然而，在某些情况下，有些程序并没有良好的支持Brotli，比如`curl`，国内的某些cdn服务商, 在获取静态资源时，并没有指定 `Accept-Encoding`, 或者指定的压缩算法中不包含`br`.
但后端仍然会返回Brotli压缩过的内容，导致客户端解析出错。

在此情况下，可通过`rewrite`功能，将Brotli资源重写向到gzip资源中。添加如下语句到上述nginx中即可解决问题。

```
    if ($http_accept_encoding !~ .*br.*)
    {
        rewrite /brotli_asset/(.*) /assets/$1 last;
    }

```



