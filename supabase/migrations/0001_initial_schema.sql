-- ============================================================
-- MEDICAL EMR DATABASE SCHEMA
-- Migration: 0001_initial_schema
-- ============================================================

create extension if not exists "pgcrypto";

-- ============================================================
-- 1. PROFILES
-- Linked to Supabase Auth users
-- ============================================================

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'doctor'
    check (role in ('doctor', 'staff', 'admin')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ============================================================
-- 2. PATIENTS
-- ============================================================

create table public.patients (
  id uuid primary key default gen_random_uuid(),

  patient_code text unique not null,

  mobile text not null,
  name text not null,
  age integer not null check (age >= 0 and age <= 150),
  gender text not null
    check (gender in ('Male', 'Female', 'Other')),

  date_of_birth date,

  email text,
  address text,

  blood_group text,
  allergies text,

  emergency_contact_name text,
  emergency_contact_mobile text,

  created_by uuid references public.profiles(id) on delete set null,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index patients_mobile_idx
  on public.patients(mobile);

create index patients_name_idx
  on public.patients(name);

create index patients_created_at_idx
  on public.patients(created_at desc);

-- ============================================================
-- 3. SYMPTOMS
-- ============================================================

create table public.symptoms (
  id uuid primary key default gen_random_uuid(),

  name text unique not null,

  created_at timestamptz not null default now()
);

-- ============================================================
-- 4. DIAGNOSES
-- ============================================================

create table public.diagnoses (
  id uuid primary key default gen_random_uuid(),

  name text unique not null,

  created_at timestamptz not null default now()
);

-- ============================================================
-- 5. TESTS
-- ============================================================

create table public.tests (
  id uuid primary key default gen_random_uuid(),

  name text unique not null,

  created_at timestamptz not null default now()
);

-- ============================================================
-- 6. PROCEDURES
-- ============================================================

create table public.procedures (
  id uuid primary key default gen_random_uuid(),

  name text unique not null,

  created_at timestamptz not null default now()
);

-- ============================================================
-- 7. CONSULTATIONS
-- ============================================================

create table public.consultations (
  id uuid primary key default gen_random_uuid(),

  patient_id uuid not null
    references public.patients(id)
    on delete cascade,

  doctor_id uuid
    references public.profiles(id)
    on delete set null,

  consultation_date timestamptz not null default now(),

  consultation_fee numeric(10,2) not null default 500.00
    check (consultation_fee >= 0),

  status text not null default 'completed'
    check (status in ('draft', 'in_progress', 'completed', 'cancelled')),

  reason text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index consultations_patient_idx
  on public.consultations(patient_id);

create index consultations_date_idx
  on public.consultations(consultation_date desc);

create index consultations_doctor_idx
  on public.consultations(doctor_id);

-- ============================================================
-- 8. CONSULTATION SYMPTOMS
-- ============================================================

create table public.consultation_symptoms (
  consultation_id uuid not null
    references public.consultations(id)
    on delete cascade,

  symptom_id uuid
    references public.symptoms(id)
    on delete cascade,

  custom_symptom text,

  primary key (consultation_id, symptom_id),

  check (
    symptom_id is not null
    or custom_symptom is not null
  )
);

-- ============================================================
-- 9. CONSULTATION DIAGNOSES
-- ============================================================

create table public.consultation_diagnoses (
  consultation_id uuid not null
    references public.consultations(id)
    on delete cascade,

  diagnosis_id uuid
    references public.diagnoses(id)
    on delete cascade,

  custom_diagnosis text,

  primary key (consultation_id, diagnosis_id),

  check (
    diagnosis_id is not null
    or custom_diagnosis is not null
  )
);

-- ============================================================
-- 10. CONSULTATION TESTS
-- ============================================================

create table public.consultation_tests (
  consultation_id uuid not null
    references public.consultations(id)
    on delete cascade,

  test_id uuid
    references public.tests(id)
    on delete cascade,

  custom_test text,

  primary key (consultation_id, test_id),

  check (
    test_id is not null
    or custom_test is not null
  )
);

-- ============================================================
-- 11. CONSULTATION PROCEDURES
-- ============================================================

create table public.consultation_procedures (
  consultation_id uuid not null
    references public.consultations(id)
    on delete cascade,

  procedure_id uuid
    references public.procedures(id)
    on delete cascade,

  custom_procedure text,

  primary key (consultation_id, procedure_id),

  check (
    procedure_id is not null
    or custom_procedure is not null
  )
);

-- ============================================================
-- 12. CLINICAL NOTES
-- One record per consultation
-- ============================================================

create table public.clinical_notes (
  id uuid primary key default gen_random_uuid(),

  consultation_id uuid not null unique
    references public.consultations(id)
    on delete cascade,

  examination text,
  investigations text,
  plan text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ============================================================
-- 13. CLINICAL IMAGES
-- ============================================================

create table public.clinical_images (
  id uuid primary key default gen_random_uuid(),

  consultation_id uuid not null
    references public.consultations(id)
    on delete cascade,

  storage_path text not null,
  file_name text not null,

  mime_type text,
  file_size integer,

  caption text,

  uploaded_by uuid
    references public.profiles(id)
    on delete set null,

  created_at timestamptz not null default now()
);

create index clinical_images_consultation_idx
  on public.clinical_images(consultation_id);

-- ============================================================
-- 14. FOLLOW UPS
-- ============================================================

create table public.follow_ups (
  id uuid primary key default gen_random_uuid(),

  consultation_id uuid not null
    references public.consultations(id)
    on delete cascade,

  follow_up_date date not null,

  instructions text,
  notes text,

  created_at timestamptz not null default now()
);

create index follow_ups_date_idx
  on public.follow_ups(follow_up_date);

-- ============================================================
-- 15. PRESCRIPTIONS
-- ============================================================

create table public.prescriptions (
  id uuid primary key default gen_random_uuid(),

  consultation_id uuid not null
    references public.consultations(id)
    on delete cascade,

  medicine_name text not null,

  dosage text,
  frequency text,
  duration text,

  instructions text,

  created_at timestamptz not null default now()
);

create index prescriptions_consultation_idx
  on public.prescriptions(consultation_id);

-- ============================================================
-- 16. AI SUMMARIES
-- ============================================================

create table public.ai_summaries (
  id uuid primary key default gen_random_uuid(),

  consultation_id uuid not null unique
    references public.consultations(id)
    on delete cascade,

  summary text not null,

  model text,

  generated_at timestamptz not null default now()
);

-- ============================================================
-- 17. AUDIT LOGS
-- ============================================================

create table public.audit_logs (
  id uuid primary key default gen_random_uuid(),

  user_id uuid
    references public.profiles(id)
    on delete set null,

  action text not null,

  entity_type text not null,
  entity_id uuid,

  metadata jsonb,

  created_at timestamptz not null default now()
);

create index audit_logs_created_at_idx
  on public.audit_logs(created_at desc);

create index audit_logs_entity_idx
  on public.audit_logs(entity_type, entity_id);

-- ============================================================
-- UPDATED_AT TRIGGER
-- ============================================================

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

create trigger patients_updated_at
before update on public.patients
for each row execute function public.set_updated_at();

create trigger consultations_updated_at
before update on public.consultations
for each row execute function public.set_updated_at();

create trigger clinical_notes_updated_at
before update on public.clinical_notes
for each row execute function public.set_updated_at();

-- ============================================================
-- AUTOMATIC PROFILE CREATION
-- ============================================================

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', '')
  );

  return new;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

alter table public.profiles enable row level security;
alter table public.patients enable row level security;
alter table public.symptoms enable row level security;
alter table public.diagnoses enable row level security;
alter table public.tests enable row level security;
alter table public.procedures enable row level security;
alter table public.consultations enable row level security;
alter table public.consultation_symptoms enable row level security;
alter table public.consultation_diagnoses enable row level security;
alter table public.consultation_tests enable row level security;
alter table public.consultation_procedures enable row level security;
alter table public.clinical_notes enable row level security;
alter table public.clinical_images enable row level security;
alter table public.follow_ups enable row level security;
alter table public.prescriptions enable row level security;
alter table public.ai_summaries enable row level security;
alter table public.audit_logs enable row level security;

-- ============================================================
-- PROFILE POLICIES
-- ============================================================

create policy "Users can view own profile"
on public.profiles
for select
to authenticated
using (id = auth.uid());

create policy "Users can update own profile"
on public.profiles
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

-- ============================================================
-- PATIENT POLICIES
-- ============================================================

create policy "Authenticated users can view patients"
on public.patients
for select
to authenticated
using (true);

create policy "Authenticated users can create patients"
on public.patients
for insert
to authenticated
with check (true);

create policy "Authenticated users can update patients"
on public.patients
for update
to authenticated
using (true)
with check (true);

-- ============================================================
-- REFERENCE DATA POLICIES
-- ============================================================

create policy "Authenticated users can view symptoms"
on public.symptoms
for select
to authenticated
using (true);

create policy "Authenticated users can view diagnoses"
on public.diagnoses
for select
to authenticated
using (true);

create policy "Authenticated users can view tests"
on public.tests
for select
to authenticated
using (true);

create policy "Authenticated users can view procedures"
on public.procedures
for select
to authenticated
using (true);

-- ============================================================
-- CONSULTATION POLICIES
-- ============================================================

create policy "Authenticated users can view consultations"
on public.consultations
for select
to authenticated
using (true);

create policy "Authenticated users can create consultations"
on public.consultations
for insert
to authenticated
with check (true);

create policy "Authenticated users can update consultations"
on public.consultations
for update
to authenticated
using (true)
with check (true);

-- ============================================================
-- CONSULTATION RELATED POLICIES
-- ============================================================

create policy "Authenticated users can view consultation symptoms"
on public.consultation_symptoms
for select
to authenticated
using (true);

create policy "Authenticated users can manage consultation symptoms"
on public.consultation_symptoms
for all
to authenticated
using (true)
with check (true);

create policy "Authenticated users can view consultation diagnoses"
on public.consultation_diagnoses
for select
to authenticated
using (true);

create policy "Authenticated users can manage consultation diagnoses"
on public.consultation_diagnoses
for all
to authenticated
using (true)
with check (true);

create policy "Authenticated users can view consultation tests"
on public.consultation_tests
for select
to authenticated
using (true);

create policy "Authenticated users can manage consultation tests"
on public.consultation_tests
for all
to authenticated
using (true)
with check (true);

create policy "Authenticated users can view consultation procedures"
on public.consultation_procedures
for select
to authenticated
using (true);

create policy "Authenticated users can manage consultation procedures"
on public.consultation_procedures
for all
to authenticated
using (true)
with check (true);

-- ============================================================
-- CLINICAL NOTES
-- ============================================================

create policy "Authenticated users can manage clinical notes"
on public.clinical_notes
for all
to authenticated
using (true)
with check (true);

-- ============================================================
-- CLINICAL IMAGES
-- ============================================================

create policy "Authenticated users can view clinical images"
on public.clinical_images
for select
to authenticated
using (true);

create policy "Authenticated users can upload clinical images"
on public.clinical_images
for insert
to authenticated
with check (true);

create policy "Authenticated users can update clinical images"
on public.clinical_images
for update
to authenticated
using (true)
with check (true);

create policy "Authenticated users can delete clinical images"
on public.clinical_images
for delete
to authenticated
using (true);

-- ============================================================
-- FOLLOW UPS
-- ============================================================

create policy "Authenticated users can manage follow ups"
on public.follow_ups
for all
to authenticated
using (true)
with check (true);

-- ============================================================
-- PRESCRIPTIONS
-- ============================================================

create policy "Authenticated users can manage prescriptions"
on public.prescriptions
for all
to authenticated
using (true)
with check (true);

-- ============================================================
-- AI SUMMARIES
-- ============================================================

create policy "Authenticated users can manage AI summaries"
on public.ai_summaries
for all
to authenticated
using (true)
with check (true);

-- ============================================================
-- AUDIT LOGS
-- ============================================================

create policy "Authenticated users can view audit logs"
on public.audit_logs
for select
to authenticated
using (true);

create policy "Authenticated users can create audit logs"
on public.audit_logs
for insert
to authenticated
with check (true);

-- ============================================================
-- SEED REFERENCE DATA
-- ============================================================

insert into public.symptoms (name) values
('Acne / Pimples'),
('Hair loss / Hair fall'),
('Dandruff'),
('Pigmentation / Dark spots'),
('Eczema / Dermatitis'),
('Skin allergy / Rash'),
('Itching / Pruritus'),
('Fungal infection'),
('Warts'),
('Skin tags / Moles')
on conflict (name) do nothing;

insert into public.diagnoses (name) values
('Acne vulgaris'),
('Androgenetic alopecia'),
('Atopic dermatitis / Eczema'),
('Tinea corporis'),
('Psoriasis – vulgaris'),
('Vitiligo'),
('Melasma'),
('Urticaria (Hives)'),
('Contact dermatitis'),
('Seborrheic dermatitis')
on conflict (name) do nothing;

insert into public.tests (name) values
('KOH mount'),
('Dermoscopy (Dermoscopy)'),
('Skin biopsy — punch'),
('Skin scraping for fungus'),
('Patch test (standard series)'),
('Wood''s lamp examination'),
('Complete Blood Count (CBC)'),
('HbA1c'),
('Thyroid profile (TSH, T3, T4)'),
('Vitamin D')
on conflict (name) do nothing;

-- ============================================================
-- END OF MIGRATION
-- ============================================================