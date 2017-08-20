#!/bin/bash
##############################################################
# File Name: optimize.sh
# Author: pan shaopeng
# Created Time : 2017-08-19 20:40:57
##############################################################
sed -i "s#SELINUX=enforcing#SELINUX=disabled#g" /etc/selinux/config
yum install -y net-tools vim lrzsz tree screen lsof tcpdump wget

systemctl disable firewalld
systemctl stop NetworkManager
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

cp /etc/ssh/ssh_config /etc/ssh/ssh_config.bak
sed -i "s#GSSAPIAuthentication yes#GSSAPIAuthentication no#g" /etc/ssh/ssh_config




