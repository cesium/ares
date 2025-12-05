# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ares.Repo.insert!(%Ares.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Ares.Repo
alias Ares.Users.User
alias Ares.Teams.Team

# Hash for password "admin123"
admin_hash = "$2b$12$w.N.VigbjG9dXh/xgx/VruM1eBwP4cHOxbd4BLKUiXlkb3xoug2Mq"
# Hash for password "user123"
user_hash = "$2b$12$3wC3kLpov3qN/oGsUjO1uu/Lw6dxzDmUGu0w3X5JRshSeVm85AVrS"

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
    cv: nil,
    is_admin: true,
    password_hash: admin_hash
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
    cv: nil,
    password_hash: user_hash
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
    cv: nil,
    password_hash: user_hash
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
    cv: nil,
    password_hash: user_hash
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
    cv: nil,
    password_hash: user_hash
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
    cv: nil,
    password_hash: user_hash
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
    cv: nil,
    password_hash: user_hash
  },
  %User{
    name: "Jonas Johaness",
    email: "jonas@cesium.pt",
    phone: "925123456",
    age: "21",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: "TEAM004",
    vegan: false,
    notes: "Interested in cybersecurity and backend development",
    cv: nil,
    password_hash: user_hash
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
    cv: nil,
    password_hash: user_hash
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
    cv: nil,
    password_hash: user_hash
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
    cv: nil,
    password_hash: user_hash
  },
  %User{
    name: "Mariana Silva",
    email: "mariana@cesium.pt",
    phone: "925012345",
    age: "20",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: nil,
    vegan: false,
    notes: "Database design specialist with PostgreSQL expertise",
    cv: nil,
    password_hash: user_hash
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
    cv: nil,
    password_hash: user_hash
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
    cv: nil,
    password_hash: user_hash
  },
  %User{
    name: "Bernardo Dias",
    email: "bernardo@cesium.pt",
    phone: "925345689",
    age: "22",
    university: "Universidade do Minho",
    course: "Engenharia Informática",
    team_code: nil,
    vegan: false,
    notes: "Independent developer looking for a team",
    cv: nil,
    password_hash: user_hash
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
    skills_needed: "Security, Backend",
    experience_level: "intermediate",
    looking_for_members: false,
    paid: false
  },
  %Team{
    name: "Data Ninjas",
    description: "Machine learning and data analytics specialists",
    code: "TEAM002",
    skills_needed: "Python, ML, Data Science",
    experience_level: "advanced",
    looking_for_members: false,
    paid: false
  },
  %Team{
    name: "Code Masters",
    description: "Full-stack development excellence",
    code: "TEAM003",
    skills_needed: "Elixir, React, DevOps",
    experience_level: "advanced",
    looking_for_members: false,
    paid: true
  },
  %Team{
    name: "Innovation Lab",
    description: "Exploring new technologies and paradigms",
    code: "TEAM004",
    skills_needed: "Any skills welcome",
    experience_level: "beginner",
    paid: true
  },
  %Team{
    name: "Tech Titans",
    description: "Elite team of versatile developers tackling complex problems",
    code: "TEAM005",
    skills_needed: "Mobile, Games, Security, Cloud",
    experience_level: "advanced",
    looking_for_members: false,
    paid: true
  }
]

Enum.each(teams, fn team ->
  Repo.insert!(team, on_conflict: :nothing)
end)
