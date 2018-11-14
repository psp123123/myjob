#!/bin/bash
##############################################################
# File Name: install.sh
# Author: Pan ShaoPeng
# Created Time : 2018-11-13 22:41:04
##############################################################
#1. 目录服务器的sql生成
SCRIPT_DIR=`pwd`
/usr/bin/cp $SCRIPT_DIR/dir_sql $SCRIPT_DIR/tmp/dir_sql_tmp

read -p '请输入使用的域名或IP：' SET_URL
#输入的IP的处理方式
function IP() {
function check_ip() {
    local IP=$1
    VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
    if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" >/dev/null; then
        if [ $VALID_CHECK == "yes" ]; then
          echo '使用的是ip,将使用http协议'
          sed -i "s#set_http#http#g" $SCRIPT_DIR/tmp/dir_sql_tmp
          read -p '请输入server_id:' SERVER_IDENTITY 
          return 0
        else
            echo "IP $IP not available!"
            return 1
        fi
    else
        echo "IP format error!"
        return 1
    fi
}
while true; do
    check_ip $SET_URL
    if [ $? -ne 0 ]
      then
        read -p "Please renter IP: " IP
        SET_URL=$IP
    else
        break 
    fi
done
}
#如果是输入的是域名，则处理方式
function check_url() {
          read -p '
==========
y == 域名前使用https
n == 域名前使用http
否使用ssl协议 [y/n] :
' SET_HTTP
          [[ $SET_HTTP = "y" ]] || [[ $SET_HTTP = "Y" ]] && sed -i "s#set_http#https#g" $SCRIPT_DIR/tmp/dir_sql_tmp
          [[ $SET_HTTP = "n" ]] || [[ $SET_HTTP = "N" ]] && sed -i "s#set_http#http#g" $SCRIPT_DIR/tmp/dir_sql_tmp
          SERVER_IDENTITY=`echo $SET_URL|awk -F . '{print $1"-lanxin"}'`
}
#判断域名还是IP
CN=`echo $SET_URL|awk -F . '{print $NF}'`

if [ "$CN" -gt 0 ] 2>/dev/null ;then 
  IP $SET_URL
else 
  check_url
fi 

sed -i "s#set_url#$SET_URL#g" $SCRIPT_DIR/tmp/dir_sql_tmp
read -p '域名是否使用特殊端口：[y/n]' PORT_YN

[[ $PORT_YN = "y" ]] || [[ $PORT_YN = "Y" ]] && read -p '请输入端口号：' SET_PORT && sed -i "s#set_port#:$SET_PORT#g" $SCRIPT_DIR/tmp/dir_sql_tmp
[[ $PORT_YN = "n" ]] || [[ $PORT_YN = "N" ]] && sed -i "s#set_port##g" $SCRIPT_DIR/tmp/dir_sql_tmp && echo '
----------------------------
将使用默认端口！！！
----------------------------
'






FILE_CONTEXT=`cat $SCRIPT_DIR/tmp/dir_sql_tmp`
echo "
===============================================================
===============请粘贴以下内容，注意换行符======================
===============================================================
==============================
server_name:

$SERVER_IDENTITY
==============================
server_ip:

$SET_URL
==============================
server_port: (此端口为目录服务器下发客户端访问蓝信服务器端口，默认为：62715)

62715
==============================
server_attr_str:

$FILE_CONTEXT
==============================
server_identity:

$SERVER_IDENTITY
==============================
"
rm -f $SCRIPT_DIR/tmp/dir_sql_tmp
