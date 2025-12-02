bash <(curl -s https://raw.githubusercontent.com/lowChecker/ssh/main/set_key.sh)


nano /etc/ssh/sshd_config
<p> PermitRootLogin prohibit-password <br> PubkeyAuthentication yes   <br> AuthorizedKeysFile .ssh/authorized_keys  </p> 
<br>Ensure the following lines exist (uncomment or add if needed):

    PubkeyAuthentication yes

    PasswordAuthentication no

    Optionally also KbdInteractiveAuthentication no or ChallengeResponseAuthentication no (distro-dependent) to close other password-style prompts.

​

