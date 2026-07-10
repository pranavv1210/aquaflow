alter table public.orders
  drop constraint if exists orders_load_count_minimum;

alter table public.orders
  add constraint orders_load_count_minimum check (load_count >= 0);