#!/bin/bash

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
SSHD_CONFIG="/etc/ssh/sshd_config"

# Check if sshd_config already contains the section

if grep -q 'Match User git' "$SSHD_CONFIG"; then
	echo "The configuration for the git user seems to be already existent in your $SSHD_CONFIG."
	echo "Please remove it first to apply it again."
	exit 1
fi

# Ask if changes to the /etc/ssh/sshd_config can be made
cat <<EOT
This scripts appends the following configuration section to your $SSHD_CONFIG. Are you okay with that? (yes/no)

Match User git
│ AuthorizedKeysCommand ${DIR}/authorized_keys.sh
│ AuthorizedKeysCommandUser root
EOT

read user_input

if [[ "$user_input" != 'yes' ]]; then
	echo "Aborting..."
	exit 1
fi

cat >>$SSHD_CONFIG <<EOT

Match User git 
  AuthorizedKeysCommand ${DIR}/authorized_keys.sh
  AuthorizedKeysCommandUser root
EOT

chown root:root $DIR/authorized_keys.sh
chmod 0755 $DIR/authorized_keys.sh
