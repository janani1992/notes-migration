FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY migration.sh /app/
COPY migrations/ /migrations/

RUN chmod +x /app/migration.sh

ENTRYPOINT ["/app/migration.sh"]