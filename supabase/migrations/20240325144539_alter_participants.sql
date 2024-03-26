-- First, drop the existing primary key constraint
ALTER TABLE public.participants
DROP CONSTRAINT participants_pkey;

-- Next, drop the id column
ALTER TABLE public.participants
DROP COLUMN id;

-- Then, add the team_code column
ALTER TABLE public.participants
ADD COLUMN team_code VARCHAR,
ADD CONSTRAINT fk_team_code
  FOREIGN KEY (team_code)
  REFERENCES public.teams(code);

-- Finally, add the email column as the primary key
ALTER TABLE public.participants
ADD CONSTRAINT participants_pkey PRIMARY KEY (email);
