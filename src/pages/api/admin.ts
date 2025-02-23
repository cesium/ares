import type { APIRoute } from "astro";
import { serialize } from "cookie";

export const prerender = false;

const AUTH_COOKIE_NAME = "authToken";
const AUTH_SECRET = import.meta.env.AUTH_SECRET; // Used for validation
const password = import.meta.env.ADMIN_SECRET;

export const POST: APIRoute = async ({ request }) => {
    const formData = await request.formData()

    const secret = formData.get("password")?.toString() ?? "";
    if (secret !== password) {
        return new Response(
            JSON.stringify({
                message: { error: "Password Incorrect" },
                status: 400,
            }),
            { status: 400 },
        );
    }

    const token = AUTH_SECRET; // Simple auth token for now
    const cookie = serialize(AUTH_COOKIE_NAME, token, {
        httpOnly: true,
        secure: true,
        sameSite: "strict",
        path: "/"
    });

    return new Response(
        JSON.stringify({
            message: { success: "Authorized", token },
            status: 200,
        }),
        { status: 200, headers: { "Set-Cookie": cookie } },
    );
}

export const GET: APIRoute = async ({ request }) => {
  const cookies = request.headers.get("cookie") || "";
  const authToken = cookies.split("; ").find(row => row.startsWith(`${AUTH_COOKIE_NAME}=`))?.split("=")[1];
  
  if (authToken !== AUTH_SECRET) {
      return new Response(
          JSON.stringify({ message: { error: "Unauthorized" } }),
          { status: 401 }
      );
  }
  
  return new Response(
      JSON.stringify({ message: { success: "Authorized" } }),
      { status: 200 }
  );
};