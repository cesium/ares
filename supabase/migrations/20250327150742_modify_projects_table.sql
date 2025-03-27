-- Step 1: Drop the current primary key constraint
ALTER TABLE public.projects
DROP CONSTRAINT projects_pkey;

-- Step 2: Drop the id column
ALTER TABLE public.projects
DROP COLUMN id;

-- Step 3: Set the team_code column as the new primary key
ALTER TABLE public.projects
ADD CONSTRAINT projects_pkey PRIMARY KEY (team_code);
