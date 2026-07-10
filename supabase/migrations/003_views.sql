create view public.todays_revenue as
select
  current_date as revenue_date,
  coalesce(sum(amount), 0)::numeric(12, 2) as total_revenue,
  count(*)::integer as order_count,
  coalesce(sum(load_count), 0)::integer as total_loads
from public.orders
where order_date = current_date
  and is_deleted = false
  and delivery_status = 'delivered';

create view public.todays_expenses as
select
  current_date as expense_date,
  coalesce(sum(amount), 0)::numeric(12, 2) as total_expenses,
  count(*)::integer as expense_count
from public.expenses
where expense_date = current_date;

create view public.todays_profit as
select
  r.revenue_date as profit_date,
  r.total_revenue,
  e.total_expenses,
  (r.total_revenue - e.total_expenses)::numeric(12, 2) as total_profit
from public.todays_revenue r
cross join public.todays_expenses e;

create view public.pending_payments as
select
  o.id as order_id,
  o.order_number,
  o.order_date,
  o.customer_id,
  c.display_name as customer_name,
  o.amount,
  o.paid_amount,
  (o.amount - o.paid_amount)::numeric(12, 2) as pending_amount,
  o.payment_status,
  o.delivery_status,
  o.load_count
from public.orders o
join public.customers c on c.id = o.customer_id
where o.is_deleted = false
  and (o.amount - o.paid_amount) > 0;

create view public.monthly_revenue as
select
  date_trunc('month', order_date)::date as month_start,
  coalesce(sum(amount), 0)::numeric(12, 2) as total_revenue,
  count(*)::integer as order_count,
  coalesce(sum(load_count), 0)::integer as total_loads
from public.orders
where is_deleted = false
  and delivery_status = 'delivered'
group by date_trunc('month', order_date)::date;

create view public.vehicle_performance as
select
  v.id as vehicle_id,
  v.vehicle_name,
  v.registration_number,
  count(o.id)::integer as order_count,
  coalesce(sum(o.load_count), 0)::integer as total_loads,
  coalesce(sum(o.amount), 0)::numeric(12, 2) as total_revenue
from public.vehicles v
left join public.orders o
  on o.vehicle_id = v.id
  and o.is_deleted = false
  and o.delivery_type = 'own_vehicle'
group by v.id, v.vehicle_name, v.registration_number;

create view public.driver_performance as
select
  d.id as driver_id,
  d.driver_name,
  count(o.id)::integer as order_count,
  coalesce(sum(o.load_count), 0)::integer as total_loads,
  coalesce(sum(o.amount), 0)::numeric(12, 2) as total_revenue
from public.drivers d
left join public.orders o
  on o.driver_id = d.id
  and o.is_deleted = false
  and o.delivery_type = 'own_vehicle'
group by d.id, d.driver_name;

create view public.customer_summary as
select
  c.id as customer_id,
  c.display_name,
  c.phone,
  count(o.id)::integer as total_orders,
  coalesce(sum(o.amount) filter (where o.delivery_status = 'delivered'), 0)::numeric(12, 2) as total_revenue,
  coalesce(sum(o.amount - o.paid_amount) filter (where (o.amount - o.paid_amount) > 0), 0)::numeric(12, 2) as pending_amount,
  max(o.order_date) as last_order_date
from public.customers c
left join public.orders o
  on o.customer_id = c.id
  and o.is_deleted = false
group by c.id, c.display_name, c.phone;
