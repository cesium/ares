import type { APIRoute } from "astro";
import { createClient } from "@supabase/supabase-js";

export const prerender = false;

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);

const AUTH_COOKIE_NAME = "authToken";
const AUTH_SECRET = import.meta.env.AUTH_SECRET;

const apiGithub = "https://api.github.com/repos/";
const lastCommitDate = new Date("2025-03-30T13:30:00Z");

export const GET: APIRoute = async ({ request, cookies }) => {
  const authToken = cookies.get(AUTH_COOKIE_NAME);

  if (!authToken || authToken.value !== AUTH_SECRET) {
    return new Response(
      JSON.stringify({ message: { error: "Unauthorized" } }),
      { status: 401 },
    );
  }

  const url = new URL(request.url);
  const teamParam = url.searchParams.get("team");

  if (!teamParam) {
    return new Response(
      JSON.stringify({ message: { error: "Team not found" } }),
      { status: 404 },
    );
  }

  const { data: links, error } = await supabase
    .from("projects")
    .select("link")
    .eq("team_code", teamParam)
    .single();

  if (error) {
    return new Response(
      JSON.stringify({ message: { error: "Commits not found" } }),
      { status: 404 },
    );
  }

  const valid = await checkCommits(links.link);

  if (!valid) {
    return new Response(
      JSON.stringify({ message: { valid: false, error: "Invalid commits" } }),
      { status: 200 },
    );
  }
  return new Response(
    JSON.stringify({
      message: { valid: true, error: null },
      status: 200,
    }),
    { status: 200 },
  );
};

const checkCommits = async (link: string) => {
  const links = typeof link === "string" ? link.split(" ") : [];

  for (let i = 0; i < links.length; i++) {
    const link = links[i].trim();
    if (link.length > 0) {
      const valid = await validateCommit(link);
      if (!valid) {
        return false;
      }
    }
  }

  return true;
};

const validateCommit = async (link: string) => {
  const githubLinkRegex =
    /^https:\/\/github\.com\/([A-Za-z0-9_.-]+)\/([A-Za-z0-9_.-]+)$/;

  const match = link.match(githubLinkRegex);
  if (!match) {
    console.log("Invalid link format");
    return false;
  }

  const [, username, repositoryName] = match;

  const response = await fetch(
    apiGithub + `${username}/${repositoryName}/commits`,
  );
  if (!response.ok) {
    console.log("Error fetching commits");
    return false;
  }

  const data = await response.json();
  const lastCommit = new Date(data[0].commit.author.date);

  if (lastCommit >= lastCommitDate) {
    console.log("Last commit is too recent");
    return false;
  }

  return true;
};
