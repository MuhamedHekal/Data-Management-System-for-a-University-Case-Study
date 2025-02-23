#!/bin/bash

# Set environment
export ORACLE_SID="FREE"
export ORAENV_ASK=NO
. oraenv

# Variables
BACKUP_DIR="/opt/oracle/oradata/backup/transactional"
TIMESTAMP=$(date +"%F-%H%M")
LOG_FILE="$BACKUP_DIR/transaction_backup_$TIMESTAMP.log"

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

# Backup only the latest day's transactions
rman target / <<EOF > $LOG_FILE
RUN {
    BACKUP ARCHIVELOG FROM TIME 'SYSDATE-1' FORMAT '$BACKUP_DIR/archivelog_%d_%T_%U.bak';
    DELETE ARCHIVELOG ALL COMPLETED BEFORE 'SYSDATE-1';
}
EXIT;
EOF

# Remove backups older than 30 days
find $BACKUP_DIR -type f -name "archivelog_*.bak" -mtime +30 -exec rm {} \;

echo "Transactional backup completed at $(date). Log file: $LOG_FILE"
