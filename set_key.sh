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


#bash <(curl -s https://raw.githubusercontent.com/lowChecker/ssh/main/set_key.sh)
