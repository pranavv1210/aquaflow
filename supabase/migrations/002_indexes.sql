create index idx_orders_customer_id on public.orders (customer_id);
create index idx_orders_order_date on public.orders (order_date);
create index idx_orders_payment_status on public.orders (payment_status);
create index idx_orders_delivery_status on public.orders (delivery_status);
create index idx_orders_vehicle_id on public.orders (vehicle_id);
create index idx_orders_driver_id on public.orders (driver_id);
create index idx_orders_partner_tanker_id on public.orders (partner_tanker_id);

create index idx_locations_name on public.locations (name);

create index idx_customers_display_name on public.customers (display_name);
create index idx_customers_phone on public.customers (phone);

create index idx_drivers_phone on public.drivers (phone);

create index idx_vehicles_registration_number on public.vehicles (registration_number);

create index idx_expenses_expense_date on public.expenses (expense_date);
create index idx_expenses_expense_category_id on public.expenses (expense_category_id);
