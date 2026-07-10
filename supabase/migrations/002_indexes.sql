create index idx_orders_customer_id_active on public.orders (customer_id) where is_deleted = false;
create index idx_orders_order_date_active on public.orders (order_date) where is_deleted = false;
create index idx_orders_payment_status_active on public.orders (payment_status) where is_deleted = false;
create index idx_orders_delivery_status_active on public.orders (delivery_status) where is_deleted = false;
create index idx_orders_vehicle_id on public.orders (vehicle_id);
create index idx_orders_driver_id on public.orders (driver_id);
create index idx_orders_partner_tanker_id on public.orders (partner_tanker_id);
create index idx_orders_order_date_delivery_status_active on public.orders (order_date, delivery_status) where is_deleted = false;
create index idx_orders_order_date_payment_status_active on public.orders (order_date, payment_status) where is_deleted = false;
create index idx_orders_customer_id_order_date_active on public.orders (customer_id, order_date) where is_deleted = false;

create index idx_locations_name on public.locations (name);
create index idx_locations_is_active on public.locations (is_active);

create index idx_customers_display_name on public.customers (display_name);
create index idx_customers_phone on public.customers (phone);
create index idx_customers_is_active on public.customers (is_active);
create index idx_customers_default_location_id on public.customers (default_location_id);

create index idx_drivers_phone on public.drivers (phone);
create index idx_drivers_is_active on public.drivers (is_active);

create unique index idx_vehicles_registration_number_unique_ci on public.vehicles (lower(btrim(registration_number)));
create index idx_vehicles_is_active on public.vehicles (is_active);

create unique index idx_partner_tankers_registration_number_unique_ci on public.partner_tankers (lower(btrim(registration_number)));
create index idx_partner_tankers_is_active on public.partner_tankers (is_active);

create index idx_water_points_location_id on public.water_points (location_id);
create index idx_water_points_is_active on public.water_points (is_active);

create index idx_expenses_expense_date on public.expenses (expense_date);
create index idx_expenses_expense_category_id on public.expenses (expense_category_id);
create index idx_expenses_vehicle_id on public.expenses (vehicle_id);
create index idx_expenses_driver_id on public.expenses (driver_id);
