#!/bin/bash

# Baixa e instala as ferramentas
if ! command -v wormhole &> /dev/null
then
    apt install magic-wormhole -y
    exit
fi
if ! command -v veracrypt &> /dev/null
then
    get https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-1.24-Update7-setup.tar.bz2
    tar -xvf veracrypt* && ./veracrypt*-x64 && rm veracrypt* 
    exit
fi 

printf "\nEmbora o Magic Wormhole seja seguro, criando uma transferência direta, criptografada e única entre os sistemas,\nduas camadas adicionais de proteção não faz mal a ninguém =]\n\n"

# Cria o container
read -s -p "--> Defina a senha do container Veracrypt: " senhaContainer
printf "\n"
read -s -p "--> Defina o pim do container Veracrypt: " pimContainer
veracrypt -t -c secureFileTransfer --volume-type=normal --encryption=aes --hash=sha-512 --filesystem=fat -p $senhaContainer --pim=$pimContainer -k "" --random-source=/dev/urandom

# Monta o container #ToDo# Limpar avisos GLib-GObject
veracrypt -t -p $senhaContainer -k "" --pim=$pimContainer --protect-hidden=no ./secureFileTransfer /media/veracrypt1/

# Copia o arquivo para a unidade montada #ToDo# add pergunta se deseja adicionar mais arquivos
read -p "--> Qual/quais arquivo/s você deseja criptografar e enviar (pode usar coringa *)? " arquivoUp
cp $arquivoUp /media/veracrypt1/
printf "\n--> Os seguintes arquivos estão no container: "
ls /media/veracrypt1/

# Desmonta o container #ToDo# Limpar avisos GLib-GObject
printf "\n--> Desmontando o container para enviar...\n"
veracrypt -t -d 

# Zip com senha
read -s -p "--> Defina a senha para o zip: " senhaZip
zip secureFileTransfer.zip ./secureFileTransfer -P $senhaZip

# Cria um wormhole com o container
printf "\n--> Criando o wormhole com o container...\n"
wormhole send ./secureFileTransfer.zip
rm ./secureFileTransfer*
printf "\n--> No sistema destino, rode os seguintes comandos para instalar o Magic-Wormhole + Veracrypt:\napt install magic-wormhole -y"
printf "\nget https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-1.24-Update7-setup.tar.bz2"
printf "\ntar -xvf veracrypt* && ./veracrypt*-x64 && rm veracrypt*"
printf "\n\n--> Para descompactar:\nunzip secureFileTransfer.zip"
printf "\n\n--> Para montar o container:\nveracrypt -t secureFileTransfer && cd /media/veracrypt1/"
printf "\n\n--> Para desmontar o container:\nveracrypt -t -d\n"