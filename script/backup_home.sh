#!/bin/sh

[ -z "$HOSTNAME" ] && HOSTNAME=$(uname -n)
[ -f $HOME/.keychain/$HOSTNAME-sh ] && . $HOME/.keychain/$HOSTNAME-sh
[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && . $HOME/.keychain/$HOSTNAME-sh-gpg

SERVER_NAME="xsystems.org"
SERVER_PATH="/media/data/backup/kboes/laptop/linux/duplicity"

src="/home/${USER}"
des="sftp://${USER}@${SERVER_NAME}/${SERVER_PATH}"
name="${USER}@${HOSTNAME}"
encrypt_key="5F056B4F"
sign_key="53436B86"
log_file="/home/${USER}/log/duplicity.log"
volsize="250"
retries="3"
full_interval="1M"
full_keep="2"
verbosity="notice"

file_selection=$(cat <<EOF
--exclude /home/${USER}/aur
--exclude /home/${USER}/bin
--exclude /home/${USER}/opt
--exclude /home/${USER}/media
--exclude /home/${USER}/misc
--exclude /home/${USER}/downloads
--exclude /home/${USER}/Downloads
--exclude /home/${USER}/.m2
--exclude /home/${USER}/.vagrant.d
--exclude /home/${USER}/.cache
--exclude /home/${USER}/.mozilla
--exclude /home/${USER}/.PlayOnLinux
--exclude /home/${USER}/node_modules
--exclude /home/${USER}/tmp
--exclude /home/${USER}/temp
EOF
)

backup_cmd_run=$(cat <<EOF
duplicity
--full-if-older-than=$full_interval
--name=$name
--log-file=$log_file
--use-agent
--encrypt-key=$encrypt_key
--sign-key=$sign_key
--num-retries=$retries
--verbosity=$verbosity
--volsize $volsize
--asynchronous-upload
$file_selection
$src $des
EOF
)

backup_cmd_remove=$(cat <<EOF
duplicity   
remove-all-but-n-full $full_keep
--name=$name
--log-file=$log_file
--use-agent
--encrypt-key=$encrypt_key
--sign-key=$sign_key
--num-retries=$retries
--verbosity=$verbosity
--force
$des
EOF
)

echo "Running the backup:"
exec $backup_cmd_run
echo "Removing old backups:"
exec $backup_cmd_remove
