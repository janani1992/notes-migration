#!/bin/bash
set -e

echo "🔄 Starting database migration..."

# Wait for PostgreSQL
echo "⏳ Waiting for PostgreSQL..."
until PGPASSWORD=$POSTGRES_PASSWORD psql \
    -h "$DATABASE_HOST" \
    -U "$DATABASE_USER" \
    -d "$DATABASE_NAME" \
    -c '\q' 2>/dev/null; do
  echo "   Retrying in 2s..."
  sleep 2
done


echo "✅ PostgreSQL is up! (Version: Debug-NoFunction)"

# Direct logic for app migrations to avoid function issues
MIGRATION_DIR="/migrations/app"

if [ -d "$MIGRATION_DIR" ]; then
    echo "📦 Running Application migrations..."
    
    # Use find to safely list files, loop over them
    # We sort the output of find to ensure order
    
    # Note: If no files exist, find returns nothing.
    # We use temporary file to handle list safely
    
    find "$MIGRATION_DIR" -name "*.sql" | sort > /tmp/migrations.list
    
    while IFS= read -r file; do
        filename=$(basename "$file")
        echo "  ▶️  $filename"
        
        PGPASSWORD=$POSTGRES_PASSWORD psql \
            -h "$DATABASE_HOST" \
            -U "$DATABASE_USER" \
            -d "$DATABASE_NAME" \
            -f "$file" \
            --single-transaction \
            --set ON_ERROR_STOP=on
            
        echo "  ✅ $filename"
    done < /tmp/migrations.list
    
    rm /tmp/migrations.list
else
    echo "⚠️  $MIGRATION_DIR not found"
fi

echo "✅ Migrations complete!"