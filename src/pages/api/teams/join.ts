import { createClient } from "@supabase/supabase-js";
import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";
import type { APIRoute } from "astro";

export const prerender = false;

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);

const ses = new SESClient({
  region: import.meta.env.SES_AWS_REGION,
  credentials: {
    accessKeyId: import.meta.env.SES_AWS_ACCESS_KEY_ID,
    secretAccessKey: import.meta.env.SES_AWS_SECRET_ACCESS_KEY,
  },
});

const senderEmail = import.meta.env.SENDER_EMAIL;

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
  const team_code = formData.get("code")?.toString().replace("#", "");

  const insertion_msg = await supabase.rpc("update_participant_team", {
    participant_email: email,
    new_team_code: team_code,
  });

  if (insertion_msg.error) {
    console.error(insertion_msg.error);
    let msg = "There was an error joining the team. Try again later.";
    if (
      insertion_msg.error.message.includes(
        'violates check constraint "teams_num_team_mem_check"',
      )
    ) {
      msg = "The team is already full. Try joining or creating another team.";
    } else if (insertion_msg.error.message.includes("Team already paid")) {
      msg = "The team is already paid. You can't join it.";
    }
    errors.push(msg);
    return new Response(
      JSON.stringify({
        message: { errors: errors },
        status: 500,
      }),
      { status: 500 },
    );
  }

  // get the team name and created_by to send the emails
  const { data, error } = await supabase
    .from("teams")
    .select("name, created_by, num_team_mem, total_value_payment")
    .eq("code", team_code);

  let team_name = null;

  if (data && data.length > 0) {
    team_name = data[0].name;
    await sendTeamEntryEmail(email, team_name);
    await sendNotificationEmail(
      team_name,
      data[0].created_by,
      data[0].num_team_mem,
      data[0].total_value_payment,
    );
  }

  return new Response(
    JSON.stringify({
      message: { team_name: team_name },
      status: 200,
    }),
    { status: 200 },
  );
};

const validateForms = async (formData: FormData, errors: String[]) => {
  let valid = true;
  const email = formData.get("email")?.toString() ?? "";
  const confirmation = formData
    .get("confirmation")
    ?.toString()
    .replace("#", "");

  const { data: participants, error } = await supabase
    .from("participants")
    .select("email, confirmation")
    .eq("email", email)
    .eq("confirmation", confirmation);

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
  return valid;
};

const sendEmail = async (to: string, subject: string, body: string) => {
  const params = {
    Source: senderEmail,
    Destination: {
      ToAddresses: [to],
    },
    Message: {
      Subject: { Data: subject },
      Body: { Html: { Data: body } },
    },
  };
  try {
    await ses.send(new SendEmailCommand(params));
  } catch (error) {
    console.error("Error sending email:", error);
  }
};

const sendTeamEntryEmail = async (to: string, team_name: string) => {
  const body = `<h2>Hello again 👋</h2>
    <div>
      <p>You just entered a new team - <b>${team_name}</b></p>
      <p>Looking forward to seeing you soon!</p>
      <p>Organization team 🪲</p>
    </div>`;
  await sendEmail(to, "[BugsByte] Team entry confirmation", body);
};

const sendNotificationEmail = async (
  team_name: string,
  email: string,
  num_team_mem: number,
  total_value_payment: number,
) => {
  const body = `<h2>Hello again 👋</h2>
    <div>
      <p>A new member just joined the team <b>${team_name}</b></p>
      <p>Number of team members: ${num_team_mem}</p>
      <p>Remember that you or other team members need to pay the total value of the team to confirm the registration at CeSIUM (DI 1.04).</p>
      <p>When the payment is done, the team will be closed and no more members will be able to join it.</p>
      <p>Total value: <b>${total_value_payment}€</b></p>
      <p>Looking forward to seeing you soon!</p>
      <p>Organization team 🪲</p>
    </div>`;
  await sendEmail(email, "[BugsByte] New team member", body);
};
