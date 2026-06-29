# Wavelength SQL Refresher

A SQL refresher sprint working against the Wavelength listening database. Covers subqueries, CTEs, window functions, and CREATE TABLE AS.

## Setup

### 1. Create the database (if it does not already exist)

```bash
psql -c "CREATE DATABASE wavelength;"
```

### 2. Seed the database

```bash
psql -d wavelength -f seed.sql
```

This drops and recreates all tables, then inserts the full dataset. It is safe to run multiple times.

### 3. Verify

```bash
psql -d wavelength -c "SELECT COUNT(*) FROM listening_events;"
```

You should see a count of 18.

## Running queries

```bash
psql -d wavelength -f src/queries.sql
psql -d wavelength -f src/create_tables.sql
```
