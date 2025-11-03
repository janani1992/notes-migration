#!/bin/bash
set -e

echo "🔄 Starting database migration..."

# Configuration
: ${DATABASE_HOST:=postgres}
: ${DATABASE_PORT:=5432}
: ${DATABASE_NAME:=noteapp}
: ${DATABASE_USER:=user}
: ${POSTGRES_PASSWORD:=genLife}
: ${MIGRATION_MODE:=all}

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


echo "✅ PostgreSQL is up!"

# Function to run migrations from a directory
run_migrations() {
    local DIR=$1
    local DESC=$2
    
    if [ ! -d "$DIR" ]; then
        echo "⚠️  $DIR not found"
        return
    fi
    
    local SQL_FILES=$(ls $DIR/*.sql 2>/dev/null | sort)
    
    if [ -z "$SQL_FILES" ]; then
        echo "📦 $DESC: No migrations"
        return
    fi
    
    echo "📦 Running $DESC migrations..."
    
    for file in $SQL_FILES; do
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
    done
}


# Run based on mode
case "$MIGRATION_MODE" in
    all)
        run_migrations "/migrations/common" "Common"
        run_migrations "/migrations/app" "Application"
        run_migrations "/migrations/crdt" "CRDT"
        ;;
    app-only)
        run_migrations "/migrations/common" "Common"
        run_migrations "/migrations/app" "Application"
        ;;
    crdt-only)
        run_migrations "/migrations/common" "Common"
        run_migrations "/migrations/crdt" "CRDT"
        ;;
    *)
        echo "❌ Invalid mode: $MIGRATION_MODE"
        exit 1
        ;;
esac

echo "✅ Migrations complete!"