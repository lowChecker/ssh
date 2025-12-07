#!/bin/bash

# --- Configuration Variables ---
MAILRISE_HOST="192.168.0.4"
MAILRISE_PORT="8025"
RELAY_HOST="${MAILRISE_HOST}:${MAILRISE_PORT}"

# --- Check for root privileges ---
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)."
   exit 1
fi

echo "🚀 Starting Postfix installation and configuration..."

# 1. Install Postfix
echo "--- Installing Postfix ---"
# The '-y' flag assumes yes to all prompts.
# During installation, Postfix might prompt for 'General type of mail configuration'.
# The script will rely on the postconf settings below to override the defaults.
# If prompted, select 'Internet Site' or 'Local only'.
DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y postfix mailutils

if [ $? -ne 0 ]; then
    echo "❌ Error: Postfix installation failed."
    exit 1
fi

# 2. Configure Postfix to use mailrise as a smart host (relay)
echo "--- Configuring Postfix to use Smart Host ---"

# Set the smart host (all mail will be forwarded here)
postconf -e "relayhost = [${RELAY_HOST}]"

# Set the system mail name (optional, but good practice)
# This will be used in the 'From' header of system emails
SYSTEM_MAIL_NAME=$(hostname -f)
postconf -e "myhostname = ${SYSTEM_MAIL_NAME}"

# Set the origin to simplify email addresses (e.g., root@localhost -> root@myhostname)
postconf -e "mydestination = localhost"

# Set the source address rewriting (optional, but ensures system mail looks correct)
# This tells Postfix to rewrite the 'From' address for all local users (e.g. root, www-data)
# so it appears to come from the system's hostname.
# You might need to check if 'canonical_maps' is already set, but this is a common setup for relaying.
postconf -e "sender_canonical_maps = hash:/etc/postfix/sender_canonical"

# Create the canonical map file
echo "root          ${SYSTEM_MAIL_NAME}" > /etc/postfix/sender_canonical
echo "@localhost    ${SYSTEM_MAIL_NAME}" >> /etc/postfix/sender_canonical
echo "@localhost.localdomain    ${SYSTEM_MAIL_NAME}" >> /etc/postfix/sender_canonical

# Generate the map database
postmap /etc/postfix/sender_canonical

# 3. Restart Postfix to apply changes
echo "--- Restarting Postfix Service ---"
systemctl restart postfix

if [ $? -ne 0 ]; then
    echo "❌ Error: Postfix service restart failed."
    exit 1
fi

# 4. Verification and Test
echo "--- Postfix Configuration Complete ---"
echo "✅ Postfix configured to relay mail to: **${RELAY_HOST}**"
echo ""

# Test Email - replace with a real external address to verify end-to-end delivery
TEST_RECIPIENT="your_test_email@example.com"
echo "Attempting to send a test email to **${TEST_RECIPIENT}**..."
echo "This is a test email from the system setup script." | mail -s "Postfix Mailrise Setup Test" ${TEST_RECIPIENT}

echo "--- Setup Finished ---"
echo "Please check the mail log (e.g., /var/log/mail.log or /var/log/syslog) for errors."
echo "You should see Postfix connecting to [${RELAY_HOST}]."
