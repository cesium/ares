create table
  public.participants (
    created_at timestamp with time zone not null default now(),
    name character varying null,
    email character varying not null,
    age smallint null,
    mobile character varying null,
    university character varying null,
    course character varying null,
    vegan boolean null default false,
    notes text null,
    confirmation text null,
    team_code character varying null,
    constraint participants_confirmation_key unique (confirmation),
    constraint participants_pkey
      primary key (email)
  ) tablespace pg_default;
