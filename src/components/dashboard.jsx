import { useEffect, useState } from 'react';
import { Check } from 'lucide-react';
import ConfirmationModal from "~/components/confirmationModal.jsx";
import Badge from "~/components/badge.jsx";

export default function Dashboard() {
  const [loading, setLoading] = useState(true);
  const [teams, setTeams] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [selectedTeam, setSelectedTeam] = useState(null);

  useEffect(() => {
    async function fetchTeams() {
      const response = await fetch("/api/teams/list", { method: "GET" });
      const data = await response.json();
      if (response.ok) {
        setTeams(data);
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

  if (loading) {
    return <div className="flex justify-center items-center min-h-screen text-green-600">Loading...</div>;
  }

  return (
    <div className="min-h-screen flex items-center w-full">
      <div className="flex w-full rounded-lg shadow-lg bg-zinc-800 border-zinc-700 overflow-auto">
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
            {teams.map((team) => (
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
            ))}
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
  );
}