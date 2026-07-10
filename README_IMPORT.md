# AquaFlow Historical Excel Import

This repository includes a one-time historical data import tool for the workbook `water supply details.xlsx`.

## Install

```powershell
pip install -r requirements.txt
```

## Configure

Create a local `.env` file with:

```dotenv
SUPABASE_URL=
SUPABASE_SERVICE_ROLE_KEY=
```

`SUPABASE_ANON_KEY` may be present in the workspace `.env`, but the import tool is designed to use the service role key for production writes.

## Run

```powershell
python tools/import_excel.py
```

Optional arguments:

```powershell
python tools/import_excel.py --workbook "water supply details.xlsx" --report migration_report.md
```

## What It Does

1. Reads every worksheet in the workbook.
2. Uses only the `Data` sheet for historical transactions.
3. Reuses existing Supabase records when possible.
4. Inserts locations, water points, customers, drivers, vehicles, orders, and expenses.
5. Writes `migration_report.md` with counts, warnings, skipped rows, and verification results.

## Verification

After import, the tool queries Supabase and prints counts for:

- Customers
- Locations
- Water Points
- Drivers
- Vehicles
- Orders
- Expenses

If a table insert fails, the tool rolls back the rows written for that table and continues with the remaining tables when it is safe to do so.