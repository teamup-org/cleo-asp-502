#!/bin/bash

# Variables
TIMESTAMP=$(date +\%Y\%m\%d-\%H\%M\%S)
BACKUP_DIR="./backups"
FILENAME="backup-$TIMESTAMP.sql"
DATABASE_URL=$(cat .env | grep DATABASE_URL | cut -d '=' -f2)

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

# Backup the database
pg_dump $DATABASE_URL -F c -f "$BACKUP_DIR/$FILENAME"

# Log
echo "✅ Backup completed: $FILENAME"

# Delete backups older than 24 hours
find $BACKUP_DIR -type f -name "backup-*.sql" -mmin +1440 -delete

echo "🗑️ Old backups deleted (older than 24h)"
