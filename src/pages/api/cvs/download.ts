import type { APIRoute } from "astro";
import { createClient } from "@supabase/supabase-js";
import JSZip from "jszip";

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

  if (emails && Array.isArray(emails)) {
    const zip = new JSZip();

    for (const email of emails) {
      const name = email.split("@")[0];
      const path = `cv/${email}/${name}.pdf`;
      const { data: cv, error } = await supabase.storage
        .from("files")
        .download(path);

      if (error) {
        const path_PDF = `cv/${email}/${name}.PDF`;
        const { data: cv_PDF, error: error_PDF } = await supabase.storage
          .from("files")
          .download(path_PDF);

        if (error_PDF) {
          console.error("Error downloading CV:", name);
          return new Response(
            JSON.stringify({ message: { error: "CV not found" } }),
            { status: 404 },
          );
        }

        const arrayBuffer = await cv_PDF.arrayBuffer();
        zip.file(`${name}.pdf`, arrayBuffer);
        continue;
      }

      const arrayBuffer = await cv.arrayBuffer();
      zip.file(`${name}.pdf`, arrayBuffer);
    }

    if (Object.keys(zip.files).length === 0) {
      return new Response(JSON.stringify({ error: "No CVs found" }), {
        status: 404,
      });
    }

    const zipBlob = await zip.generateAsync({ type: "blob" });

    return new Response(zipBlob, {
      headers: {
        "Content-Disposition": "attachment; filename=cvs.zip",
        "Content-Type": "application/zip",
      },
    });
  }

  return new Response(
    JSON.stringify({ message: { error: "Invalid request" } }),
    { status: 400 },
  );
};
