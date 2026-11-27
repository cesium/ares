defmodule Ares.Repo.Seeds.Users do

  alias Ares.{Accounts, Repo}

  @first_names File.read!("priv/fake/first_names.txt") |> String.split("\n", trim: true)
  @last_names File.read!("priv/fake/last_names.txt") |> String.split("\n", trim: true)
  @notes File.read!("priv/fake/notes.txt") |> String.split("\n")

  def run do
    case Accounts.list_users() do
      [] ->
        seed_users()
      _  ->
        Mix.shell().error("Found users, aborting seeding users.")
    end
  end

  def seed_users(attendees \\ 40, admins \\ 15, staff \\ 10, judges \\ 10) do
    seed_attendees(attendees)
    seed_admins(admins)
    seed_staff(staff)
    seed_judges(judges)
  end

  defp seed_attendees(count) do
    for i <- 0..count do
      student = %{
        name: "#{Enum.random(@first_names)} #{Enum.random(@last_names)}",
        email: "attendee#{i}@bugsbyte.org",
        password: "password1234",
        phone: Faker.Phone.PtPt.cell_number(),
        age: Enum.random(19..24) |> Integer.to_string(),
        university: "Universidade do Minho",
        course: "Engenharia Informática",
        notes: Enum.random(@notes)
      }

      create_user(student, :attendee, i)
    end
  end

  defp seed_staff(count) do
    for i <- 0..count do
      staff = %{
        name: "#{Enum.random(@first_names)} #{Enum.random(@last_names)}",
        email: "staff#{i}@bugsbyte.org",
        password: "password1234",
        type: :staff
      }

      create_user(staff, :staff, i)
    end
  end

  defp seed_admins(count) do
    for i <- 0..count do
      student = %{
        name: "#{Enum.random(@first_names)} #{Enum.random(@last_names)}",
        email: "admin#{i}@bugsbyte.org",
        password: "password1234",
        type: :admin
      }

      create_user(student, :admin, i)
    end
  end

  defp seed_judges(count) do
    for i <- 0..count do
      student = %{
        name: "#{Enum.random(@first_names)} #{Enum.random(@last_names)}",
        email: "judge#{i}@bugsbyte.org",
        password: "password1234",
        type: :judge
      }

      create_user(student, :judge, i)
    end
  end

  defp create_user(attrs, role, id) do
    case Accounts.create_user(attrs) do
      {:ok, user} ->
        Repo.update!(Accounts.User.confirm_changeset(user))
        Mix.shell().info("Created #{role} #{user.name} (#{attrs.email})")

      {:error, changeset} ->
        Mix.shell().error("Error creating #{role} #{id}: " <> Kernel.inspect(changeset.errors))
    end
  end
end

Ares.Repo.Seeds.Users.run()
