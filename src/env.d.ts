/// <reference types="astro/client" />
/// <reference path="../.astro/types.d.ts" />
interface ImportMetaEnv {
  readonly SUPABASE_URL: string;
  readonly SUPABASE_ANON_KEY: string;
  readonly AUTH_SECRET: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
