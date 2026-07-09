create extension if not exists pgcrypto;

create type public.payment_status as enum (
  'unpaid',
  'partial',
  'paid'
);

create type public.delivery_status as enum (
  'order_received',
  'assigned',
  'on_the_way',
  'delivered'
);

create type public.vehicle_status as enum (
  'available',
  'busy',
  'inactive'
);

create type public.vehicle_type as enum (
  'tractor',
  'canter',
  'partner'
);

create type public.expense_type as enum (
  'diesel',
  'driver_payment',
  'service',
  'repair',
  'police',
  'tyre',
  'other'
);

create type public.delivery_type as enum (
  'own_vehicle',
  'partner_tanker'
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table public.locations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  notes text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint locations_name_not_blank check (length(btrim(name)) > 0)
);

create table public.water_points (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  location_id uuid references public.locations(id) on delete set null,
  notes text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint water_points_name_not_blank check (length(btrim(name)) > 0)
);

create table public.customers (
  id uuid primary key default gen_random_uuid(),
  display_name text not null,
  phone text,
  default_location_id uuid references public.locations(id) on delete set null,
  address text,
  notes text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint customers_display_name_not_blank check (length(btrim(display_name)) > 0)
);

create table public.drivers (
  id uuid primary key default gen_random_uuid(),
  driver_name text not null,
  phone text,
  status public.vehicle_status not null default 'available',
  notes text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint drivers_driver_name_not_blank check (length(btrim(driver_name)) > 0)
);

create table public.vehicles (
  id uuid primary key default gen_random_uuid(),
  vehicle_name text not null,
  registration_number text not null,
  vehicle_type public.vehicle_type not null,
  status public.vehicle_status not null default 'available',
  notes text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint vehicles_vehicle_name_not_blank check (length(btrim(vehicle_name)) > 0),
  constraint vehicles_registration_number_not_blank check (length(btrim(registration_number)) > 0),
  constraint vehicles_registration_number_unique unique (registration_number)
);

create table public.partner_tankers (
  id uuid primary key default gen_random_uuid(),
  owner_name text not null,
  phone text,
  vehicle_name text not null,
  registration_number text not null,
  notes text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint partner_tankers_owner_name_not_blank check (length(btrim(owner_name)) > 0),
  constraint partner_tankers_vehicle_name_not_blank check (length(btrim(vehicle_name)) > 0),
  constraint partner_tankers_registration_number_not_blank check (length(btrim(registration_number)) > 0),
  constraint partner_tankers_registration_number_unique unique (registration_number)
);

create table public.expense_categories (
  id uuid primary key default gen_random_uuid(),
  category_name text not null,
  expense_type public.expense_type not null,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint expense_categories_name_not_blank check (length(btrim(category_name)) > 0),
  constraint expense_categories_type_unique unique (expense_type)
);

create table public.business_settings (
  id uuid primary key default gen_random_uuid(),
  setting_key text not null,
  setting_value jsonb not null default '{}'::jsonb,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint business_settings_key_not_blank check (length(btrim(setting_key)) > 0),
  constraint business_settings_key_unique unique (setting_key)
);

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  order_date date not null,
  order_time time not null,
  customer_id uuid not null references public.customers(id) on delete restrict,
  location_id uuid not null references public.locations(id) on delete restrict,
  water_point_id uuid not null references public.water_points(id) on delete restrict,
  vehicle_id uuid references public.vehicles(id) on delete restrict,
  driver_id uuid references public.drivers(id) on delete restrict,
  partner_tanker_id uuid references public.partner_tankers(id) on delete restrict,
  delivery_type public.delivery_type not null,
  load_count integer not null,
  amount numeric(12, 2) not null,
  payment_status public.payment_status not null default 'unpaid',
  delivery_status public.delivery_status not null default 'order_received',
  remarks text,
  is_deleted boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint orders_load_count_minimum check (load_count >= 1),
  constraint orders_amount_positive check (amount > 0),
  constraint orders_own_vehicle_or_partner_tanker check (
    (
      delivery_type = 'own_vehicle'
      and vehicle_id is not null
      and driver_id is not null
      and partner_tanker_id is null
    )
    or
    (
      delivery_type = 'partner_tanker'
      and partner_tanker_id is not null
      and vehicle_id is null
      and driver_id is null
    )
  )
);

create table public.expenses (
  id uuid primary key default gen_random_uuid(),
  expense_date date not null,
  vehicle_id uuid not null references public.vehicles(id) on delete restrict,
  driver_id uuid references public.drivers(id) on delete set null,
  expense_category_id uuid not null references public.expense_categories(id) on delete restrict,
  amount numeric(12, 2) not null,
  remarks text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint expenses_amount_positive check (amount > 0)
);

create trigger set_locations_updated_at
before update on public.locations
for each row execute function public.set_updated_at();

create trigger set_water_points_updated_at
before update on public.water_points
for each row execute function public.set_updated_at();

create trigger set_customers_updated_at
before update on public.customers
for each row execute function public.set_updated_at();

create trigger set_drivers_updated_at
before update on public.drivers
for each row execute function public.set_updated_at();

create trigger set_vehicles_updated_at
before update on public.vehicles
for each row execute function public.set_updated_at();

create trigger set_partner_tankers_updated_at
before update on public.partner_tankers
for each row execute function public.set_updated_at();

create trigger set_expense_categories_updated_at
before update on public.expense_categories
for each row execute function public.set_updated_at();

create trigger set_business_settings_updated_at
before update on public.business_settings
for each row execute function public.set_updated_at();

create trigger set_orders_updated_at
before update on public.orders
for each row execute function public.set_updated_at();

create trigger set_expenses_updated_at
before update on public.expenses
for each row execute function public.set_updated_at();
