#!/bin/bash
# Your external IP.
IP=140.112.x.x

echo "This script generates self-signed SSL certificate for protecting connection to guacamole by nginx."
echo "This script can't be run without interaction!"
echo "Please run its commands line by line."
exit 1

git clone https://github.com/OpenVPN/easy-rsa.git
./easy-rsa/easyrsa3/easyrsa init-pki
# create CA (you’ll be prompted for Common Name. For example, your lab name: "DSR Lab")
./easy-rsa/easyrsa3/easyrsa build-ca nopass

SERVICE_NAME=lab
./easy-rsa/easyrsa3/easyrsa gen-req $SERVICE_NAME nopass
# Remove old one
#rm ./pki/issued/$SERVICE_NAME.crt
# Sign with the new profile
./easy-rsa/easyrsa3/easyrsa --subject-alt-name="IP:$IP" sign-req serverClient $SERVICE_NAME

cat ./pki/issued/$SERVICE_NAME.crt ./pki/ca.crt > ./pki/issued/$SERVICE_NAME-full.crt
