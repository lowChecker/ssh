#! /bin/bash
if [ ! -d $HOME/.ssh ]; then
        `mkdir $HOME/.ssh`
        `touch $HOME/.ssh/authorized_keys`
        `chmod 0600 $HOME/.ssh/authorized_keys`
else
	if [ ! -d $HOME/.ssh/authorized_keys ]; then
        	echo "Creating authorized_keys file"
                `touch $HOME/.ssh/authorized_keys`
                `chmod 0600 $HOME/.ssh/authorized_keys`
	fi
fi

#get public key from a public url, mine is at dropbox
PATH_TO_KEY="https://github.com/lowchecker.keys"
echo `wget $PATH_TO_KEY`

#todo #1 - handle failure to get key

key=`echo $PATH_TO_KEY | sed 's_.*/__' `
`cat $key >> $HOME/.ssh/authorized_keys`
`rm $key`

#bash <(curl -s https://raw.githubusercontent.com/lowChecker/ssh/main/set_key.sh)
