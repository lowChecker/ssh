bash <(curl -s https://raw.githubusercontent.com/lowChecker/ssh/main/set_key.sh)


nano /etc/ssh/sshd_config
<p> PermitRootLogin prohibit-password <br> PubkeyAuthentication yes   <br> AuthorizedKeysFile .ssh/authorized_keys  </p> 

