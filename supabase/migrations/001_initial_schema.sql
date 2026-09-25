-- IllaraStay v0.5 initial Supabase/PostgreSQL schema.
-- Apply with Supabase migrations after configuring a project.

create extension if not exists pgcrypto;

create type public.user_role as enum ('tenant', 'owner', 'admin');
create type public.account_status as enum ('active', 'blocked', 'suspended');
create type public.property_status as enum ('draft', 'published', 'unpublished');
create type public.approval_status as enum ('pending', 'approved', 'rejected');
create type public.request_status as enum ('pending', 'accepted', 'rejected', 'completed');
create type public.review_status as enum ('pending', 'published', 'rejected');
create type public.report_status as enum ('pending', 'resolved', 'dismissed');

create table public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  email text not null unique,
  phone text,
  role public.user_role not null default 'tenant',
  profile_image text,
  city text,
  status public.account_status not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Create the public profile that the Flutter auth repository expects after a
-- Supabase Auth signup. Admin accounts must be promoted separately by an
-- existing administrator; client metadata can only create tenant/owner rows.
create or replace function public.handle_new_auth_user() returns trigger
language plpgsql security definer set search_path = public as $$
declare
  requested_role public.user_role;
begin
  requested_role := case
    when new.raw_user_meta_data ->> 'role' = 'owner' then 'owner'::public.user_role
    else 'tenant'::public.user_role
  end;
  insert into public.users (id, name, email, role)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'name', split_part(new.email, '@', 1)),
    new.email,
    requested_role
  )
  on conflict (id) do update set email = excluded.email, updated_at = now();
  return new;
end;
$$;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_auth_user();

