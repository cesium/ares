import ShortUniqueId from "short-unique-id";
import { createClient } from "@supabase/supabase-js";
import type { APIRoute } from "astro";
import type { CreateTeamItem } from "~/types";
import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";

export const prerender = false;

const senderEmail = import.meta.env.SENDER_EMAIL;
const ses = new SESClient({
  region: import.meta.env.SES_REGION,
  credentials: {
    accessKeyId: import.meta.env.SES_ACCESS,
    secretAccessKey: import.meta.env.SES_SECRET,
  },
});

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

  const email = formData.get("email")?.toString() ?? "";

  // check if the participant is already in a team
  const team_code_already = await checkAlreadyInTeam(email);
  if (team_code_already) {
    errors.push("You are already in a team. You can't create another one.");
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
    new_team_code: randomUUID().toUpperCase(),
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

  await sendTeamCreationEmail(
    insertion_data.member_email,
    insertion_data.team_name,
    insertion_data.new_team_code,
  );

  return new Response(
    JSON.stringify({
      status: 200,
    }),
    { status: 200 },
  );
};

const validateForms = async (formData: FormData, errors: String[]) => {
  const email = formData.get("email")?.toString() ?? "";
  const confirmation = formData
    .get("confirmation")
    ?.toString()
    .replace("#", "");

  let { data: participants, error } = await supabase
    .from("participants")
    .select("email, confirmation")
    .eq("email", email)
    .eq("confirmation", confirmation);

  let valid = true;
  if (participants && participants.length === 0) {
    valid = false;
    errors.push(
      "Participant not registered or confirmation code does not match",
    );
  }

  return valid;
};

const sendTeamCreationEmail = async (
  to: string,
  teamName: string,
  code: string,
) => {
  const params = new SendEmailCommand({
    Source: senderEmail,
    Destination: {
      ToAddresses: [to],
    },
    Message: {
      Subject: {
        Data: "[BugsByte] Registration confirmation",
      },
      Body: {
        Html: {
          Data: `<h2>Hello again 👋</h2>
          <div>
            <p>You just created a new team - <b>${teamName}</b></p>
            <p>In order for new team members to join your team, you need to share this code with them: #<b>${code}</b>.</p>
            <p>This will allow them to join the team on our website!</p>
            <p>Looking forward to seeing you soon,</p>
            <p>Organization team 🪲</p>
          </div>`,
        },
      },
    },
  });

  try {
    await ses.send(params);
    console.log("Email sent successfully");
  } catch (error) {
    console.error("Error sending email:", error);
  }
};

const checkAlreadyInTeam = async (email: string) => {
  const { data, error } = await supabase
    .from("participants")
    .select("team_code")
    .eq("email", email);
  return data && data.length > 0 && data[0].team_code;
}