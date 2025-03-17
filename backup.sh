#!/bin/bash

# Variables
TIMESTAMP=$(date +\%Y\%m\%d-\%H\%M\%S)
BACKUP_DIR="./backups"
FILENAME="backup-$TIMESTAMP.sql"

# Automatically determine DATABASE_URL
if [ -z "$DATABASE_URL" ]; then
  if [ -f .env ]; then
    DATABASE_URL=$(grep -E '^DATABASE_URL=' .env | cut -d '=' -f2)
  else
    echo "❌ Error: DATABASE_URL not set and no .env file found!"
    exit 1
  fi
fi

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

# Backup the database
pg_dump $DATABASE_URL -F c -f "$BACKUP_DIR/$FILENAME"

# Log
echo "✅ Backup completed: $FILENAME"

# Delete backups older than 24 hours
find $BACKUP_DIR -type f -name "backup-*.sql" -mmin +1440 -delete

echo "🗑️ Old backups deleted (older than 24h)"

##       MAKE SURE TO UPDATE .env WITH YOUR DATABASE_URL
# e.g.                              "DATABASE_URL=postgresql://josh@localhost:5432/josh"

##       TO BACKUP--
# Check the backups/ directory:     ls -l backups/
# You should see a file like:       backup-20250316-123456.sql
# If you want to restore the backup to your existing local database (josh), 
# run:                              pg_restore -d josh -U josh -1 backups/backup-20250316-123456.sql
#       -d josh → Restore to database josh
#       -U josh → Use username josh
#       -1 → Run inside a transaction (ensures safety)


