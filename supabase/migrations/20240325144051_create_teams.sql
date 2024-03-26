create table
  public.teams (
    code varchar primary key,
    created_at timestamp with time zone not null default now(),
    name character varying null,
    constraint teams_name_key unique (name)
  ) tablespace pg_default;
