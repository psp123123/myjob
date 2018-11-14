#!/bin/bash

#
mkdir -p /root/files
HOME_DIR=/root/files

read -p "选择需要升级的服务（服务名与conf目录下相同）：" SRV
mkdir -p /tmp/"$SRV"
#保存备份原始信息
mkdir -p /tmp/"$SRV"_old_$(date +%F)/conf
LINK_INFO=`ls -l /opt/blueix/$SRV -d |awk '{print $11}'`
echo "$LINK_INFO" > /tmp/"$SRV"_old_$(date +%F)/"$SRV"_link_old_$(date +%F-%s)


#将原配置文件保存到暂存目录
/usr/bin/cp /opt/blueix/conf/$SRV/* /tmp/"$SRV"

CP_DIR=/tmp/"$SRV"

#备份目录
CP_DIR_1=/tmp/"$SRV"_old_$(date +%F)/conf

#将暂存目录下文件取出，改名后复制到备份目录,并删除暂存目录
context_tmp=`cat $CP_DIR/* > $CP_DIR/tmp1.txt`
md5sum $CP_DIR/tmp1.txt
contest_srv=`cat $CP_DIR_1/* > `



#CP_DIR_AARRY=`ls $CP_DIR`
#CP_DIR_1_ARRY=`ls $CP_DIR_1`
#echo $CP_DIR_1
#######################################################################
#for t in `ls $CP_DIR`
#  do
#  if [ ! -f "$CP_DIR_1/$t" ]
#    then
#    /usr/bin/cp $CP_DIR/$t $CP_DIR_1
#  else
#    MD5_I=`md5sum $CP_DIR/$t` 
#    md5_1=`echo $MD5_I|awk '{print $1}'|cut -c -15`
#    a=`echo $t`
#    for w in `ls $CP_DIR_1`
#      do
#        MD5_S=`md5sum $CP_DIR_1/$w` > /dev/null 2>&1
#        md5_2=`echo $MD5_S|awk '{print $1}'|cut -c -15`
#        b=`echo $w`
#        if [ "echo $a|cut -c -6" -eq "echo $w|cut -c -6" -a "$md5_1"  -eq "$md5_2" ]
#          then
#            break 1
#            /usr/bin/cp $CP_DIR/$t $CP_DIR_1/$t_$(date +%F-%s)
#        fi
#      done
#  fi
#done
#######################################################################


#CP_ORDER=`ls $CP_DIR|sed -r "s#(.*)#mv $CP_DIR& $CP_DIR_1\1_$(date +%F-%s)#g"` #|bash 
#echo "$CP_ORDER" |bash
#rm -fr $CP_DIR
echo "
=====================================================
= 服务信息备份在  /tmp/"$SRV"_old_$(date +%F)/ 下面 
=====================================================

"
#停止服务
#/opt/blueix/init.d/$SRV stop

read -p "请输入$SRV的软件包信息："  srv_url
srv_file=`echo $srv_url|awk -F / '{print $NF}'`
if [ ! -f "$HOME_DIR/$srv_file" ];then
    wget -b -P $HOME_DIR $srv_url >/dev/null 2>&1
    ps -ef|grep  wget|grep -v 'grep'>/dev/null 2>&1
    echo "正在下载安装包"
    for ((i=1;i<30;i++));do
      if [ $? -eq 0 ]
          then
            echo -n '.'
          else
            echo 'succeed'
            break
      fi
          sleep 1 
    done 
fi
#return 1
if [ $? -ne 0 ]
  then
    echo "$srv_file=========下载失败,请检查重试！！！"
    exit
fi

/bin/bash $HOME_DIR/$srv_file  >/dev/null 2>&1
#启动服务
read -p "是否要先修改/opt/blueix/conf/$SRV 的配置文件，还是直接启动：[y/n]：
y == 退出脚本，修改文件后，手动重启
n == $SRV 的配置文件已经修改完，直接启动程序
" yn
if [ "$yn" == "n" ]||[ "$yn" == "N" ] 
  then
    echo "启动服务"
    exit 0
   # /opt/blueix/init.d/$SRV start
  elif [ "$yn" == "y" ]||[ "$yn" == "Y" ]
    then
    exit 0
  else
    echo "请重新输入！"
    exit 0
fi
