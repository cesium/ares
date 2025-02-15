ALTER TABLE public.participants
    ADD CONSTRAINT fk_team_code
        FOREIGN KEY (team_code)
        REFERENCES public.teams(code);