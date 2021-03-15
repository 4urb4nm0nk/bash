#!/bin/bash

# Baixa e instala as ferramentas
apt install veracrypt magic-wormhole -y

# Cria o container
veracrypt -t -c ./secureFileTransfer

# Monta o container
#read -p "Insira o caminho do container que sera montado: " container
veracrypt -t ./tmpVC
echo "Lista dos containers montados: "
veracrypt -t -l 

# Copia o arquivo para a unidade montada
read -p "Qual arquivo você deseja criptografar e enviar? " arquivoUp
#read -p "Qual o caminho do container montado? " caminhoUp
cp $arquivoUp /media/veracrypt1/
ls /media/veracrypt1/

# Desmonta o container
echo "Demontando o container para enviar..."
veracrypt -t -d 

# Cria um wormhole com o container
echo "Criando o wormhole com o container..."
wormhole send ./tmpVC