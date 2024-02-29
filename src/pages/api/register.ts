import ShortUniqueId from 'short-unique-id';
import type { APIRoute } from "astro";
import { createClient } from '@supabase/supabase-js'
import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";
import type { DataItem } from "~/types";
import { boolean } from 'astro/zod';

const supabase = createClient(import.meta.env.SUPABASE_URL, import.meta.env.SUPABASE_ANON_KEY)
const client = new SESClient({ region: "eu-west-2" });
const senderEmail = import.meta.env.SENDER_EMAIL;
const discordInvite = import.meta.env.DISCORD_INVITE;

const { randomUUID } = new ShortUniqueId({ length: 6 });

export const POST: APIRoute = async ({ request }) => {
  const formData = await request.formData();

  let errors: String[] = [];
  
  // forms validation
  const valid = await validateForms(formData, errors);
  if(!valid) {
    return new Response(
      JSON.stringify({
        message: {errors: errors},
        status: 400,
      }),
      { status: 400 }
    );
  }

  const files: any = formData.getAll("cv");
  const data: DataItem = {
    name: formData.get("name")?.toString() ?? "", 
    email: formData.get("email")?.toString() ?? "", 
    confirmation: randomUUID().toUpperCase(),
    university: formData.get("university")?.toString() ?? "",
    course: formData.get("course")?.toString() ?? "",
    notes: formData.get("notes")?.toString() ?? "",
    vegan: formData.get("vegan") === 'on'
  };

  const insertion_msg = await supabase.from('participants').insert([data]).select();
  if (insertion_msg.error) {
    let msg = "There was an error connecting to the server. Try again later.";
    errors.push(msg);
    console.error(msg);

    return new Response(
      JSON.stringify({
        message: { errors: errors },
        status: 500,
      }),
      { status: 500 }
    );
  }

  const filePath = `cv/${data.email}/${files[0].name}`;
  const file = files[0]
  const file_insertion_msg = await supabase.storage.from('files').upload(filePath, file);
  if (file_insertion_msg.error) {
    let msg = "There was an error connecting to the server file storage. Try again later.";
    errors.push(msg);
    console.error(msg);
    
    // delete previously created participant 
    await supabase
      .from('participants')
      .delete()
      .eq('email', data.email)

    return new Response(
      JSON.stringify({
        message: { errors: errors },
        status: 500,
      }),
      { status: 500 }
    );
  }

  sendConfirmationEmail(data.email, data.name, data.confirmation);

  return new Response(
    JSON.stringify({
      status: 200,
    }),
    { status: 200 }
  );
};

const validateForms = async (formData: FormData, errors: String[]) => {
  
  let { data: emails, error } = await supabase
  .from('participants')
  .select('email')
  
  const emailList: string[] | undefined = emails?.map(obj => obj.email);
  const email: string | undefined = formData.get("email")?.toString();
  let valid = true;
  if (emailList && email && emailList.includes(email)) {
    valid = false;
    errors.push("Email already in use");
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
  } else if (cv && cv.type != 'application/pdf') {
    valid = false;
    errors.push("File must be a PDF");
  }

  return valid
};


const sendConfirmationEmail = async(email: string, name: string, confirmation: string) => {
  var input = {
    Source: senderEmail.toString(),
    Destination: {
      ToAddresses: [
        email.toString(),
      ],
    },
    Message: {
      Subject: {
        Charset: "UTF-8",
        Data: "[BugsByte] Registration confirmation",
      },
      Body: {
        Html: {
          Data: 
           `<h1>Hello, ${name} 👋</h1>
            <div>
              <p>Your participation in the BugsByte Hackathon is confirmed! Your confirmation number is #${confirmation}</p>
              <p>Make sure to keep this email handy, it's your ticket to the event! Plus, stay tuned for more details as we'll be reaching out to you shortly with all the necessary information.</p>
              <p>If you want to join our discord server, here's the link: ${discordInvite}</p>
              <p>See you soon,</p>
              <p>Organization team 🪲</p>
            </div>`.toString()
        }
      },
    },
  };

  try {
    const command = new SendEmailCommand(input);
    await client.send(command);
    return null;
  } catch (error) {
    return error;
  }
};

const storeParticipant = async (data: DataItem): Promise<boolean> => {
  try {
    return true; // No error occurred
  } catch (error) {
    console.error("Error storing participant:", error);
    return false; // Error occurred
  }
};

const storeFile = async (files: any, email: string): Promise<boolean> => {
  try {

    if (message.error) {
      return true
    } else {
      return false;
    }
  } catch (error) {
    console.error("Error storing the file:", error)
    return false;
  }
};
