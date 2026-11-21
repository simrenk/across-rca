-- Still in Orbit: database + file storage for public launches.
-- Run once in Supabase: Dashboard → SQL Editor → New query → paste all of this → Run.
-- Safe to run again; it updates what already exists.

-- 1. Projects table ---------------------------------------------------------
create table if not exists public.projects (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  title       text not null check (char_length(title) between 1 and 90),
  maker       text not null check (char_length(maker) between 1 and 80),
  year        text check (year is null or char_length(year) <= 4),
  programme   text check (programme is null or char_length(programme) <= 60),
  media       text check (media is null or char_length(media) <= 30),
  tags        text[] not null default '{}' check (cardinality(tags) <= 6),
  description text check (description is null or char_length(description) <= 1500),
  link        text check (link is null or link = '' or link ~* '^https?://'),
  -- uploaded files: [{ "path": "...", "type": "image/jpeg", "name": "..." }]
  files       jsonb not null default '[]'::jsonb
              check (jsonb_typeof(files) = 'array' and jsonb_array_length(files) <= 8),
  -- tick this in the Table Editor to take a project out of orbit without deleting it
  hidden      boolean not null default false
);

alter table public.projects enable row level security;

-- Anyone can see projects that aren't hidden.
drop policy if exists "read visible projects" on public.projects;
create policy "read visible projects" on public.projects
  for select to anon, authenticated using (not hidden);

-- Anyone can launch a project. Nobody but you (from the dashboard) can edit or delete.
drop policy if exists "anyone can launch" on public.projects;
create policy "anyone can launch" on public.projects
  for insert to anon, authenticated with check (not hidden);

grant select, insert on public.projects to anon, authenticated;

-- 2. File storage -----------------------------------------------------------
-- Public bucket: files are readable by URL. 50 MB per file (the free-plan maximum).
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('projects', 'projects', true, 52428800,
        array['image/*', 'video/*', 'audio/*', 'application/pdf', 'model/gltf-binary'])
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

-- Anyone can upload new files into the bucket (but not overwrite or delete).
drop policy if exists "anyone can upload project files" on storage.objects;
create policy "anyone can upload project files" on storage.objects
  for insert to anon, authenticated with check (bucket_id = 'projects');
