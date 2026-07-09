alter table public.locations enable row level security;
alter table public.water_points enable row level security;
alter table public.customers enable row level security;
alter table public.drivers enable row level security;
alter table public.vehicles enable row level security;
alter table public.partner_tankers enable row level security;
alter table public.expense_categories enable row level security;
alter table public.business_settings enable row level security;
alter table public.orders enable row level security;
alter table public.expenses enable row level security;

comment on table public.locations is
  'RLS enabled. Version 1 policy allows anon/authenticated access because AquaFlow is a single-owner app without login.';
comment on table public.water_points is
  'RLS enabled. Version 1 policy allows anon/authenticated access because AquaFlow is a single-owner app without login.';
comment on table public.customers is
  'RLS enabled. Version 1 policy allows anon/authenticated access because AquaFlow is a single-owner app without login.';
comment on table public.drivers is
  'RLS enabled. Version 1 policy allows anon/authenticated access because AquaFlow is a single-owner app without login.';
comment on table public.vehicles is
  'RLS enabled. Version 1 policy allows anon/authenticated access because AquaFlow is a single-owner app without login.';
comment on table public.partner_tankers is
  'RLS enabled. Version 1 policy allows anon/authenticated access because AquaFlow is a single-owner app without login.';
comment on table public.expense_categories is
  'RLS enabled. Version 1 policy allows anon/authenticated access because AquaFlow is a single-owner app without login.';
comment on table public.business_settings is
  'RLS enabled. Version 1 policy allows anon/authenticated access because AquaFlow is a single-owner app without login.';
comment on table public.orders is
  'RLS enabled. Version 1 policy allows anon/authenticated access because AquaFlow is a single-owner app without login.';
comment on table public.expenses is
  'RLS enabled. Version 1 policy allows anon/authenticated access because AquaFlow is a single-owner app without login.';

create policy "single owner access locations"
on public.locations
for all
to anon, authenticated
using (true)
with check (true);

create policy "single owner access water points"
on public.water_points
for all
to anon, authenticated
using (true)
with check (true);

create policy "single owner access customers"
on public.customers
for all
to anon, authenticated
using (true)
with check (true);

create policy "single owner access drivers"
on public.drivers
for all
to anon, authenticated
using (true)
with check (true);

create policy "single owner access vehicles"
on public.vehicles
for all
to anon, authenticated
using (true)
with check (true);

create policy "single owner access partner tankers"
on public.partner_tankers
for all
to anon, authenticated
using (true)
with check (true);

create policy "single owner access expense categories"
on public.expense_categories
for all
to anon, authenticated
using (true)
with check (true);

create policy "single owner access business settings"
on public.business_settings
for all
to anon, authenticated
using (true)
with check (true);

create policy "single owner access orders"
on public.orders
for all
to anon, authenticated
using (true)
with check (true);

create policy "single owner access expenses"
on public.expenses
for all
to anon, authenticated
using (true)
with check (true);

grant usage on schema public to anon, authenticated;

grant select, insert, update, delete on
  public.locations,
  public.water_points,
  public.customers,
  public.drivers,
  public.vehicles,
  public.partner_tankers,
  public.expense_categories,
  public.business_settings,
  public.orders,
  public.expenses
to anon, authenticated;

grant select on
  public.todays_revenue,
  public.todays_expenses,
  public.todays_profit,
  public.pending_payments,
  public.monthly_revenue,
  public.vehicle_performance,
  public.driver_performance,
  public.customer_summary
to anon, authenticated;