create table public.properties (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.users(id) on delete cascade,
  title text not null,
  description text not null default '',
  property_type text not null,
  listing_type text not null,
  price numeric(14,2) not null check (price >= 0),
  deposit numeric(14,2) not null default 0 check (deposit >= 0),
  maintenance numeric(14,2) not null default 0 check (maintenance >= 0),
  bedrooms integer not null default 0 check (bedrooms >= 0),
  bathrooms integer not null default 0 check (bathrooms >= 0),
  area numeric(12,2) not null default 0 check (area >= 0),
  furnishing text not null default 'unfurnished',
  floor integer,
  total_floors integer,
  city text not null,
  locality text not null,
  address text not null,
  latitude double precision,
  longitude double precision,
  availability_date date,
  available_units integer not null default 1 check (available_units >= 0),
  status public.property_status not null default 'draft',
  approval_status public.approval_status not null default 'pending',
  rejection_reason text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.property_images (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties(id) on delete cascade,
  image_url text not null,
  is_primary boolean not null default false,
  display_order integer not null default 0,
  created_at timestamptz not null default now()
);

create table public.amenities (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  status public.account_status not null default 'active'
);

create table public.property_amenities (
  property_id uuid not null references public.properties(id) on delete cascade,
  amenity_id uuid not null references public.amenities(id) on delete cascade,
  primary key (property_id, amenity_id)
);

create table public.requests (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties(id) on delete cascade,
  tenant_id uuid not null references public.users(id) on delete cascade,
  owner_id uuid not null references public.users(id) on delete cascade,
  request_type text not null default 'visit',
  message text not null default '',
  preferred_date date,
  preferred_time time,
  status public.request_status not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.saved_properties (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.users(id) on delete cascade,
  property_id uuid not null references public.properties(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (tenant_id, property_id)
);

create table public.reviews (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties(id) on delete cascade,
  reviewer_id uuid not null references public.users(id) on delete cascade,
  owner_id uuid not null references public.users(id) on delete cascade,
  rating integer not null check (rating between 1 and 5),
  review text not null,
  status public.review_status not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references public.users(id) on delete cascade,
  property_id uuid references public.properties(id) on delete cascade,
  reported_user_id uuid references public.users(id) on delete cascade,
  reason text not null,
  description text not null default '',
  status public.report_status not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (property_id is not null or reported_user_id is not null)
);

create index properties_marketplace_idx on public.properties (city, locality, status, approval_status);
create index properties_owner_idx on public.properties (owner_id, updated_at desc);
create index property_images_property_idx on public.property_images (property_id, display_order);
create index requests_tenant_idx on public.requests (tenant_id, created_at desc);
create index requests_owner_idx on public.requests (owner_id, status, created_at desc);
create index reports_status_idx on public.reports (status, created_at desc);
create index reviews_status_idx on public.reviews (status, created_at desc);

create or replace function public.set_updated_at() returns trigger
language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;
create trigger users_set_updated_at before update on public.users for each row execute function public.set_updated_at();
create trigger properties_set_updated_at before update on public.properties for each row execute function public.set_updated_at();
create trigger requests_set_updated_at before update on public.requests for each row execute function public.set_updated_at();
create trigger reviews_set_updated_at before update on public.reviews for each row execute function public.set_updated_at();
create trigger reports_set_updated_at before update on public.reports for each row execute function public.set_updated_at();

create or replace function public.is_admin() returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.users where id = auth.uid() and role = 'admin' and status = 'active');
$$;

alter table public.users enable row level security;
alter table public.properties enable row level security;
alter table public.property_images enable row level security;
alter table public.amenities enable row level security;
alter table public.property_amenities enable row level security;
alter table public.requests enable row level security;
alter table public.saved_properties enable row level security;
alter table public.reviews enable row level security;
alter table public.reports enable row level security;

create policy users_read_self_or_admin on public.users for select using (id = auth.uid() or public.is_admin());
create policy users_update_self_or_admin on public.users for update using (id = auth.uid() or public.is_admin()) with check (id = auth.uid() or public.is_admin());
create policy properties_read_marketplace on public.properties for select using ((status = 'published' and approval_status = 'approved') or owner_id = auth.uid() or public.is_admin());
create policy properties_owner_insert on public.properties for insert with check (owner_id = auth.uid());
create policy properties_owner_update on public.properties for update using (owner_id = auth.uid() or public.is_admin()) with check (owner_id = auth.uid() or public.is_admin());
create policy properties_owner_delete on public.properties for delete using (owner_id = auth.uid() or public.is_admin());
create policy property_images_read_visible on public.property_images for select using (exists (select 1 from public.properties p where p.id = property_id and ((p.status = 'published' and p.approval_status = 'approved') or p.owner_id = auth.uid() or public.is_admin())));
create policy property_images_owner_manage on public.property_images for all using (exists (select 1 from public.properties p where p.id = property_id and (p.owner_id = auth.uid() or public.is_admin()))) with check (exists (select 1 from public.properties p where p.id = property_id and (p.owner_id = auth.uid() or public.is_admin())));
create policy amenities_read_active on public.amenities for select using (status = 'active' or public.is_admin());
create policy amenities_admin_manage on public.amenities for all using (public.is_admin()) with check (public.is_admin());
create policy property_amenities_read_visible on public.property_amenities for select using (exists (select 1 from public.properties p where p.id = property_id and ((p.status = 'published' and p.approval_status = 'approved') or p.owner_id = auth.uid() or public.is_admin())));
create policy property_amenities_owner_manage on public.property_amenities for all using (exists (select 1 from public.properties p where p.id = property_id and (p.owner_id = auth.uid() or public.is_admin()))) with check (exists (select 1 from public.properties p where p.id = property_id and (p.owner_id = auth.uid() or public.is_admin())));
create policy requests_tenant_or_owner_read on public.requests for select using (tenant_id = auth.uid() or owner_id = auth.uid() or public.is_admin());
create policy requests_tenant_create on public.requests for insert with check (tenant_id = auth.uid());
create policy requests_owner_or_admin_update on public.requests for update using (owner_id = auth.uid() or public.is_admin()) with check (owner_id = auth.uid() or public.is_admin());
create policy saved_tenant_manage on public.saved_properties for all using (tenant_id = auth.uid() or public.is_admin()) with check (tenant_id = auth.uid() or public.is_admin());
create policy reviews_read_published_or_owner on public.reviews for select using (status = 'published' or reviewer_id = auth.uid() or owner_id = auth.uid() or public.is_admin());
create policy reviews_tenant_create on public.reviews for insert with check (reviewer_id = auth.uid());
create policy reviews_admin_moderate on public.reviews for update using (public.is_admin()) with check (public.is_admin());
create policy reports_reporter_or_admin_read on public.reports for select using (reporter_id = auth.uid() or public.is_admin());
create policy reports_tenant_create on public.reports for insert with check (reporter_id = auth.uid());
create policy reports_admin_manage on public.reports for update using (public.is_admin()) with check (public.is_admin());

-- Only admins can approve listings. Owners may publish after approval or
-- unpublish their own listing; application code should enforce this transition.
create or replace function public.prevent_unapproved_publish() returns trigger language plpgsql as $$
begin
  if not public.is_admin() and tg_op = 'UPDATE' and new.approval_status <> old.approval_status then
    raise exception 'Only admins can change property approval status';
  end if;
  if not public.is_admin() and tg_op = 'INSERT' and new.approval_status <> 'pending' then
    raise exception 'Owner-created properties must begin pending approval';
  end if;
  if new.status = 'published' and new.approval_status <> 'approved' and not public.is_admin() then
    raise exception 'Property must be approved before publishing';
  end if;
  return new;
end;
$$;
create trigger property_publish_guard before insert or update on public.properties for each row execute function public.prevent_unapproved_publish();

create or replace function public.protect_user_privileges() returns trigger language plpgsql as $$
begin
  if not public.is_admin() and (new.role <> old.role or new.status <> old.status) then
    raise exception 'Only admins can change user role or status';
  end if;
  return new;
end;
$$;
create trigger user_privilege_guard before update on public.users for each row execute function public.protect_user_privileges();
