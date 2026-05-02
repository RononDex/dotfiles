#!/bin/sh

SetupMachineGpgKey() {
	host_name=$(cat /etc/hostname)
	existing_key=$(gpg --list-secret-keys --with-colons | grep uid | grep $host_name)

	if test -z "$existing_key"; then
		echo "Creating machine specific gpg key"
		pass_phrase="$host_name:$(cat /etc/machine-id)"
		key_name="MachineKey <machine@$host_name>"
		gpg --batch --pinentry-mode loopback --passphrase "$pass_phrase" --quick-gen-key "$key_name" ed25519 default 0 &&
			gpg --batch --pinentry-mode loopback --passphrase "$pass_phrase" --quick-add-key "$(gpg --list-keys --with-colons "$key_name" | awk -F: '/^fpr/{print $10; exit}')" cv25519 encr 0
	fi
}
