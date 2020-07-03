#!/bin/bash

#works on Debian 10

sudo apt update && sudo apt install git gedit ruby ruby-dev gcc make curl -y 
sudo apt auto-remove -y
sudo gem install fpm

curl -fsSL https://get.docker.com/ | sh

#not permitted because privilage escalation
#sudo printf "[Service]\nExecStart=\nExecStart=/usr/bin/docker daemon -H fd:// -g /home/user/docker" > /etc/systemd/system/docker.service

printf '\e[5;34m%-6s\e[m' "Run: " 
printf "sudo vim /etc/systemd/system/docker.service\n"
printf '\e[5;34m%-6s\e[m' "And paste:"
printf "\n[Service]\nExecStart=\nExecStart=/usr/bin/docker daemon -H fd:// -g /home/user/docker\n"

printf '\e[5;34m%-6s\e[m' "Then run: "
printf "sudo systemctl daemon-reload\n"
printf '\e[5;34m%-6s\e[m' "For testing: "
printf "sudo docker run -it --rm hello-world\n"
