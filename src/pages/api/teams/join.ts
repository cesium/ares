import { createClient } from "@supabase/supabase-js";
import type { APIRoute } from "astro";
import { SMTPClient } from "emailjs";

export const prerender = false;

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);

const senderEmail = import.meta.env.SENDER_EMAIL;
const client = new SMTPClient({
  user: import.meta.env.SMTP_USER,
  password: import.meta.env.SMTP_PASS,
  host: import.meta.env.SMTP_HOST,
  ssl: true,
});

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
    let msg = "";
    if (insertion_msg.error.message.includes("violates check constraint \"teams_num_team_mem_check\"")) {
      msg = "The team is already full. Try joining or creating another team.";
    }
    else if (insertion_msg.error.message.includes("Team already paid")) {
      msg = "The team is already paid. You can't join it.";
    }
    else {
      msg = "There was an error joining the team. Try again later.";
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
  const { data: data, error: error } = await supabase
    .from("teams")
    .select("name, created_by, num_team_mem, total_value_payment")
    .eq("code", team_code);

  let team_name = null;

  if (data && data.length > 0) {
    team_name = data[0].name;
    sendTeamEntryEmail(email, team_name);

    const created_by = data[0].created_by;
    const num_team_mem = data[0].num_team_mem;
    const total_value_payment = data[0].total_value_payment;
    sendNotificationEmail(team_name, created_by, num_team_mem, total_value_payment);
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

const sendTeamEntryEmail = async (to: string, team_name: string) => {
  const message = {
    text: "",
    from: senderEmail.toString(),
    to: to,
    subject: "[BugsByte] Team entry confirmation",
    attachment: [
      {
        data: `<h1>Hello again 👋</h1>
          <div>
            <p>You just entered a new team - <b>${team_name}</b></p>
            <p>Looking forward to seeing you soon!</p>
            <p>Organization team 🪲</p>
          </div>`.toString(),
        alternative: true,
      },
    ],
  };

  try {
    client.send(message, function (err, message) {
      console.log(err || message);
    });

    return null;
  } catch (error) {
    return error;
  }
};


const sendNotificationEmail = async (team_name: string, email: string, num_team_mem: number, total_value_payment: number) => {
  const message = {
    text: "",
    from: senderEmail.toString(),
    to: email,
    subject: "[BugsByte] New team member",
    attachment: [
      {
        data: `<h1>Hello 🪲</h1>
          <div>
            <p>A new member just joined the team <b>${team_name}</b></p>
            <p>Email: ${email}</p>
            <p>Number of team members: ${num_team_mem}</p>
            <p>Remember that you or other team members needs to pay the total value of the team to confirm the registration in CeSIUM.</p>
            <p>Total value: ${total_value_payment}€</p>
            <p>Looking forward to seeing you soon!</p>
          </div>`.toString(),
        alternative: true,
      },
    ],
  };

  try {
    client.send(message, function (err, message) {
      console.log(err || message);
    });

    return null;
  } catch (error) {
    return error;
  }
}