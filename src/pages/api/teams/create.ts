import ShortUniqueId from "short-unique-id";
import { createClient } from "@supabase/supabase-js";
import { sendEmail } from "~/pages/api/utils/mailer.ts";
import type { APIRoute } from "astro";
import type { CreateTeamItem } from "~/types";

export const prerender = false;

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);

const { randomUUID } = new ShortUniqueId({ length: 6 });

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

  const insertion_data: CreateTeamItem = {
    team_name: formData.get("name")?.toString() ?? "",
    member_email: formData.get("email")?.toString() ?? "",
    new_team_code: randomUUID().toUpperCase()
  };

  const { data, error } = await supabase.rpc("create_team", insertion_data);

  if (error) {
    errors.push("There was an error with your submission. Please try again!");

    return new Response(
      JSON.stringify({
        message: { errors: errors },
        status: 500,
      }),
      { status: 500 },
    );
  }

  sendTeamCreationEmail(insertion_data.member_email, insertion_data.team_name, insertion_data.new_team_code);

  return new Response(
    JSON.stringify({
      status: 200,
    }),
    { status: 200 },
  );
};

const validateForms = async (formData: FormData, errors: String[]) => {
  let { data: participants, error } = await supabase
    .from("participants")
    .select("email, confirmation")
    .eq("email", formData.get("email")?.toString() ?? "")
    .eq("confirmation", formData.get("confirmation")?.toString() ?? "");

  let valid = true;
  if (participants && participants.length === 0) {
    valid = false;
    errors.push("Participant not registered or confirmation code does not match");
  }

  return valid;
};

const sendTeamCreationEmail = async (
  to: string,
  teamName: string,
  code: string
) => {
  const subject = "[BugsByte] Team creation confirmation";
  const content = `<h1>Hello again 👋</h1>
          <div>
            <p>You just created a new team - <b>${teamName}</b></p>
            <p>In order for new team members to join your team, you need to share this code with them: #<b>${code}</b>.</p>
            <p>This will allow them to join the team on our website!</p>
            <p>Looking forward to seeing you soon,</p>
            <p>Organization team 🪲</p>
          </div>`.toString();

  try {
    await sendEmail(to, subject, content);
  }
  catch (error) {
    console.error(error);
  }
};
