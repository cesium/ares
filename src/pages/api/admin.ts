import type { APIRoute } from "astro";

export const prerender = false;

const password = import.meta.env.ADMIN_SECRET;

export const POST: APIRoute = async ({ request }) => {
    const formData = await request.formData()

    const secret = formData.get("password")?.toString() ?? "";
    if (secret !== password) {
        return new Response(
            JSON.stringify({
                message: { error: "Unauthorized" },
                status: 400,
            }),
            { status: 400 },
        );
    }

    return new Response(
        JSON.stringify({
            message: { success: "Authorized" },
            status: 200,
        }),
        { status: 200 },
    );
}