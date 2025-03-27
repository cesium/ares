import type { APIRoute } from "astro";
import { createClient } from "@supabase/supabase-js";
import type { SubmitProjectItem } from "~/types";

export const prerender = false;

const supabase = createClient(
  import.meta.env.SUPABASE_URL,
  import.meta.env.SUPABASE_ANON_KEY,
);

const apiGithub = "https://api.github.com/repos/";
const beginContestDate = new Date("2022-03-28T18:00:00Z");

export const POST: APIRoute = async ({ request }) => {
  const formData = await request.formData();

  let errors: String[] = [];

  // forms validation
  const valid = await validateForms(formData, errors);
  if (!valid) {
    return new Response(
      JSON.stringify({
        message: { errors: errors },
        status: 400,
      }),
      { status: 400 },
    );
  }

  const data: SubmitProjectItem = {
    team_code: formData.get("team_code")?.toString().replace("#", "") ?? "",
    name: formData.get("name")?.toString() ?? "",
    description: formData.get("description")?.toString() ?? "",
    link: formData.get("link")?.toString() ?? "",
  };

  const insertion_msg = await supabase.from("projects").insert([data]).select();
  if (insertion_msg.error) {
    console.log(insertion_msg.error);
    let msg = "There was an error delivering your project. Please try again.";
    errors.push(msg);

    return new Response(
      JSON.stringify({
        message: { errors: errors },
        status: 500,
      }),
      { status: 500 },
    );
  }

  return new Response(
    JSON.stringify({
      status: 200,
    }),
    { status: 200 },
  );
};

const validateForms = async (formData: FormData, errors: String[]) => {
  const team_code = formData.get("team_code")?.toString().replace("#", "");
  const link = formData.get("link")?.toString();

  if (!team_code || !link) {
    errors.push("All fields are required.");
    return false
  }

  const valid = (await validateTeamCode(team_code, errors) && await validateLink(link, errors))

  return valid;
};


const validateTeamCode = async (team_code: string, errors: String[]) => {
  let valid = true;

  let { data: projects, error } = await supabase
  .from("projects")
  .select("*")
  .eq("team_code", team_code);

  if (error) {
    errors.push(
      "There was an error connecting to the server. Try again later.",
    );
    valid = false;
  } else if (projects && projects?.length > 0) {
    errors.push("There's already a project with this team code.");
    valid = false;
  }

  return valid;
}  

const validateLink = async (link: string, errors: String[]) => {
  const githubLinkRegex = /^https:\/\/github\.com\/([A-Za-z0-9_.-]+)\/([A-Za-z0-9_.-]+)$/;

  const match = link.match(githubLinkRegex);
  if (!match) {
    errors.push("The link must be a valid GitHub repository URL.");
    return false;
  }

  const [, username, repositoryName] = match;

  const response = await fetch(apiGithub + `${username}/${repositoryName}`);
  if (!response.ok) {
    errors.push("The repository doesn't exist or is private.");
    return false;
  }

  const data = await response.json();
  const creationDate = new Date(data.created_at);
  if (creationDate < beginContestDate) {
    errors.push("The repository must be created after the contest start date.");
    return false;
  }

  return true;
}