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

  const { data: commits, error } = await supabase
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
  const urls = commits.link.split(",");

  const valid = checkCommits(urls);
};


const checkCommits = (urls: string[]) => {
    const valid = urls.every((url) => {
        const urlParts = url.split("/");
        const repoName = urlParts[urlParts.length - 1];
        const commitUrl = `${apiGithub}${repoName}/commits?per_page=1`;
    
        getLastCommitDate(commitUrl);
    });
    
    if (valid) {
        return new Response(
        JSON.stringify({ message: { error: "Commits not found" } }),
        { status: 404 },
        );
    }
}
async function getLastCommitDate() {

  try {
    const response = await axios.get(url, {
      headers: {
        Accept: "application/vnd.github+json",
      },
    });

    const lastCommitDate = response.data[0].commit.committer.date;
    console.log(`The last commit date is: ${lastCommitDate}`);
  } catch (error) {
    console.error("Error fetching the last commit date:", error);
  }
}
