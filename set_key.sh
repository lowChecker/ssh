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

# Check for root user
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Exiting."
  exit 1
fi

CONFIG_FILE="/etc/ssh/sshd_config"

# Function to update or add config line
update_or_add_config() {
  local key="$1"
  local value="$2"

  if grep -qE "^\s*${key}\s+" "$CONFIG_FILE"; then
    # Update existing line
    sed -i "s|^\s*${key}\s.*|${key} ${value}|" "$CONFIG_FILE"
  else
    # Add line if not found
    echo "${key} ${value}" >> "$CONFIG_FILE"
  fi
}

update_or_add_config "PermitRootLogin" "prohibit-password"
update_or_add_config "PubkeyAuthentication" "yes"
update_or_add_config "AuthorizedKeysFile" ".ssh/authorized_keys"

# Optionally restart sshd to apply changes
systemctl daemon-reload
systemctl restart sshd

#bash <(curl -s https://raw.githubusercontent.com/lowChecker/ssh/main/set_key.sh)
