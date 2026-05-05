#!/bin/sh

echo | openssl s_client -starttls imap -connect 127.0.0.1:1143 -showcerts 2>/dev/null |
	openssl x509 -outform PEM -out ~/Downloads/protonbridge.pem
sudo trust anchor --store ~/Downloads/protonbridge.pem
