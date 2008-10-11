#!/bin/bash
set -e

HAS_PAM_MOD=0
unset NOT_CONFIGURED
source /etc/ssh-newkeys.cfg

if [ "$1" -o "$NOT_CONFIGURED" ]; then
	echo "You have to edit /etc/ssh-newkeys.cfg first" >&2
	exit 1
fi

if [ "$HAS_PAM_MOD" == "1" ]; then
	echo
	echo "Set ssh daemon to allow password connections (sanity only if key-exchange fails)"
	echo "================================================================================"
	for ((i = 0; $i < ${#users[@]}; i++)); do echo ${users[$i]}; done | ssh $server "
		mv -f /etc/ssh/withpassword.allow /etc/ssh/withpassword.allow.bak
		cat >> /etc/ssh/withpassword.allow
		echo \"Contents of /etc/ssh/withpassword.allow:\"
		cat /etc/ssh/withpassword.allow
	"
fi

echo
echo "Delete, recreate and exchange ssh keys for all users"
echo "===================================================="
for ((i = 0; i < ${#users[@]}; i++)); do
	user=${users[$i]}
	[ $user == root ] && sshdir=/root/.ssh || sshdir=/home/$user/.ssh
	echo
	echo "user $user with directory $sshdir:"

	echo
	echo "clear and recreate local ssh key ..."
	rm -f $sshdir/{id_dsa.pub,authorized_keys,id_dsa.new,id_dsa.new.pub} # keep the old private key ...
	ls -la $sshdir
	sudo -u $user ssh-keygen -vvv -t dsa -f $sshdir/id_dsa.new -N ""
	sudo -u $user touch $sshdir/authorized_keys
	chmod 644 $sshdir/authorized_keys

	echo
	echo "clear and recreate remote ssh key ..." # ... to allow passwordless connection here
	{ cat $sshdir/id_dsa.new.pub; [ "$user" != "root" ] && cat /root/.ssh/id_dsa.pub; } | ssh $server "
		rm -f $sshdir/{id_dsa,id_dsa.pub,authorized_keys,id_dsa.new,id_dsa.new.pub}
		ls -la $sshdir
		sudo -u $user ssh-keygen -vvv -t dsa -f $sshdir/id_dsa -N \"\"
		sudo -u $user touch $sshdir/authorized_keys
		chmod 644 $sshdir/authorized_keys
		echo \"allow remote -> remote and local -> remote ...\"
		cat $sshdir/id_dsa.pub >> $sshdir/authorized_keys
		read -r dsa
		echo \$dsa >> $sshdir/authorized_keys
		if [ \"$user\" != \"root\" ]; then
			echo
			echo \"allow root@remote -> user@remote and root@local -> user@remote ...\"
			cat /root/.ssh/id_dsa.pub >> $sshdir/authorized_keys
			read -r dsa
			echo \$dsa >> $sshdir/authorized_keys
		fi
		echo \"Contents of remote $sshdir/authorized_keys:\"
		cat $sshdir/authorized_keys
		ls -la $sshdir
	"
	mv -f $sshdir/id_dsa.new $sshdir/id_dsa # make the new local key the current one ...
	mv -f $sshdir/id_dsa.new.pub $sshdir/id_dsa.pub

	echo
	echo "allow local -> local and remote -> local ..."
	tmpf=`mktemp`
	scp $server:$sshdir/id_dsa.pub $tmpf # ... so that passwordless connection works here
	cat $sshdir/id_dsa.pub >> $sshdir/authorized_keys
	cat $tmpf >> $sshdir/authorized_keys
	rm -f $tmpf
	if [ "$user" != "root" ]; then
		echo
		echo "allow root@local -> user@local and root@remote -> user@local ..."
		tmpf=`mktemp`
		scp $server:/root/.ssh/id_dsa.pub $tmpf # ... and here
		cat /root/.ssh/id_dsa.pub >> $sshdir/authorized_keys
		cat $tmpf >> $sshdir/authorized_keys
		rm -f $tmpf
	fi
	echo "Contents of local $sshdir/authorized_keys:"
	cat $sshdir/authorized_keys
	ls -la $sshdir
done

if [ "$HAS_PAM_MOD" == "1" ]; then
	echo
	echo "Set ssh daemon back to previous config"
	echo "======================================"
	ssh $server "
		mv -f /etc/ssh/withpassword.allow.bak /etc/ssh/withpassword.allow
		echo \"Contents of /etc/ssh/withpassword.allow:\"
		cat /etc/ssh/withpassword.allow
		"
fi
