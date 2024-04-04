import ShortUniqueId from "short-unique-id";
import type { APIRoute } from "astro";
import { createClient } from "@supabase/supabase-js";
import type { RegisterItem } from "~/types";
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
    let msg = "There was an error connecting to the server. Try again later.";
    errors.push(msg);

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
    let msg =
      "There was an error connecting to the server file storage. Try again later.";
    errors.push(msg);

    // delete previously created participant
    await supabase.from("participants").delete().eq("email", data.email);

    return new Response(
      JSON.stringify({
        message: { errors: errors },
        status: 500,
      }),
      { status: 500 },
    );
  }

  sendConfirmationEmail(data.email, data.name, data.confirmation);

  return new Response(
    JSON.stringify({
      status: 200,
    }),
    { status: 200 },
  );
};

const validateForms = async (formData: FormData, errors: String[]) => {
  let { data: emails, error } = await supabase
    .from("participants")
    .select("email");

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
    errors.push("Invalid portuguese phone number");
  }

  const cv: any = formData.get("cv");
  if (cv && cv.size > 8000000) {
    valid = false;
    errors.push("File too big");
  } else if (cv && cv.type != "application/pdf") {
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
  const message = {
    text: "",
    from: senderEmail.toString(),
    to: email.toString(),
    subject: "[BugsByte] Registration confirmation",
    attachment: [
      {
        data: `<h1>Hello, ${name} 👋</h1>
          <div>
            <p>Your participation in the BugsByte Hackathon is confirmed! Your confirmation number is #${confirmation}</p>
            <p>Make sure to keep this email handy, it's your ticket to the event! Plus, stay tuned for more details as we'll be reaching out to you shortly with all the necessary information.</p>
            <p>If you want to join our discord server, here's the link: ${discordInvite}</p>
            <p>See you soon,</p>
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
