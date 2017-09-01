#!/bin/bash
##############################################################
# File Name: optimize.sh
# Author: pan shaopeng
# Created Time : 2017-08-19 20:40:57
##############################################################
read -p "Do you want to close the selinux: " code
if [[ "$code" = "y" || "$code" = "yes" ]]
  then
    {
    sed -i "s#SELINUX=enforcing#SELINUX=disabled#g" /etc/selinux/config
    echo "selinux is closed!"
    }
  else
    echo 'your code is error.'
fi

read -p "Do you want the necessary software: " necessary
if [[ "$necessary" = "y" || "$necessary" = "yes" ]]
  then
    {
  yum install -y net-tools vim lrzsz tree screen lsof tcpdump wget 
  echo "net-tools vim lrzsz tree screen lsof tcpdump wget is installed!"  
    }
else
    echo 'your code is error.'
    exit 1
fi
read -p "Do you want to close the firewall: " firewall
if [[ "$firewall" = "y" || "$firewall" = "yes" ]] 
  then 
    {
    systemctl disable firewalld
    systemctl stop NetworkManager
    echo `"$firewall" is closed!`
    }
fi

read -p "Do you want to change the repo: " repo
if [[ "$repo" = "y" || "$repo" = "yes" ]] 
  then {
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
    mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    cp /etc/ssh/ssh_config /etc/ssh/ssh_config.bak
    sed -i "s/#UseDNS yes/UseDNS no/g" /etc/ssh/ssh_config
}
    echo '
    your repo and epel have changed to centos-7
    ------------------------------------------
    your UseDNS is closed
    '
fi
echo "your system opt has completed!"
