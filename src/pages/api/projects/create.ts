import ShortUniqueId from "short-unique-id";
import type { APIRoute } from "astro";
import { createClient } from "@supabase/supabase-js";
import type { DeliverProjectItem } from "~/types";
import { SMTPClient } from "emailjs";

export const prerender = false;

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);
const senderEmail = import.meta.env.SENDER_EMAIL;
const discordInvite = import.meta.env.DISCORD_INVITE;

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

  const data: DeliverProjectItem = {
    team_code: formData.get("team_code")?.toString() ?? "",
    name: formData.get("name")?.toString() ?? "",
    description: formData.get("description")?.toString() ?? "",
    link: formData.get("link")?.toString() ?? "",
  };

  const insertion_msg = await supabase.from("projects").insert([data]).select();
  if (insertion_msg.error) {
    console.log(insertion_msg.error);
    let msg = "There was an error delivering your project. Please try again.";
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
  return valid;
};
