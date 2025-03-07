import type { APIRoute } from "astro";
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);

const AUTH_COOKIE_NAME = "authToken";
const AUTH_SECRET = import.meta.env.AUTH_SECRET;

const internal_error = new Response(
  JSON.stringify({
    message: { error: "Internal server error" },
    status: 500,
  }),
  { status: 500 },
);

export const POST: APIRoute = async ({ params, cookies }) => {
  const authToken = cookies.get(AUTH_COOKIE_NAME);

  if (!authToken || authToken.value !== AUTH_SECRET) {
    return new Response(
      JSON.stringify({ message: { error: "Unauthorized" } }),
      { status: 401 },
    );
  }

  const { code } = params;

  if (typeof code !== "string") {
    return new Response(
      JSON.stringify({
        message: { error: "Invalid team code" },
        status: 400,
      }),
      { status: 400 },
    );
  }
  const validate = await checkTeamMembers(code);

  if (validate === null) {
    return internal_error;
  }

  if (!validate) {
    return new Response(
      JSON.stringify({
        message: { error: "You can't pay for a team with only one member" },
        status: 400,
      }),
      { status: 400 },
    );
  }

  const { data, error } = await supabase
    .from("teams")
    .update({ paid: true })
    .eq("code", code);

  if (error) {
    return internal_error;
  }

  return new Response(
    JSON.stringify({
      status: 200,
    }),
    { status: 200 },
  );
};

export async function checkTeamMembers(team_code: string) {
  const { data, error } = await supabase
    .from("teams")
    .select("num_team_mem")
    .eq("code", team_code)
    .single();

  if (error) {
    return null;
  }

  if (data.num_team_mem === 1) {
    return false;
  }

  return true;
}
