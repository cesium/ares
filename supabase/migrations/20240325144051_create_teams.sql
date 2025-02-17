create table
  public.teams (
    code varchar primary key,
    created_at timestamp with time zone not null default now(),
    name character varying null,
    num_team_mem smallint not null default 1 check (num_team_mem > 0 and num_team_mem < 6),
    total_value_payment numeric null,
    paid boolean not null default false,
    constraint teams_name_key unique (name)
  ) tablespace pg_default;
