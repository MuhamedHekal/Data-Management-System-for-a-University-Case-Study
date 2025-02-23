#!/bin/bash

# Set environment (use service name instead of SID)
export ORACLE_SID="FREE"  # Replace with your service name
export ORAENV_ASK=NO
. oraenv

# Variables
ORACLE_USER="CDS"
ORACLE_PASSWORD="cds"
BACKUP_DIR="/opt/oracle/oradata/backup/differential"
TIMESTAMP=$(date +"%F-%H%M")
LOG_FILE="differential_backup_$TIMESTAMP.log"
DUMP_FILE="diff_backup_$TIMESTAMP.dmp"

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

# Perform Differential Data Pump Export
expdp $ORACLE_USER/$ORACLE_PASSWORD@FREEPDB1 schemas=$ORACLE_USER directory=DATA_PUMP_DIR \
    dumpfile=$DUMP_FILE logfile=$LOG_FILE \
    include=TABLE,INDEX,CONSTRAINT,TRIGGER \
    query="'WHERE last_modified >= SYSDATE-1'"

# Move backup files to backup directory
mv /opt/oracle/admin/FREE/dpdump/$DUMP_FILE $BACKUP_DIR/ 2>/dev/null
mv /opt/oracle/admin/FREE/dpdump/$LOG_FILE $BACKUP_DIR/ 2>/dev/null

# Remove backups older than 4 weeks
find $BACKUP_DIR -type f -name "diff_backup_*.dmp" -mtime +28 -exec rm {} \;

echo "Differential backup completed: $BACKUP_DIR/$DUMP_FILE"