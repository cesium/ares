create or replace function create_team(member_email varchar, team_name varchar, new_team_code varchar) 
returns setof participants 
language plpgsql
as $$

begin
  insert into public.teams (code, name)
  values (new_team_code, team_name);

  update public.participants
  set team_code = new_team_code
  where email = member_email;

  return query select * from public.participants where team_code = new_team_code;
end;
$$;
