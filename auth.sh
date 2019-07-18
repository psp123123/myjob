#!/bin/bash
function ssh_copy_id() {
	. $BASE_HOME/fun_yum-repo
	salt "$1" cmr.run 'sed -i "s#\#   StrictHostKeyChecking ask#StrictHostKeyChecking no#g"  /etc/ssh/ssh_config'
	salt "$1" cmr.run "centos_v sshd restart"
	salt "$1" cmd.run 'ssh-keygen -t dsa -P ""  -f ~/.ssh/id_dsa'
	salt "$1" cp.push /root/.ssh/id_dsa.pub
	find /var/cache/salt/master/minions/ -type f -name "*.pub"|xargs \cp {} $BASE_HOME/tmp/id_$1_dsa.pub
}

for ip in `grep bigdata $BASE_HOME/ip_list|awk '{print $1}'`
  do 
    ssh_copy_id $ip
    cat $BASE_HOME/tmp/*.pub > /srv/salt/conf/authorized_keys
    salt "$1" cp.get_file salt://conf/authorized_keys /root/.ssh/
done    
 
