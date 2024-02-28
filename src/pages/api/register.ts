import ShortUniqueId from 'short-unique-id';
import type { APIRoute } from "astro";
import { createClient } from '@supabase/supabase-js'
import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";

const supabase = createClient(import.meta.env.SUPABASE_URL, import.meta.env.SUPABASE_ANON_KEY)
const senderEmail = import.meta.env.SENDER_EMAIL;
const client = new SESClient({ region: "eu-west-2" });

const errors = {
  email: "",
  mobile: "",
  cv: "",
}

const { randomUUID } = new ShortUniqueId({ length: 6 });

export const POST: APIRoute = async ({ request }) => {
  const formData = await request.formData();
  
  const {valid, errors} = await validateForms(formData);
  if(!valid) {
    return new Response(
      JSON.stringify({
        message: errors,
        status: 400,
      }),
      { status: 400 }
    );
  }

  const files: any = formData.getAll("cv");
  const data = {
    "name": formData.get("name")?.toString(), 
    "email": formData.get("email")?.toString(), 
    "confirmation": randomUUID(),
    "university": formData.get("university")?.toString(),
    "course": formData.get("course")?.toString(),
    "notes": formData.get("notes")?.toString(),
    "vegan": formData.get("vegan") == 'on' ? true : false
  }

  const hasErrors = Object.values(errors).some(msg => msg)
  if (!hasErrors) {
    const { error } = await supabase
      .from('participants')
      .insert([
        data,
      ])
      .select()

    if (error) {
      return new Response(error.message, { status: 500 });
    }
  }
  
  const filePath = `cv/${data.email}/${files[0].name}`;
  const file = files[0]
  const { data: string, error } = await supabase.storage.from('files').upload(filePath, file);

  if (error) {
    errors.cv += error.message;
    const errorCode = parseInt(error.statusCode);

    return new Response(
      JSON.stringify({
        message: errors,
        status: errorCode,
      }),
      { status: errorCode }
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

const validateForms = async (formData: FormData) => {
  
  let { data: emails, error } = await supabase
  .from('participants')
  .select('email')
  
  const emailList: string[] | undefined = emails?.map(obj => obj.email);
  const email: string | undefined = formData.get("email")?.toString();
  let valid = true;
  if (emailList && email && emailList.includes(email)) {
    valid = false;
    errors.email += "Email already in use"
  }
  
  const mobile_re = new RegExp(/(^9[1236][0-9]) ?([0-9]{3}) ?([0-9]{3})$/);
  const mobile: string | undefined = formData.get("mobile")?.toString().trim();
  if (mobile && !mobile_re.test(mobile)) {
    valid = false;
    errors.mobile += "Invalid portuguese phone number"
  }

  const cv: any = formData.get("cv");
  if (cv && cv.size > 8000000) {
    valid = false;
    errors.cv += "File too big"
  } else if (cv && cv.type != 'application/pdf') {
    valid = false;
    errors.cv += "File must be a pdf"
  }

  return {valid, errors}
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
              <p>If you want to join our discord server, here's the link: http://google.com</p>
              <p>See you soon,</p>
              <p>Organization team 🪲</p>
            </div>`.toString()
        }
      },
    },
  };

  try {
    const command = new SendEmailCommand(input);
    const response = await client.send(command);
    return response;
  } catch (error) {
    return error;
  }
};

