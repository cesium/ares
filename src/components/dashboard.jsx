import { useEffect, useState } from 'react';
import { Check , Search } from 'lucide-react';
import ConfirmationModal from "~/components/confirmationModal.jsx";
import Badge from "~/components/badge.jsx";
import Dropdown from "~/components/dropdown.jsx";

const options = [
  { value: "all", label: "All Teams" },
  { value: "paid", label: "Paid" },
  { value: "unpaid", label: "Unpaid" }
]

export default function Dashboard() {
  const [loading, setLoading] = useState(true);
  const [teams, setTeams] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [selectedTeam, setSelectedTeam] = useState(null);
  const [selectedOption, setSelectedOption] = useState("all");
  const [filteredTeams, setFilteredTeams] = useState([]);
  const [search, setSearch] = useState("");

  useEffect(() => {
    async function fetchTeams() {
      const response = await fetch("/api/teams/list", { method: "GET" });
      const data = await response.json();
      if (response.ok) {
        setTeams(data);
        setFilteredTeams(data);
      }
    }
    fetchTeams();
  }, []);

  useEffect(() => {
    async function checkAuth() {
      const response = await fetch("/api/admin", { method: "GET", credentials: "include" });
      const data = await response.json();
      if (!response.ok) {
        window.location.href = "/";
      } else {
        setLoading(false);
      }
    }
    checkAuth();
  }, []);

  useEffect(() => {
    if (search) {
      const searchResults = teams.filter((team) => team.name.toLowerCase().includes(search.toLowerCase()));
      setFilteredTeams(searchResults);
    } else {
      filterTeams(selectedOption);
    }
  }, [search]);

  async function handleCheckedTeam(team) {
    if (team.paid) return;
    setSelectedTeam(team);
    setShowModal(true);
  }

  async function markTeamAsPaid() {
    const response = await fetch(`/api/teams/${selectedTeam.code}/paid`, { method: "POST" });
    if (response.ok) {
      const updatedTeams = teams.map((team) => {
        if (team.code === selectedTeam.code) {
          return { ...team, paid: true };
        }
        return team;
      });
      setTeams(updatedTeams);
      setShowModal(false);
    }
  }

  async function filterTeams(option) {
    setSelectedOption(option);

    if (option === "all") {
      setFilteredTeams(teams);
    } else if (option === "paid") {
      const paidTeams = teams.filter((team) => team.paid);
      setFilteredTeams(paidTeams);
    } else if (option === "unpaid") {
      const unpaidTeams = teams.filter((team) => !team.paid);
      setFilteredTeams(unpaidTeams);
    }
  }

  if (loading) {
    return <div className="flex justify-center items-center min-h-screen text-green-600">Loading...</div>;
  }

  return (
    <>
      <header className="bg-zinc-950 border-b border-zinc-700 p-4">
        <div className="flex items-center justify-between">
          <h1 className="text-lg font-semibold text-white">Teams Management</h1>
        </div>
      </header>

      <div className="min-h-screen flex items-center w-full p-4">
        <div className="rounded-xl border border-zinc-700 bg-zinc-800 w-full shadow-lg">
          <div className="p-4 border-b border-zinc-700 flex flex-wrap items-center justify-between gap-4">
            <div className="relative w-full md:w-64">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-500" />
              <input
                placeholder="Search teams..."
                className="pl-9 bg-zinc-700 border-zinc-600 text-gray-300 focus:border-green-500 rounded"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
              />
            </div>
            <div className="flex items-center gap-2">
              <Dropdown options={options} functionOnChange={filterTeams} client:load/>
            </div>
          </div>
          <div className="flex bg-zinc-800 border-zinc-700 overflow-auto">
            <table className="w-full text-left text-sm text-gray-500 overflow-x-auto">
              <thead className="bg-zinc-700">
                <tr className="border-b border-zinc-600 hover:bg-transparent">
                  <th scope="col" className="text-green-500 font-medium px-6 py-3">CODE</th>
                  <th scope="col" className="text-green-500 font-medium px-6 py-3 ">NAME</th>
                  <th scope="col" className="text-green-500 font-medium text-center px-6 py-3">PARTICIPANTS</th>
                  <th scope="col" className="text-green-500 font-medium px-6 py-3">CREATED BY</th>
                  <th scope="col" className="text-green-500 font-medium text-right px-6 py-3">PAYMENT VALUE</th>
                  <th scope="col" className="text-green-500 font-medium text-center px-6 py-3">PAYMENT STATUS</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-zinc-700">
                {filteredTeams.length > 0 ? (
                  filteredTeams.map((team) => (
                  <tr key={team.code} className="hover:bg-zinc-700 transition-colors">
                    <td className="font-mono text-gray-300 px-6 py-4">
                      {team.code}
                    </td>
                    <td className="px-6 py-4 font-medium text-white">{team.name}</td>
                    <td className="px-6 py-4 text-center">
                      <Badge className="bg-green-500/10 border-green-500/30">
                        <span className="text-green-500">{team.num_team_mem}</span>
                      </Badge>
                    </td>
                    <td className="px-6 py-4 text-gray-400 max-w-[200px] truncate">{team.created_by}</td>
                    <td className="px-6 py-4 text-right font-medium text-white">
                      {team.total_value_payment ? `${team.total_value_payment}€` : "2€"}
                    </td>
                    <td className="px-6 py-4 text-center">
                      <button
                        onClick={() => handleCheckedTeam(team)}
                        className="group focus:outline-none focus:ring-2 focus:ring-orange-500 focus:ring-offset-2 focus:ring-offset-zinc-800 rounded-full"
                        title={team.paid ? "Click to mark as unpaid" : "Click to mark as paid"}
                        disabled={team.num_team_mem === 1 || team.paid}
                      >
                        {team.paid ? (
                          <Badge className="bg-green-500/20 border-0 border-green-500/30">
                            <Check className="h-3.5 w-3.5 mr-1 text-green-500" />
                            <span className="text-green-500">Paid</span>
                          </Badge>
                        ) : (
                          <Badge
                            variant="outline"
                            className={team.num_team_mem !== 1 ? 
                              ("bg-orange-500/10  border-orange-500/30 hover:bg-orange-500/20 transition-colors cursor-pointer") :
                              ("bg-orange-500/10  border-orange-500/30 cursor-not-allowed")}
                          >
                            <span className={team.num_team_mem !== 1 ? "text-orange-400" : "text-orange-400/50"}>Click to mark as paid</span>
                          </Badge>
                        )}
                      </button>
                    </td>
                  </tr>
                ))) : (
                  <tr className="text-center">
                    <td colSpan="6" className="py-4 text-gray-400">No teams found matching your search.</td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
          {showModal && (
            <ConfirmationModal
              title="Are you sure?"
              content={`Are you sure you want to mark the team ${selectedTeam.name} as paid?`}
              closeModal={() => setShowModal(false)}
              confirmationModal={async () => markTeamAsPaid()}
            />
          )}          
        </div>
      </div>
    </>
  );
}