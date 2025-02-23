import { useEffect, useState } from 'react';
import { Check } from 'lucide-react';

export default function Dashboard() {
  const [loading, setLoading] = useState(true);
  const [teams, setTeams] = useState([]);

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
      const response = await fetch("/api/admin", { method: "GET"});
      const data = await response.json();
      if (!response.ok) {
        window.location.href = "/";
      } else {
        setLoading(false);
      }
    }
    checkAuth();
  }, []);


  if (loading) {
    return <div className="flex justify-center items-center min-h-screen text-green-600">Loading...</div>;
  }

  return (
    <div className="min-h-screen flex items-center w-full">
      <div className="flex w-full rounded-lg shadow-lg overflow-hidden">
        <table className="w-full text-left text-sm text-gray-500 ">
          <thead className="bg-green-500 text-xs uppercase text-gray-700">
            <tr>
              <th scope="col" className="px-6 py-3 border-r border-green-400">
                Code
              </th>
              <th scope="col" className="px-6 py-3 border-r border-green-400">
                Name
              </th>
              <th scope="col" className="px-6 py-3 border-r border-green-400">
                Num Elementos
              </th>
              <th scope="col" className="px-6 py-3 border-r border-green-400">
                Pagamento
              </th>
              <th scope="col" className="px-6 py-3 text-center">
                Pago
              </th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white ">
            {teams.map((team) => (
              <tr key={team.code} className="bg-zinc-700 hover:bg-zinc-600">
                <td className="whitespace-nowrap px-6 py-4 font-medium text-white border-r border-white">
                  {team.code}
                </td>
                <td className="px-6 py-4 border-r border-white text-white">{team.name}</td>
                <td className="px-6 py-4 border-r border-white text-white">{team.num_team_mem}</td>
                <td className="px-6 py-4 border-r border-white text-white">
                  {team.total_value_payment ? `${team.total_value_payment}€` : "2€"}
                </td>
                <td className="px-6 py-4">
                  <div className="flex justify-center">
                    <label className="relative inline-flex cursor-pointer items-center">
                      <input
                        type="checkbox"
                        checked={team.paid}
                        disabled={team.paid}
                        className="peer h-5 w-5 cursor-pointer appearance-none rounded border border-gray-300 bg-white transition-colors checked:border-primary checked:bg-primary checked:hover:bg-primary/90 disabled:cursor-not-allowed disabled:opacity-50"
                      />
                      <Check className="pointer-events-none absolute h-4 w-4 text-white opacity-0 peer-checked:opacity-100" />
                    </label>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}