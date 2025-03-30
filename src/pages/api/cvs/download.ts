import type { APIRoute } from "astro";
import { createClient } from "@supabase/supabase-js";


export const prerender = false;

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);

const AUTH_COOKIE_NAME = "authToken";
const AUTH_SECRET = import.meta.env.AUTH_SECRET;

export const GET: APIRoute = async ({ request, cookies }) => {
  const authToken = cookies.get(AUTH_COOKIE_NAME);
  
  if (!authToken || authToken.value !== AUTH_SECRET) {
    return new Response(
      JSON.stringify({ message: { error: "Unauthorized" } }),
      { status: 401 },
    );
  }
  
  const url = new URL(request.url);
  const emailsParam = url.searchParams.get("emails");
  const emails = emailsParam ? emailsParam.split(",") : null;

  const cvs: Blob[] = [];

  if (emails && Array.isArray(emails)) {
    for (const email of emails) {
      const name = email.split("@")[0];
      const path = `cv/${email}/${name}.pdf`;
      const { data: cv, error } = await supabase
        .storage
        .from("files")
        .download(path);

      if (error) {
        return new Response(
          JSON.stringify({ message: { error: "CV not found" } }),
          { status: 404 },
        );
      }
      cvs.push(cv);
    }
    if (cvs.length === 0) {
      return new Response(
        JSON.stringify({ message: { error: "No CVs found" } }),
        { status: 404 },
      );
    }
    const zip = new JSZip();
    cvs.forEach((cv, index) => {
      zip.file(`cv_${index + 1}.pdf`, cv);
    });

    const zipBlob = await zip.generateAsync({ type: "blob" });

    return new Response(zipBlob, {
      status: 200,
      headers: {
      "Content-Type": "application/zip",
      "Content-Disposition": "attachment; filename=cvs.zip",
      },
    });
  }

  return new Response(
    JSON.stringify({ message: { error: "Invalid request" } }),
    { status: 400 },
  );
};
