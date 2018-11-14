#!/bin/bash
cd /opt/blueix/conf && tar cf conf.tar.gz ./* && mv conf.tar.gz /mnt
echo '=====已将原配置文件拷贝到/mnt目录下=====
'
read -p "请输入需要更改后的端口：" port

find /opt/blueix/conf -type f -exec sed -i "s#\$host#\$host:$port#g" {} \;

sed -i "s#\$host:$port#\$host#g" /opt/blueix/conf/fastdfsproxy/includes/fastdfsproxy.conf.web.http.mode-redirect
sed -i "s#443#$port#g" /opt/blueix/conf/fastdfsproxy/includes/fastdfsproxy.conf.web.http.mode-redirect 
sed -i "s#\$host:$port#\$host#g" /opt/blueix/conf/nginx/includes/nginx.conf.web.http.mode-redirect
sed -i "s#443#$port#g"  /opt/blueix/conf/nginx/includes/nginx.conf.web.http.mode-redirect

find /opt/blueix/conf -type f -exec sed -i  "s#https://ot08.t.lanxin.cn#https://ot08.t.lanxin.cn:$port#g" {} \; 
sed -i 's#proxy_redirect off;#\#proxy_redirect off;#g' /opt/blueix/conf/nginx/includes/*



sed -i "s#http://\$host:$port#http://\$host#g" /opt/blueix/conf/nginx/includes/nginx.conf.web.https.blueix


