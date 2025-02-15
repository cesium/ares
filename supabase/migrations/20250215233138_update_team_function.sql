CREATE OR REPLACE FUNCTION update_participant_team(
  participant_email VARCHAR,
  new_team_code VARCHAR
) RETURNS VOID AS $$
BEGIN
  -- Update the participant's team_code
  UPDATE public.participants
  SET team_code = new_team_code
  WHERE email = participant_email;

  -- Update the num_team_mem in teams
  UPDATE public.teams
  SET num_team_mem = num_team_mem + 1,
      total_value_payment = (num_team_mem + 1) * 2
  WHERE team_code = new_team_code;
END;
$$ LANGUAGE plpgsql;