# AquaFlow Production Data Migration Report

## Status

Migration planning completed. Production import not executed from this workspace because no Supabase project URL, service role key, or database connection string is present in the repository or environment files.

## Workbook Inventory

- Workbook: `water supply details.xlsx`
- Sheets discovered:
  - `Delivery`
  - `Pivot`
  - `Data`
  - `Customer Data`

## Worksheet Purpose

- `Data`: primary historical transaction ledger. This is the only worksheet with usable row-level business records for migration.
- `Customer Data`: customer name list used as a supporting reference sheet.
- `Pivot`: summary-style pivot output used for analysis, not source-of-truth row data.
- `Delivery`: summary-style pivot output used for analysis, not source-of-truth row data.

## Target Mapping

- Customers -> `customers`
- Locations -> `locations`
- Water points -> `water_points`
- Vehicles -> `vehicles`
- Drivers -> `drivers`
- Partner tankers -> `partner_tankers` only if uniquely identifiable; otherwise skip
- Orders -> `orders`
- Expenses -> `expenses`
- Expense categories -> reuse existing seeded categories

## Extracted Counts

- Total workbook rows in `Data`: 1,152 usable data rows
- Customer reference rows in `Customer Data`: 66
- Unique customers in `Data`: 154
- Unique locations in `Data`: 19
- Unique water points in `Data`: 9
- Unique driver names in `Data` via `Customer delivery`: 6
- Vehicles observed in `Data`: 2 (`Tractor`, `Canter`)
- Order-like rows: 1,152
- Rows with expense columns populated: 37
- Discrete expense entries detected across expense columns: 54
- Rows with `Water Sales` populated: 6

## Field Observations

- `Data` columns:
  - `Week`
  - `Day`
  - `Vehicle`
  - `Load count`
  - `Date`
  - `Month`
  - `Customer`
  - `Location`
  - `Water point`
  - `Customer delivery`
  - `Cost`
  - `Payment Status`
  - `Remarks`
  - `Water Sales`
  - `Mobile`
  - `Diesel Expenses`
  - `Driver Expenses`
  - `Police`
  - `Vehicle Service and Expenses`
  - `Remarks 2`

- `Payment Status` values observed:
  - `Recd`
  - `Pending`
  - lowercase variants `recd` and `pending`

- `Remarks` values observed:
  - `Open Bal`
  - `Vehicle Stationed`
  - `100 pending`
  - `Driver mobile recharge`
  - `cash`
  - `300 pending - Recd`
  - `cash with gangadhar`
  - `Confussion in customer`
  - `Manju customer SLV`

## Safe Normalization Rules

- Trim leading and trailing whitespace.
- Collapse duplicate internal spaces to one space.
- Preserve original business meaning.
- Normalize case only when comparing for duplicates.
- Normalize phone numbers only if a phone value exists in the source.
- Normalize registration numbers only when a registration number exists in the source.
- Normalize customer, location, and water point names only for duplicate detection.

## Duplicate Review

- No safe customer duplicates were found by case/space normalization.
- No safe location duplicates were found by case/space normalization.
- Water point case-only duplicates found:
  - `Hari` / `hari`
  - `Manju` / `manju`
  - `Anjan` / `anjan`
  - `Mukesh` / `mukesh`
  - `ram` / `Ram`
  - `Muniraj` / `muniraj`
- Driver case-only duplicates found:
  - `Hari` / `hari`

## Relationship Findings

- Customers frequently map to a single dominant location, but 16 customers span multiple locations, so default-location inference must be conservative.
- Water points are not single-location entities in the source data; every water point name spans multiple locations, so `water_points.location_id` should only be populated when a row-level match is explicit.
- Drivers also span multiple locations, so no automatic driver-location assumption should be made.

## Schema Mismatches / Blockers

1. `orders.load_count` historically required values `>= 1`, but the workbook contains 23 rows with `load_count = 0`.
2. The schema and app validation have been updated in the repository to allow `load_count >= 0` so those historical rows can be imported faithfully.
3. `vehicles.registration_number` is required in the schema, but the workbook does not provide registration numbers; placeholder registrations are acceptable per the migration instruction.
4. `partner_tankers.registration_number` is also required, but no unique partner tanker identifiers are present in the workbook.
5. Many rows have ambiguous or missing `Water point`, `Vehicle`, `Customer delivery`, or `Location` associations when interpreted as strict foreign keys.

## Recommended Import Plan

1. Read the workbook into in-memory models.
2. Build normalized unique sets for customers, locations, water points, vehicles, drivers, orders, and expenses.
3. Reuse seeded expense categories; do not create new categories.
4. Map each `Data` row to one historical order record.
5. Derive `paid_amount` from source values using workbook status rules only.
6. Insert reference tables first, then orders, then expenses.
7. Validate foreign keys in-memory before each insert batch.
8. Run transactional inserts with rollback on failure.
9. Generate a second pass reconciliation report after import.

## Payment Handling Rules

- `Recd` -> treat as paid where the source row supports a full payment.
- `Pending` -> `paid_amount = 0` unless an exact partial amount is explicitly present.
- Partial payment rows were not explicitly identifiable in the source scan, so partial amounts should not be invented.

## Expense Handling Rules

- Create one expense row for each populated expense entry.
- Reuse these seeded categories:
  - `Diesel`
  - `Driver Payment`
  - `Service`
  - `Repair`
  - `Police`
  - `Tyre`
  - `Other`
- Preserve remarks from `Remarks 2` and related notes.

## Verification Checklist

- Confirm every imported order maps to an existing customer, location, and water point.
- Confirm all foreign keys resolve before writing.
- Confirm dashboard aggregates derive from imported rows only.
- Confirm pending-payment totals match the imported data.
- Confirm customer, vehicle, location, water point, and expense category dropdowns are populated from persisted records.

## Totals To Report After Import

- Total Customers
- Total Orders
- Total Vehicles
- Total Drivers
- Total Locations
- Total Water Points
- Total Expenses
- Duplicates merged
- Warnings
- Rows skipped
- Reasons
- Manual review items

## Current Outcome

- Migration plan prepared.
- Repository schema and app validation updated for zero-load historical rows.
- Production import not executed in this workspace.
- No data was written.
- No rows were deleted or modified.