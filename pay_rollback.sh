#!/bin/bash

#停止服务
read -p "需要回滚的服务：" srv

#/opt/blueix/init.d/$srv stop
echo "停止$srv 服务"

BAK_FILES=`ls /tmp/"$srv"_old* -d`
NUM_BAK_FILES=`ls /tmp/*_old* -d|wc -l`
#OLD_DIR=/tmp/
CONF_DIR=/opt/blueix/conf/$srv/
n=1
for file_srv in $BAK_FILES
  do 
    echo "$n    $file_srv" 
    let n=n+1
done
read -p "现在存在$NUM_BAK_FILES 个配置文件备份，需要回滚的请选择：" num

#n=1
#for file_srv in $BAK_FILES
#  do 
#    echo "$n    $file_srv" 
#done
m=1
for file_srv in $BAK_FILES
  do
    if [ "$num" -gt "$NUM_BAK_FILES" ]
      then
        echo "请输入$m - $NUM_BAK_FILES 之间的数字"
        break
    elif [ "$m" == "$num" ]
       then
         #source_dir=`/tmp/$file_srv/conf`
         echo $file_srv
         #CP_ORDER=`ls $source_dir |sed -r "s#(.*)_(.*)#\cp $source_dir& $CONF_DIR\1#g"`
         #echo "$CP_ORDER" | bash
     fi
   let m=m+1
done















