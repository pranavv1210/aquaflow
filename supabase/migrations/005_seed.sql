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

insert into public.business_settings (
  setting_key,
  setting_value,
  description,
  is_active
)
values (
  'business_profile',
  jsonb_build_object(
    'business_name', 'AquaFlow',
    'currency', 'INR',
    'date_format', 'dd MMM yyyy',
    'time_format', '12 Hour',
    'owner_name', '',
    'owner_phone', '',
    'owner_address', ''
  ),
  'Primary business settings for the single-owner AquaFlow app.',
  true
)
on conflict (setting_key) do update
set
  setting_value = excluded.setting_value,
  description = excluded.description,
  is_active = true,
  updated_at = now();
