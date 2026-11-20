-- 로그인 없이 링크만 아는 사람이 모두 읽고 쓸 수 있는 공유 투두 테이블 (기존 todos 테이블과 별개)

create table if not exists public.shared_todos (
  id uuid primary key default gen_random_uuid(),
  text text not null,
  done boolean not null default false,
  due text not null default '',
  priority text not null default 'normal',
  created_at bigint not null default (extract(epoch from now()) * 1000)::bigint
);

alter table public.shared_todos enable row level security;

create policy "anyone can read"   on public.shared_todos for select to anon using (true);
create policy "anyone can add"    on public.shared_todos for insert to anon with check (true);
create policy "anyone can edit"   on public.shared_todos for update to anon using (true) with check (true);
create policy "anyone can delete" on public.shared_todos for delete to anon using (true);

alter publication supabase_realtime add table public.shared_todos;
