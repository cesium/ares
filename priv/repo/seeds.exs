# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bugsbyte.Repo.insert!(%Bugsbyte.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Bugsbyte.Repo
alias Bugsbyte.Users.User
alias Bugsbyte.Teams.Team

# Create sample users
users = [
  %User{
    name: "Admin",
    email: "admin@cesium.pt",
    phone: "925000000",
    age: "25",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    vegan: false,
    notes: "Administrator account",
    cv_filename: nil,
    is_admin: true
  },
  %User{
    name: "João Silva",
    email: "joao@cesium.pt",
    phone: "925123456",
    age: "21",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: "TEAM001",
    vegan: false,
    notes: "Interested in cybersecurity and backend development",
    cv_filename: "joao_cv.pdf"
  },
  %User{
    name: "Maria Costa",
    email: "maria@cesium.pt",
    phone: "925234567",
    age: "20",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: "TEAM001",
    vegan: true,
    notes: "Passionate about frontend and UI/UX design",
    cv_filename: "maria_cv.pdf"
  },
  %User{
    name: "Pedro Oliveira",
    email: "pedro@cesium.pt",
    phone: "925345678",
    age: "22",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: "TEAM002",
    vegan: false,
    notes: "Expert in machine learning and data science",
    cv_filename: "pedro_cv.pdf"
  },
  %User{
    name: "Ana Santos",
    email: "ana@cesium.pt",
    phone: "925456789",
    age: "21",
    university: "Universidade do Minho",
    course: "Mestrado em Engenharia Informática",
    team_code: "TEAM002",
    vegan: false,
    notes: "DevOps and cloud infrastructure specialist",
    cv_filename: "ana_cv.pdf"
  },
  %User{
    name: "Rui Ferreira",
    email: "rui@cesium.pt",
    phone: "925567890",
    age: "20",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: "TEAM003",
    vegan: false,
    notes: "Full-stack developer with 2 years of experience",
    cv_filename: "rui_cv.pdf"
  },
  %User{
    name: "Sofia Martins",
    email: "sofia@cesium.pt",
    phone: "925678901",
    age: "19",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: "TEAM005",
    vegan: false,
    notes: "Mobile app developer with focus on iOS",
    cv_filename: "sofia_cv.pdf"
  },
  %User{
    name: "Carlos Mendes",
    email: "carlos@cesium.pt",
    phone: "925789012",
    age: "23",
    university: "Universidade do Minho",
    course: "Mestrado em Engenharia Informática",
    team_code: "TEAM005",
    vegan: false,
    notes: "Game developer and graphics specialist",
    cv_filename: "carlos_cv.pdf"
  },
  %User{
    name: "Inês Rocha",
    email: "ines@cesium.pt",
    phone: "925890123",
    age: "21",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: "TEAM005",
    vegan: true,
    notes: "Web security expert and ethical hacker",
    cv_filename: "ines_cv.pdf"
  },
  %User{
    name: "Tiago Gomes",
    email: "tiago@cesium.pt",
    phone: "925901234",
    age: "22",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: "TEAM005",
    vegan: false,
    notes: "Cloud architect and infrastructure expert",
    cv_filename: "tiago_cv.pdf"
  },
  %User{
    name: "Mariana Silva",
    email: "mariana@cesium.pt",
    phone: "925012345",
    age: "20",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: "TEAM003",
    vegan: false,
    notes: "Database design specialist with PostgreSQL expertise",
    cv_filename: "mariana_cv.pdf"
  },
  %User{
    name: "Lucas Barbosa",
    email: "lucas@cesium.pt",
    phone: "925123467",
    age: "21",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: "TEAM003",
    vegan: false,
    notes: "AI and machine learning enthusiast",
    cv_filename: "lucas_cv.pdf"
  },
  %User{
    name: "Rafael Costa",
    email: "rafael@cesium.pt",
    phone: "925234578",
    age: "20",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: "TEAM005",
    vegan: false,
    notes: "Network engineer and systems administrator",
    cv_filename: "rafael_cv.pdf"
  }
]

Enum.each(users, fn user ->
  Repo.insert!(user, on_conflict: :nothing)
end)

# Create sample teams
teams = [
  %Team{
    name: "Bug Hunters",
    description: "Team focused on security and bug bounty",
    code: "TEAM001",
    captain_name: "João Silva",
    captain_email: "joao@cesium.pt",
    captain_phone: "925123456",
    member1_name: "Maria Costa",
    member1_email: "maria@cesium.pt",
    skills_needed: "Security, Backend",
    experience_level: "intermediate",
    looking_for_members: false
  },
  %Team{
    name: "Data Ninjas",
    description: "Machine learning and data analytics specialists",
    code: "TEAM002",
    captain_name: "Pedro Oliveira",
    captain_email: "pedro@cesium.pt",
    captain_phone: "925345678",
    member1_name: "Ana Santos",
    member1_email: "ana@cesium.pt",
    skills_needed: "Python, ML, Data Science",
    experience_level: "advanced",
    looking_for_members: false
  },
  %Team{
    name: "Code Masters",
    description: "Full-stack development excellence",
    code: "TEAM003",
    captain_name: "Rui Ferreira",
    captain_email: "rui@cesium.pt",
    captain_phone: "925567890",
    member1_name: "Mariana Silva",
    member1_email: "mariana@cesium.pt",
    member2_name: "Lucas Barbosa",
    member2_email: "lucas@cesium.pt",
    skills_needed: "Elixir, React, DevOps",
    experience_level: "advanced",
    looking_for_members: false
  },
  %Team{
    name: "Innovation Lab",
    description: "Exploring new technologies and paradigms",
    code: "TEAM004",
    captain_name: "Tech Leader",
    captain_email: "innovation@cesium.pt",
    captain_phone: "925678901",
    skills_needed: "Any skills welcome",
    experience_level: "beginner",
    looking_for_members: true
  },
  %Team{
    name: "Tech Titans",
    description: "Elite team of versatile developers tackling complex problems",
    code: "TEAM005",
    captain_name: "Sofia Martins",
    captain_email: "sofia@cesium.pt",
    captain_phone: "925678901",
    member1_name: "Carlos Mendes",
    member1_email: "carlos@cesium.pt",
    member2_name: "Inês Rocha",
    member2_email: "ines@cesium.pt",
    member3_name: "Tiago Gomes",
    member3_email: "tiago@cesium.pt",
    member4_name: "Rafael Costa",
    member4_email: "rafael@cesium.pt",
    skills_needed: "Mobile, Games, Security, Cloud",
    experience_level: "advanced",
    looking_for_members: false
  }
]

Enum.each(teams, fn team ->
  Repo.insert!(team, on_conflict: :nothing)
end)
