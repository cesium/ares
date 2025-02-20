import ShortUniqueId from "short-unique-id";
import type { APIRoute } from "astro";
import { createClient } from "@supabase/supabase-js";
import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";
import type { RegisterItem } from "~/types";

export const prerender = false;

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);
const senderEmail = import.meta.env.SENDER_EMAIL;
const discordInvite = import.meta.env.DISCORD_INVITE;
const ses = new SESClient({
  region: import.meta.env.SES_AWS_REGION,
  credentials: {
    accessKeyId: import.meta.env.SES_AWS_ACCESS_KEY_ID,
    secretAccessKey: import.meta.env.SES_AWS_SECRET_ACCESS_KEY,
  },
});

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

  const files: any = formData.getAll("cv");
  const data: RegisterItem = {
    name: formData.get("name")?.toString() ?? "",
    email: formData.get("email")?.toString() ?? "",
    mobile: formData.get("mobile")?.toString() ?? "",
    age: Number(formData.get("age")),
    confirmation: randomUUID().toUpperCase(),
    university: formData.get("university")?.toString() ?? "",
    course: formData.get("course")?.toString() ?? "",
    notes: formData.get("notes")?.toString() ?? "",
    vegan: formData.get("vegan") === "on",
  };

  const insertion_msg = await supabase
    .from("participants")
    .insert([data])
    .select();
  if (insertion_msg.error) {
    errors.push(
      "There was an error connecting to the server. Try again later.",
    );
    return new Response(
      JSON.stringify({
        message: { errors: errors },
        status: 500,
      }),
      { status: 500 },
    );
  }

  const fileExtension = files[0].name.split(".").pop();
  const name = data.email.split("@")[0];
  const filePath = `cv/${data.email}/${name}.${fileExtension}`;
  const file = files[0];
  const file_insertion_msg = await supabase.storage
    .from("files")
    .upload(filePath, file);
  if (file_insertion_msg.error) {
    errors.push(
      "There was an error connecting to the server file storage. Try again later.",
    );
    await supabase.from("participants").delete().eq("email", data.email);
    return new Response(
      JSON.stringify({
        message: { errors: errors },
        status: 500,
      }),
      { status: 500 },
    );
  }

  await sendConfirmationEmail(data.email, data.name, data.confirmation);

  return new Response(JSON.stringify({ status: 200 }), { status: 200 });
};

const validateForms = async (formData: FormData, errors: String[]) => {
  let { data: emails } = await supabase.from("participants").select("email");
  const emailList: string[] | undefined = emails?.map((obj) => obj.email);
  const email: string | undefined = formData.get("email")?.toString();
  let valid = true;

  if (emailList && email && emailList.includes(email)) {
    valid = false;
    errors.push("Email already in use");
  }

  const age = Number(formData.get("age"));
  if (age < 18) {
    valid = false;
    errors.push("You need to be at least 18 years old to participate");
  }

  const mobile_re = new RegExp(/(^9[1236][0-9]) ?([0-9]{3}) ?([0-9]{3})$/);
  const mobile: string | undefined = formData.get("mobile")?.toString().trim();
  if (mobile && !mobile_re.test(mobile)) {
    valid = false;
    errors.push("Invalid Portuguese phone number");
  }

  const cv: any = formData.get("cv");
  if (cv && cv.size > 8000000) {
    valid = false;
    errors.push("File too big");
  } else if (cv && cv.type !== "application/pdf") {
    valid = false;
    errors.push("File must be a PDF");
  }

  return valid;
};

const sendConfirmationEmail = async (
  email: string,
  name: string,
  confirmation: string,
) => {
  const params = new SendEmailCommand({
    Source: senderEmail,
    Destination: { ToAddresses: [email] },
    Message: {
      Subject: { Data: "[BugsByte] Registration Confirmation" },
      Body: {
        Html: {
          Data: `<h2>Hello, ${name} 👋</h2>
            <div>
              <p>Your participation in the BugsByte Hackathon is confirmed! Your confirmation number is <b>#${confirmation}</b></p>
              <p>Make sure to keep this email handy, it's your ticket to the event! Plus, stay tuned for more details as we'll be reaching out to you shortly with all the necessary information.</p>
              <p>If you want to join our discord server, here's the link: ${discordInvite}</p>
              <p>See you soon,</p>
              <p>Organization team 🪲</p>
            </div>`,
        },
      },
    },
  });

  try {
    await ses.send(params);
  } catch (error) {
    console.error("Error sending email:", error);
  }
};
