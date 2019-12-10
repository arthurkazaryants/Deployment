#!/bin/bash

echo "Enter key name: "
read KEYNAME

# GoTo work dir
mkdir $KEYNAME
cd ./$KEYNAME

KEYFILE="id_rsa_deployment"

echo "Generating ssh keys"
ssh-keygen -t rsa -f $KEYFILE -q

echo "Ziping private key"
zip "$KEYFILE.zip" $KEYFILE

echo "Generating new tokens"
NEW_KEY=$(openssl rand -hex 32)
NEW_IV=$(openssl rand -hex 16)

VAR_NAME=$(openssl rand -hex 8)

echo "SSH Key name: $KEYNAME
encrypted_"$VAR_NAME"_key: $NEW_KEY
encrypted_"$VAR_NAME"_iv: $NEW_IV" > credentials.txt

echo "encrypted_"$VAR_NAME"_key: $NEW_KEY"
echo "encrypted_"$VAR_NAME"_iv: $NEW_IV"
echo "KEY and IV saved into credentials.txt"

echo "Encrypting private key zip file"
openssl aes-256-cbc -K $NEW_KEY -iv $NEW_IV -in "$KEYFILE.zip" -out "$KEYFILE.zip.enc"

echo "DONE
P.S. Don't forget to add credentials to CircleCI"
