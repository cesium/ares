import type { APIRoute } from "astro";
import { createClient } from "@supabase/supabase-js";

export const prerender = false;

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);

const AUTH_COOKIE_NAME = "authToken";
const AUTH_SECRET = import.meta.env.AUTH_SECRET;

export const GET: APIRoute = async ({ request, cookies }) => {
  const authToken = cookies.get(AUTH_COOKIE_NAME);

  if (!authToken || authToken.value !== AUTH_SECRET) {
    return new Response(
      JSON.stringify({ message: { error: "Unauthorized" } }),
      { status: 401 },
    );
  }

  const { data: teams, error } = await supabase.from("projects").select("*");

  if (error) {
    return new Response(JSON.stringify({ message: { error: error.message } }), {
      status: 500,
    });
  }

  return new Response(JSON.stringify(teams), { status: 200 });
};
