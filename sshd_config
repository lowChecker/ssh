#!/bin/bash

# Define the SSH configuration file path
SSHD_CONFIG_FILE="/etc/ssh/sshd_config"

echo "### Starting SSH Security Hardening Configuration ###"

# 1. Backup the original configuration file
if [ -f "$SSHD_CONFIG_FILE" ]; then
    echo "Creating backup of $SSHD_CONFIG_FILE to ${SSHD_CONFIG_FILE}.bak"
    sudo cp "$SSHD_CONFIG_FILE" "${SSHD_CONFIG_FILE}.bak"
else
    echo "Error: $SSHD_CONFIG_FILE not found. Exiting."
    exit 1
fi

# Function to safely update or append a configuration directive
update_config() {
    local key=$1
    local value=$2
    # Check if the key exists (ignoring comments) and update it
    if sudo grep -qE "^[[:space:]]*#?[[:space:]]*${key}[[:space:]]" "$SSHD_CONFIG_FILE"; then
        echo "Updating existing directive: ${key} ${value}"
        # Use sed to find the key (optionally preceded by a # and whitespace) and replace the whole line
        sudo sed -iE "/^[[:space:]]*#?[[:space:]]*${key}[[:space:]]/c\
        ${key} ${value}" "$SSHD_CONFIG_FILE"
    else
        echo "Appending new directive: ${key} ${value}"
        # Append the new line to the end of the file
        echo "${key} ${value}" | sudo tee -a "$SSHD_CONFIG_FILE" > /dev/null
    fi
}

# Apply the desired security configuration changes
update_config "PermitRootLogin" "prohibit-password"
update_config "PubkeyAuthentication" "yes"
update_config "AuthorizedKeysFile" ".ssh/authorized_keys"
update_config "PasswordAuthentication" "no"

echo "### Configuration changes applied to $SSHD_CONFIG_FILE ###"

echo "You must now manually restart the SSH service (e.g., sudo systemctl restart sshd or sudo service sshd restart)"
echo "But FIRST, follow the manual steps below to verify key access."

echo "### Script finished. ###"
