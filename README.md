# Notes Migration Setup

This repository contains database migration scripts for the Notes application, supporting both application and CRDT schemas.

## 🏗️ Structure

```
├── docker-compose.yml       # Docker services configuration
├── Dockerfile              # Migration container setup  
├── migration.sh            # Main migration script
├── .env                    # Environment variables
└── migrations/
    ├── common/             # Shared migrations (extensions, schemas)
    ├── app/               # Application-specific migrations
    └── crdt/              # CRDT service migrations
```

## 🚀 Usage

### Run All Migrations
```bash
docker-compose up migrate
```

### Run Application Migrations Only
```bash
docker-compose run -e MIGRATION_MODE=app-only migrate
```

### Run CRDT Migrations Only
```bash
docker-compose run -e MIGRATION_MODE=crdt-only migrate
```

## 🔧 Configuration

Environment variables (`.env`):
- `POSTGRES_PASSWORD`: Database password
- `POSTGRES_USER`: Database user
- `POSTGRES_HOST`: Database host (use 'database' for Docker Compose)
- `POSTGRES_DB`: Database name

Migration modes:
- `all` (default): Run common, app, and CRDT migrations
- `app-only`: Run common and app migrations
- `crdt-only`: Run common and CRDT migrations

## 📋 Migration Script Features

- ✅ Waits for PostgreSQL to be ready
- ✅ Runs migrations in chronological order
- ✅ Uses transactions for each migration
- ✅ Stops on first error
- ✅ Supports multiple migration modes
- ✅ Clear progress logging

## 🔍 Troubleshooting

**Connection Issues:**
- Ensure PostgreSQL is running: `docker-compose up database`
- Check environment variables in `.env`
- Verify network connectivity between services

**Migration Failures:**
- Check migration file syntax
- Review PostgreSQL logs: `docker-compose logs database`
- Ensure proper file permissions

## 🗂️ Adding New Migrations

1. Create SQL file in appropriate directory (`app/` or `crdt/`)
2. Use naming convention: `YYYYMMDD_HHMMSS_description.sql`
3. Test migration locally before committing
4. Use transactions and include rollback strategy

Example:
```sql
-- 20251103_120000_add_user_index.sql
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_users_email 
ON users(email) WHERE active = true;
```