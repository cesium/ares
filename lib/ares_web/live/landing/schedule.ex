defmodule AresWeb.LandingLive.Schedule do
    use AresWeb, :landing_view

    import AresWeb.Components.Page

    def mount(_params, _session, socket) do
        
        {:ok, socket |> 
            assign(:activities, activities())
        }
    end

    # type: :submission | :activity | :food
    def activities() do
        [
            # Day 1
            %{title: "Check-in", description: "Team registration and badge pickup.", type: :activity, time: ~T[09:00:00], date: ~D[2026-11-19]},
            %{title: "Opening Ceremony", description: "Welcome, rules and challenge reveal.", type: :activity, time: ~T[10:00:00], date: ~D[2026-11-19]},
            %{title: "Hacking Starts", description: "The clock starts ticking.", type: :activity, time: ~T[11:00:00], date: ~D[2026-11-19]},
            %{title: "Lunch", description: "Lunch at the venue.", type: :food, time: ~T[13:00:00], date: ~D[2026-11-19]},
            %{title: "Workshop: Elixir & Phoenix", description: "Hands-on intro to building real-time apps.", type: :activity, time: ~T[15:00:00], date: ~D[2026-11-19]},
            %{title: "Idea Submission", description: "Submit your project idea and team members.", type: :submission, time: ~T[18:00:00], date: ~D[2026-11-19]},
            %{title: "Dinner", description: "Pizza night.", type: :food, time: ~T[20:00:00], date: ~D[2026-11-19]},
            %{title: "Midnight Snack", description: "Fuel for the night owls.", type: :food, time: ~T[00:00:00], date: ~D[2026-11-20]},

            # Day 2
            %{title: "Breakfast", description: "Coffee, croissants and more coffee.", type: :food, time: ~T[08:30:00], date: ~D[2026-11-20]},
            %{title: "Mentoring Round", description: "Get feedback from mentors and partners.", type: :activity, time: ~T[10:00:00], date: ~D[2026-11-20]},
            %{title: "Lunch", description: "Lunch at the venue.", type: :food, time: ~T[13:00:00], date: ~D[2026-11-20]},
            %{title: "Checkpoint Submission", description: "Submit your repository link and progress report.", type: :submission, time: ~T[16:00:00], date: ~D[2026-11-20]},
            %{title: "Talk: From Hackathon to Startup", description: "Partner talk on turning projects into products.", type: :activity, time: ~T[17:00:00], date: ~D[2026-11-20]},
            %{title: "Dinner", description: "Dinner at the venue.", type: :food, time: ~T[20:00:00], date: ~D[2026-11-20]},
            %{title: "Gaming Break", description: "Unwind with some games.", type: :activity, time: ~T[22:00:00], date: ~D[2026-11-20]},

            # Day 3
            %{title: "Breakfast", description: "Last breakfast, almost there.", type: :food, time: ~T[08:30:00], date: ~D[2026-11-21]},
            %{title: "Final Submission", description: "Hacking ends. Submit code, video and slides.", type: :submission, time: ~T[11:00:00], date: ~D[2026-11-21]},
            %{title: "Lunch", description: "Lunch at the venue.", type: :food, time: ~T[12:30:00], date: ~D[2026-11-21]},
            %{title: "Pitches", description: "Teams present their projects to the jury.", type: :activity, time: ~T[14:00:00], date: ~D[2026-11-21]},
            %{title: "Awards & Closing Ceremony", description: "Winners announced. See you next year!", type: :activity, time: ~T[17:30:00], date: ~D[2026-11-21]}
        ]
    end

end