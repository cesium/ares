import { createClient } from "@supabase/supabase-js";
import type { APIRoute } from "astro";

export const prerender = false;

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);

export const POST: APIRoute = async ({ request }) => {
  const formData = await request.formData();

  let errors: String[] = [];

  // forms validation
  const valid = await validateForms(formData, errors);

  if (!valid) {
    return new Response(
      JSON.stringify({
        message: { errors: errors },
        status: 400,
      }),
      { status: 400 },
    );
  }

  const email = formData.get("email")?.toString() ?? "";
  const team_code = formData.get("code")?.toString() ?? "";

  const insertion_msg = await supabase
    .from("participants")
    .update({ team_code: team_code })
    .eq("email", email)
    .select();
  if (insertion_msg.error) {
    let msg = "There was an error joining the team. Try again later.";
    errors.push(msg);

    return new Response(
      JSON.stringify({
        message: { errors: errors },
        status: 500,
      }),
      { status: 500 },
    );
  }

  return new Response(
    JSON.stringify({
      status: 200,
    }),
    { status: 200 },
  );
};

const validateForms = async (formData: FormData, errors: String[]) => {
  let valid = true;

  const { data: participants, error } = await supabase
    .from("participants")
    .select("email, confirmation")
    .eq("email", formData.get("email")?.toString() ?? "")
    .eq("confirmation", formData.get("confirmation")?.toString() ?? "");

  if (error) {
    console.error(error);
    errors.push(
      "There was an error checking your registration credentials. Try again later.",
    );
    valid = false;
  }

  if (participants && participants.length === 0) {
    errors.push(
      "The email and confirmation code do not match. Please try again.",
    );
    valid = false;
  }

  // confirm that the number of elements in the team is less than or equal to 5
  const team_code = formData.get("code")?.toString() ?? "";
  const { data: team_members, error: team_error } = await supabase
    .from("participants")
    .select("email")
    .eq("team_code", team_code);

  if (team_error) {
    console.error(team_error);
    errors.push(
      "There was an error connecting to the server. Try again later.",
    );
    valid = false;
  }

  if (team_members && team_members.length >= 5) {
    errors.push(
      "The team is already full. Try joining or creating another team.",
    );
    valid = false;
  }

  return valid;
};
