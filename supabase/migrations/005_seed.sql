insert into public.expense_categories (category_name, expense_type, description)
values
  ('Diesel', 'diesel', 'Fuel expenses for tankers and business vehicles.'),
  ('Driver Payment', 'driver_payment', 'Payments made to drivers.'),
  ('Service', 'service', 'Scheduled vehicle service and maintenance.'),
  ('Repair', 'repair', 'Vehicle or equipment repair expenses.'),
  ('Police', 'police', 'Police or route-related payments.'),
  ('Tyre', 'tyre', 'Tyre purchase, puncture, and tyre repair expenses.'),
  ('Other', 'other', 'Other business expenses.')
on conflict (expense_type) do update
set
  category_name = excluded.category_name,
  description = excluded.description,
  is_active = true,
  updated_at = now();
