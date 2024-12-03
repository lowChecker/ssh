bash <(curl -s https://raw.githubusercontent.com/lowChecker/ssh/main/set_key.sh)


nano /etc/ssh/sshd_config
PermitRootLogin prohibit-password
PubkeyAuthentication yes

