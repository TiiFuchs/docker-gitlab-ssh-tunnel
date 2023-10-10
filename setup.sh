#!/bin/bash

DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
SSHD_CONFIG="/etc/ssh/sshd_config"

# =======================================
# Create user if it does not exist
# =======================================

if ! id git &>/dev/null; then

	# Create user `git`
	adduser --system --shell /bin/bash git

	# Add git user to docker group
	adduser git docker

else

	echo "git user already exists. Skipping..."

fi

# =======================================
# Add Match User directive to sshd_config
# =======================================

if ! grep -q 'Match User git' "$SSHD_CONFIG"; then

	cat >>$SSHD_CONFIG <<EOT

Match User git
  AuthorizedKeysCommand ${DIR}/authorized_keys.sh
  AuthorizedKeysCommandUser git
EOT

else

	echo "There is already a configuration for the user git in ${SSHD_CONFIG}. Skipping..."

fi

# =======================================
# Set rights
# =======================================

chown root:root $DIR/authorized_keys.sh
chmod 0755 $DIR/authorized_keys.sh
