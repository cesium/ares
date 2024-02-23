import type { APIRoute } from "astro";
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(import.meta.env.SUPABASE_URL, import.meta.env.SUPABASE_ANON_KEY)

export const POST: APIRoute = async ({ request, redirect }) => {
  const formData = await request.formData();
  console.log(formData);

  const data = {
    "name": formData.get("name")?.toString(), 
    "email": formData.get("email")?.toString(), 
    "university": formData.get("university")?.toString(),
    "course": formData.get("course")?.toString()
  }
  
  const { error } = await supabase
    .from('participants')
    .insert([
      data,
    ])
    .select()

  if (error) {
    return new Response(error.message, { status: 500 });
  }

  return redirect("/");
};
