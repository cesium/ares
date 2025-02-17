ALTER TABLE public.teams
    ADD COLUMN created_by VARCHAR REFERENCES public.participants(email);