import type { APIRoute } from "astro";
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(import.meta.env.SUPABASE_URL, import.meta.env.SUPABASE_ANON_KEY)

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

  // const cv = formData.get("cv");
  const data = {
    "name": formData.get("name")?.toString(), 
    "email": formData.get("email")?.toString(), 
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

  return new Response(
    JSON.stringify({
      status: 200,
    }),
    { status: 200 }
  );
};

const validateForms = async (formData: FormData) => {
  const errors = {
    email: "",
    mobile: "",
    cv: "",
  } 
  
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
