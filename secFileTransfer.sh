#!/bin/bash

# Baixa e instala as ferramentas
apt install magic-wormhole -y
wget https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-1.24-Update7-setup.tar.bz2
tar -xvf veracrypt* && ./veracrypt*-x64 && rm veracrypt* 

# Cria o container
read -s -p "Defina a senha do container Veracrypt: " senhaContainer
veracrypt -t -c secureFileTransfer --volume-type=normal --encryption=aes --hash=sha-512 --filesystem=fat -p $senhaContainer --pim=420 -k "" --random-source=/dev/urandom

# Monta o container
veracrypt -t -p $senhaContainer -k "" --pim=420 --protect-hidden=no ./secureFileTransfer /media/veracrypt1/

# Copia o arquivo para a unidade montada
read -p "Qual/quais arquivo/s você deseja criptografar e enviar? " arquivoUp
cp $arquivoUp /media/veracrypt1/
echo "Os seguintes arquivos estão no container: "
ls /media/veracrypt1/

# Desmonta o container
echo "Desmontando o container para enviar..."
veracrypt -t -d 

# Adiciona segunda camada de protação com zip antes de enviar
read -s -p "Defina a senha para o zip: " senhaZip
zip secureFileTransfer.zip ./secureFileTransfer -P $senhaZip

# Cria um wormhole com o container
echo "Criando o wormhole com o container..."
wormhole send ./secureFileTransfer.zip
rm ./secureFileTransfer* 

# ToDo
## Fazer if questionando se deseja adicionar a segunda camada de proteção
## Limpar saídas de erro do Veracrypt 