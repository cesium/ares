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

    const token = AUTH_SECRET;
    const cookie = serialize(AUTH_COOKIE_NAME, token, {
        expires: new Date(Date.now() + 1000 * 60 * 60 * 24), // 1 day
        httpOnly: true,
        secure: true,
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

export const GET: APIRoute = async ({ request, cookies }) => {
  const authToken = cookies.get(AUTH_COOKIE_NAME);
 
  if (!authToken || authToken.value !== AUTH_SECRET) {
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

export const DELETE: APIRoute = async ({ request, cookies }) => {
    const authToken = cookies.get(AUTH_COOKIE_NAME);

    if (!authToken || authToken.value !== AUTH_SECRET) {
        return new Response(
            JSON.stringify({ message: { error: "Unauthorized" } }),
            { status: 401 }
        );
    }

    const cookie = serialize(AUTH_COOKIE_NAME, "", {
        expires: new Date(0),
        httpOnly: true,
        secure: true,
        path: "/"
    });

    return new Response(
        JSON.stringify({ message: { success: "Logged out" } }),
        { status: 200, headers: { "Set-Cookie": cookie } }
    );
}