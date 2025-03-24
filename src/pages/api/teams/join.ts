import { createClient } from "@supabase/supabase-js";
import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";
import type { APIRoute } from "astro";

export const prerender = false;

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);

const ses = new SESClient({
  region: import.meta.env.SES_REGION,
  credentials: {
    accessKeyId: import.meta.env.SES_ACCESS,
    secretAccessKey: import.meta.env.SES_SECRET,
  },
});

const senderEmail = import.meta.env.SENDER_EMAIL;

const discordInvite = import.meta.env.DISCORD_INVITE;

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
  const delete_user_on_error =
    formData.get("delete_user_on_error")?.toString() === "true";

  // check if the participant is already in a team
  const team_code_already = await checkAlreadyInTeam(email);
  if (team_code_already) {
    errors.push("You are already in a team. You can't join another one.");

    if (delete_user_on_error) {
      const deleted = await deleteParticipant(email);
      if (!deleted.sucess) {
        errors.push(deleted.error);
      }
    }
    return new Response(
      JSON.stringify({
        message: { errors: errors },
        status: 400,
      }),
      { status: 400 },
    );
  }

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

    if (delete_user_on_error) {
      const deleted = await deleteParticipant(email);
      if (!deleted.sucess) {
        errors.push(deleted.error);
      }
    }

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
      email,
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
      <p>If you want to join our discord server, here's the link: ${discordInvite}</p>
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
  new_member_email: string,
) => {
  const body = `<h2>Hello again 👋</h2>
    <div>
      <p>A new member just joined the team <b>${team_name}</b></p>
      <p>New member: ${new_member_email}</p>
      <p>Number of team members: ${num_team_mem}</p>
      <p>Remember that you or other team members need to pay the total value of the team to confirm the registration at CeSIUM (DI 1.04).</p>
      <p>When the payment is done, the team will be closed and no more members will be able to join it.</p>
      <p>Total value: <b>${total_value_payment}€</b></p>
      <p>Looking forward to seeing you soon!</p>
      <p>Organization team 🪲</p>
    </div>`;
  await sendEmail(email, "[BugsByte] New team member", body);
};

const checkAlreadyInTeam = async (email: string) => {
  const { data, error } = await supabase
    .from("participants")
    .select("team_code")
    .eq("email", email);
  return data && data.length > 0 && data[0].team_code;
};

const deleteParticipant = async (email: string) => {
  const resposeParticipant = await supabase
    .from("participants")
    .delete()
    .eq("email", email);

  if (resposeParticipant.error) {
    return { sucess: false, error: "Error deleting participant" };
  }

  const responseStorage = await deleteFolder(`cv/${email}`);

  if (responseStorage.success === false) {
    return { sucess: false, error: "Error deleting participant files" };
  }

  return { sucess: true, error: "" };
};

const deleteFolder = async (folderPath: string) => {
  try {
    // List all files in the folder
    const { data: files, error: listError } = await supabase.storage
      .from("files")
      .list(folderPath);

    if (listError) {
      console.error("Error listing files:", listError.message);
      return { success: false };
    }

    // Extract file paths
    const filePaths = files.map((file) => `${folderPath}/${file.name}`);
    // Remove all files
    const { data, error: removeError } = await supabase.storage
      .from("files")
      .remove(filePaths);

    if (removeError) {
      console.error("Error removing files:", removeError.message);
      return { success: false };
    }

    return { success: true, data };
  } catch (err) {
    console.error("Unexpected error:", err);
    return { success: false };
  }
};
