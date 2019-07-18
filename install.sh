#!/bin/bash
echo '本机将作为管理机'
mkdir -p /srv/salt/
BASE_HOME=`pwd`
tar xf $BASE_HOME/salt-ssh.tar.gz -C /srv/salt/
IP=`ifconfig|awk 'NR==2{print $2}'`
sed -i "s#MASTER_IP#$IP#g" /srv/salt/minions/conf/minion
yum -y install salt-ssh > /dev/null
echo '正在安装salt-ssh'
[ -z '/usr/bin/salt-ssh' ] && echo '安装salt-ssh失败，请手动安装' && exit 1
. $BASE_HOME/fun_salt_ssh
. $BASE_HOME/fun_yum-repo
yum -y install salt-master > /dev/null

if [ -z '/usr/bin/systemctl' ] 
  then
    /etc/init.d/salt/salt-master start
  else
    systemctl start salt-master
fi

config_salt_ssh
yum_repo
salt-ssh -i '*' state.sls minions.install #saltenv=/srv/salt
salt-key -A -y
sleep 5
#salt '*' cmd.run 'mkdir -p /srv/salt/{base,webapps,scripts,conf,init}'
salt '*' cmd.run 'echo aaa'
salt '*' state.sls init.init





