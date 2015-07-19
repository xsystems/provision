#!/bin/sh

[ -z "$HOSTNAME" ] && HOSTNAME=$(uname -n)

SERVER_NAME="xsystems.org"
SERVER_PATH="/media/data/backup/kboes/laptop/linux/duplicity"

src="/home/${USER}"
des="sftp://${USER}@${SERVER_NAME}/${SERVER_PATH}"
name="${USER}@${HOSTNAME}"
encrypt_key="3DC72EB0"
sign_key="6CE9CD46"
log_file="/home/${USER}/log/duplicity_$(date --iso-8601=seconds).log"
volsize="250"
retries="3"
full_interval="1M"
full_keep="2"
verbosity="notice"
file_selection=$(cat <<-EOF
    --exclude-if-present .git
    --exclude-if-present .svn
    --exclude ${src}/doc/dropbox
    --exclude ${src}/project/wh_data
    --exclude ${src}/project/goabout/misc/data
    --include ${src}/doc
    --include ${src}/key
    --include ${src}/.lastpass
    --include ${src}/.pki
    --include ${src}/project
    --include ${src}/.remina
    --include ${src}/.ssh
EOF
)

backup_run () {
    duplicity \
    --allow-source-mismatch \
    --full-if-older-than=$full_interval \
    --name=$name \
    --log-file=$log_file \
    --use-agent \
    --encrypt-key=$encrypt_key \
    --sign-key=$sign_key \
    --num-retries=$retries \
    --verbosity=$verbosity \
    --volsize $volsize \
    --asynchronous-upload \
    $3 \
    --exclude "**" \
    $1 $2
}

backup_remove_old () {
    duplicity \
    remove-all-but-n-full $full_keep \
    --allow-source-mismatch \
    --name=$name \
    --log-file=$log_file \
    --use-agent \
    --encrypt-key=$encrypt_key \
    --sign-key=$sign_key \
    --num-retries=$retries \
    --verbosity=$verbosity \
    --force \
    $des 
}

backup_verify () {
    duplicity \
    verify \
    --allow-source-mismatch \
    --use-agent \
    --encrypt-key=$encrypt_key \
    --sign-key=$sign_key \
    $des "${src}/tmp/duplicity"
}

. $HOME/.ssh-agent.socket
export DISPLAY=:0
echo "Running the backup:"
notify-send "Backup Started" "${src}"
backup_run $src $des "$file_selection"
echo "Removing old backups:"
backup_remove_old $des
notify-send "Backup Finished" "${src}"
