---
layout: post
title: 群晖利用公网服务器ip中转流量与内网无缝切换

categories:
- Linux
- 网络应用



tags: [Linux, 系统应用, Synology, 群晖系统, 网络应用]

author:
  login: lanbing
  email: c834606877@163.com
---


最近想起nas的公网访问一直是个问题。中转网络一直不通畅，如果走公网转nas又会过度暴露而被自动扫描攻击,导致硬盘频繁唤醒。

这里实现一套方案，利用公网服务器的ip进行流量转发，并且添加一道简单的防火墙来过滤网络扫描。可以在回家以后自行将流量切换到内网。

在使用公网ip转发的时候，流量和带宽受公网服务器上限所限制。在家中互联场景，本地路由器可以通过拦截公网ip流量，自动转发到nas。免去内外网ip来回切换的问题。


{% mermaid %}
graph TD
  User1(["User1/Phone/PC"]) -->|Access from local NetWork| B{Router}
  NAS["NAS lisening:5000(http)/5001(https)"]  <-->|In local NetWork| B{Router}
  Internet{Internet} <--> PubServer[PubServer onPort:80/443/5001]
  Internet <--> B{Router}
  User2(["User2/DS File/Photo"]) --> |Access to PubServer:5001| PubServer

{% endmermaid %}





主要有以下几个部分实现：

在nas上，将本地端口5000映射到公网ip上，通过 ssh -R 转发。

在计划任务中添加一个bash脚本，建立公网服务器的ssh连接用于端口转发，并设置为开机启动。内容如下：

```bash
#!/bin/bash

while true; do
sleep 1
echo "Start Port Forward 5000 @ " `date`
ssh -R 5000:127.0.0.1:5000 yourAccount@YourServer.com -C -q -N -o ServerAliveInterval=60 -o ServerAliveCountMax=10
echo "End of Port Forward 5000 @ " `date`
done;
```

该脚本启动后会将公网服务器所有来自5000端口的流量转发到nas本身。

5000端口为nas的http服务的连接端口，5001端口为nas的https服务的连接端口。



接下来在公网服务器上配置nginx来实现http流量转发并且配置https端口为5001，通过白名单机制将流量转发到nas。

```nginx
server {
    server_name yourServerName;
    location / {

#       set $pass_url http://127.0.0.1:8000; # for enter password.
#       if ( $http_user_agent ~ 'Synology-' ) { 
#          // we can also use UA to imp more filters.
           set $pass_url http://127.0.0.1:5000;
#       }
        proxy_pass $pass_url;
        proxy_set_header Host $host:80;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        include <your_list_path>/nas_allow_list.conf;
        deny all;
    }

    location /log {  // 
        set $pass_url http://127.0.0.1:8000; # for enter password
        proxy_pass $pass_url;
        proxy_set_header Host $host:80;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    listen 443 ssl; # managed by Certbot
    listen 5001 ssl; # managed by Certbot
    <the ssh certs config >
}

```

在上述conf中`/log`访问点的流量反代到白名单配置程序，可以用于动态更新 nas_allow_list.conf白名单。

一个简单的基于白名单配置程序：

```python
from werkzeug.wrappers import Request, Response
import subprocess

@Request.application
def application(request):
    auth_html = '''<body style="margin: 0;"><div style="margin: auto ; width: 100%; height:100%; border: 2px solid green; padding: 50px 0; text-align: center; "><form  method="POST">
            <input type="password" name="psw" style="line-height: 25px;" value="" required placehold="Enter Text..." />
            <input type="submit" style="width: 90px;height: 30px;" value="Submit" />
        </form></div>'''
    if request.method != "POST":
        return Response(auth_html, content_type="text/html")

    data = request.get_data(cache=False,parse_form_data=True)

    input = request.form.get("psw", None)
    if input != "<Your Pass Word>":
        return Response(auth_html[:-6] + "<red>N/a</red></div>", content_type="text/html")

    iplist = ",".join(request.access_route)
    if request.remote_addr == "127.0.0.1": // the traffic is came from nginx.
        record_addr = request.access_route
    else:
        record_addr = [request.remote_addr]
    for ipaddr in record_addr:
        ipaddr = ''.join(i for i in ipaddr if i in '0123456789.')
        # also we can use firewall to filter te trific
        #cmd = ["firewall-cmd","--zone=sszone","--add-source="+ipaddr+"/32"]
        cmd = ["bash","-c", "echo 'allow "+ipaddr+";'>> <your_list_path>/nas_allow_list.conf"]
        subprocess.check_call(cmd)
        cmd = ["nginx", "-s", "reload"]
        subprocess.check_call(cmd)

    return Response("<h1>You are grand to access, IP<" + iplist + "> has record.<h1>")

if __name__ == "__main__":
    from werkzeug.serving import run_simple
    run_simple("0.0.0.0", 8000, application, threaded=True)
```



在路由器配置iptables ， 将内网client到公网服务器的流量直接转发到local nas:

```bash
iptables -t nat -A PREROUTING -d <yourPubServerIP> -p tcp --dport 5001 -j DNAT --to-destination <yourLocalNasIP>:5001
```

