# AquaFlow Domain Design

Phase 1B defines the business domain only. It does not create database tables,
SQL, Supabase queries, repositories, providers, CRUD, or UI behavior.

## Business Principle

AquaFlow is built for a single water tanker business owner.

The owner enters business data once and reuses it forever. Customers, drivers,
vehicles, locations, water points, partner tankers, and expense categories are
master data. Orders use this master data instead of repeating names and details
again and again.

## Order Workflow

1. Customer calls.
2. Owner searches an existing customer or adds a new customer.
3. Owner selects a location.
4. Owner selects a water point.
5. Owner selects an own vehicle and driver, or selects a partner tanker.
6. Owner enters load count.
7. Owner enters order amount.
8. Owner selects payment status.
9. Owner selects delivery status.
10. Owner saves the order.

Everything important for analytics will later come from orders and expenses.

## Aggregate Root

### Order

Order is the aggregate root of the core business workflow.

Fields:

- Order ID
- Date
- Time
- Customer ID
- Location ID
- Water Point ID
- Vehicle ID, optional when a partner tanker is selected
- Driver ID, optional when a partner tanker is selected
- Partner ID, optional when an own vehicle is selected
- Load Count
- Amount
- Payment Status
- Delivery Status
- Remarks
- Created At
- Updated At

Order stores references to master records by ID. It should not duplicate the
customer name, driver name, vehicle number, location name, or water point name.

## Master Entities

### Customer

Customer represents a person or business that orders water.

Fields:

- Customer ID
- Display Name
- Phone Number, optional
- Default Location ID, optional
- Address, optional
- Notes, optional
- Created At
- Updated At

Do not store total orders, pending amount, or revenue on Customer. These are
calculated from orders.

### Vehicle

Vehicle represents an own tanker or business vehicle.

Fields:

- Vehicle ID
- Vehicle Name
- Registration Number
- Vehicle Type
- Status
- Notes, optional
- Created At
- Updated At

### Driver

Driver represents a driver who can be assigned to an own vehicle order.

Fields:

- Driver ID
- Driver Name
- Phone, optional
- Status
- Notes, optional
- Created At
- Updated At

### Partner Tanker

Partner Tanker represents an external tanker owner or vehicle used when the
business uses outside capacity.

Fields:

- Partner ID
- Owner Name
- Phone, optional
- Vehicle Name
- Registration Number
- Notes, optional
- Created At
- Updated At

### Location

Location groups customers and water points by area.

Fields:

- Location ID
- Location Name
- Notes, optional

### Water Point

Water Point represents a supply point or delivery-related water source.

Fields:

- Water Point ID
- Water Point Name
- Location ID, optional
- Notes, optional

### Expense Category

Expense Category represents reusable categories for expense entry.

Fields:

- Expense Category ID
- Category Name
- Expense Type
- Description, optional

Default category examples:

- Diesel
- Driver Payment
- Service
- Repair
- Police
- Tyre
- Other

## Expense Entity

Expense records money spent by the business.

Fields:

- Expense ID
- Date
- Vehicle ID
- Driver ID, optional
- Expense Category ID
- Amount
- Remarks, optional
- Created At
- Updated At

Expenses are tracked separately from orders. They can later support profit and
cost analytics, but those values are calculated and not stored on master data.

## Enums

### PaymentStatus

- Unpaid
- Partial
- Paid

### DeliveryStatus

- OrderReceived
- Assigned
- OnTheWay
- Delivered

### VehicleStatus

- Available
- Busy
- Inactive

### DriverStatus

- Available
- Busy
- Inactive

### VehicleType

- Tractor
- Canter
- Partner

### ExpenseType

- Diesel
- DriverPayment
- Service
- Repair
- Police
- Tyre
- Other

## Value Objects

### Money

Represents an amount of money. Formatting is not part of the domain object.

### PhoneNumber

Represents a phone number. Phone is optional for customers, drivers, and
partners.

### BusinessDate

Represents the business date of an order or expense.

### BusinessTime

Represents the business time of an order.

## Relationships

- Order belongs to one Customer.
- Order belongs to one Location.
- Order belongs to one Water Point.
- Order can use one own Vehicle.
- Order can use one Driver when an own Vehicle is used.
- Order can use one Partner Tanker instead of an own Vehicle.
- Customer can have one default Location.
- Water Point can belong to one Location.
- Expense belongs to one Vehicle.
- Expense can belong to one Driver.
- Expense belongs to one Expense Category.

## Validation Rules

- Customer name is required.
- Order date is required.
- Order time is required.
- Customer is required for an order.
- Location is required for an order.
- Water point is required for an order.
- Amount must be greater than 0.
- Load count must be at least 1.
- Select either an own vehicle or a partner tanker.
- Own vehicle is optional only when partner tanker is selected.
- Partner tanker is optional only when own vehicle is selected.
- Driver is required when an own vehicle is selected.
- Phone number is optional.
- Remarks are optional.

## Calculated Fields

Do not store these values:

- Week
- Day
- Month
- Revenue
- Pending Amount
- Profit
- Total Orders

These values must be calculated from orders and expenses when analytics,
reports, and dashboards are implemented.

## Future Scalability

The domain keeps business data normalized and reusable. This allows later
database design to avoid duplicated names and inconsistent records.

Orders should remain the source of truth for operational analytics. Master data
should describe reusable business objects. Expenses should remain separate from
orders so profit and cost reporting can evolve without changing order history.
