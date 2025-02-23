#!/bin/bash

# Set environment
export ORACLE_SID="FREE"
export ORAENV_ASK=NO
. oraenv

# Variables
ORACLE_USER="CDS"
ORACLE_PASSWORD="cds"
ORACLE_SERVICE="FREEPDB1"  # Ensure this is the correct service name
BACKUP_DIR="/opt/oracle/oradata/backup/full"
TIMESTAMP=$(date +"%F-%H%M")
LOG_FILE="full_backup_$TIMESTAMP.log"
DUMP_FILE="full_backup_$TIMESTAMP.dmp"

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

# Perform full database backup with correct service name
expdp $ORACLE_USER/$ORACLE_PASSWORD@$ORACLE_SERVICE full=y directory=DATA_PUMP_FULL_DIR \
    dumpfile=$DUMP_FILE logfile=$LOG_FILE

# Move backup files to backup directory
mv /opt/oracle/admin/FREE/dpdump/$DUMP_FILE $BACKUP_DIR/ 2>/dev/null
mv /opt/oracle/admin/FREE/dpdump/$LOG_FILE $BACKUP_DIR/ 2>/dev/null

# Remove older full backups (keep only the latest one)
find $BACKUP_DIR -type f -name "full_backup_*.dmp" -mtime +35 -exec rm {} \;

echo "Full backup completed: $BACKUP_DIR/$DUMP_FILE"