import type { APIRoute } from "astro";
import { createClient } from "@supabase/supabase-js";

export const prerender = false;

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);

export const GET: APIRoute = async ({ request }) => {
  const { data: teams, error } = await supabase.from("teams").select("*");

  if (error) {
    return new Response(
      JSON.stringify({ message: { error: error.message } }),
      { status: 500 },
    );
  }

  return new Response(JSON.stringify(teams), { status: 200 });
};