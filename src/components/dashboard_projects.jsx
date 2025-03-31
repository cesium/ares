import { useEffect, useState } from "react";
import {
  Check,
  Search,
  ChevronLeft,
  ChevronRight,
  Download,
} from "lucide-react";
import Dropdown from "~/components/dropdown.jsx";
import { cn } from "@udecode/cn";
import Badge from "~/components/badge.jsx";
import InformationModal from "~/components/informationModal.jsx";
import JSZip from "jszip";

const options = [
  { value: "all", label: "Filter Themes" },
  { value: "mcsonae", label: "McSonae" },
  { value: "uphold", label: "Uphold" },
  { value: "singlestore", label: "SingleStore" },
];

export default function Dashboard() {
  const [loading, setLoading] = useState(true);
  const [loadingCommits, setLoadingCommits] = useState(false);
  const [resultCommits, setResultCommits] = useState("");
  const [projects, setProjects] = useState([]);
  const [selectedOption, setSelectedOption] = useState("all");
  const [filteredProjects, setFilteredProjects] = useState([]);
  const [search, setSearch] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 5;
  const totalPages = Math.ceil(filteredProjects.length / itemsPerPage);
  const startIndex = (currentPage - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  const currentProjects = filteredProjects.slice(startIndex, endIndex);

  // Navigation functions
  const goToNextPage = () => {
    setCurrentPage((current) => Math.min(current + 1, totalPages));
  };

  const goToPreviousPage = () => {
    setCurrentPage((current) => Math.max(current - 1, 1));
  };

  const goToPage = (pageNumber) => {
    setCurrentPage(pageNumber);
  };

  useEffect(() => {
    setCurrentPage(1);
  }, [search, selectedOption]);

  const getPageNumbers = () => {
    const pageNumbers = [];
    const maxVisiblePages = 3;

    let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
    const endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);

    // Adjust start page if we're near the end
    if (endPage - startPage + 1 < maxVisiblePages) {
      startPage = Math.max(1, endPage - maxVisiblePages + 1);
    }

    for (let i = startPage; i <= endPage; i++) {
      pageNumbers.push(i);
    }

    return pageNumbers;
  };

  useEffect(() => {
    async function fetchProjects() {
      const response = await fetch("/api/projects/list", { method: "GET" });
      const data = await response.json();
      if (response.ok) {
        setProjects(data);
        setFilteredProjects(data);
      }
    }
    fetchProjects();
  }, []);

  useEffect(() => {
    async function checkAuth() {
      const response = await fetch("/api/admin", {
        method: "GET",
        credentials: "include",
      });
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
      const searchResults = projects.filter(
        (project) =>
          project.name.toLowerCase().includes(search.toLowerCase()) ||
          project.team_code.toLowerCase().includes(search.toLowerCase()),
      );
      setFilteredProjects(searchResults);
    } else {
      filterProjects(selectedOption);
    }
  }, [search]);

  async function filterProjects(option) {
    setSelectedOption(option);

    if (option === "all") {
      setFilteredProjects(projects);
    } else if (option === "mmcsonae") {
      const mcsonaeProjects = projects.filter(
        (team) => team.theme === "McSonae",
      );
      setFilteredProjects(mcsonaeProjects);
    } else if (option === "uphold") {
      const upholdProjects = projects.filter((team) => team.theme === "Uphold");
      setFilteredProjects(upholdProjects);
    } else if (option === "singlestore") {
      const singlestoreProjects = projects.filter(
        (team) => team.theme === "SingleStore",
      );
      setFilteredProjects(singlestoreProjects);
    }
  }

  async function downloadCvs() {
    const queryParams = new URLSearchParams({
      codes: projects.map((project) => project.team_code).join(","),
    }).toString();

    const participants_request = await fetch(
      `/api/participants/list?${queryParams}`,
      {
        method: "GET",
      },
    );

    const teams_request = await fetch("/api/teams/list", {
      method: "GET",
    });

    const map_code_participants = await participants_request.json();
    const list_teams = await teams_request.json();

    const map_teams_participants = {};

    list_teams.forEach((team) => {
      const teamCode = team.code;
      const teamName = team.name;

      if (map_code_participants[teamCode]) {
        // Map the team name to the corresponding participants
        map_teams_participants[teamName] = map_code_participants[teamCode];
      }
    });

    const map_teams_cvs = {};

    await Promise.all(
      Object.entries(map_teams_participants).map(
        async ([teamName, participants]) => {
          const queryParamsCvs = new URLSearchParams({
            emails: participants.join(","),
          }).toString();

          const cvsrequest = await fetch(
            `/api/cvs/download?${queryParamsCvs}`,
            {
              method: "GET",
            },
          );

          if (!cvsrequest.ok) {
            console.error(`Failed to download CVs for ${teamName}`);
            return;
          }

          const blob = await cvsrequest.blob();
          map_teams_cvs[teamName] = blob;
        },
      ),
    );

    if (Object.keys(map_teams_cvs).length === 0) {
      console.error("No CVs were downloaded.");
      return;
    }

    // Create ZIP file
    const zip = new JSZip();
    for (const [teamName, blob] of Object.entries(map_teams_cvs)) {
      zip.file(`${teamName}.zip`, blob);
    }

    // Generate and download ZIP
    const zipBlob = await zip.generateAsync({ type: "blob" });
    const link = document.createElement("a");
    link.href = URL.createObjectURL(zipBlob);
    link.download = selectedOption + ".zip";
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }

  async function CheckCommits(team_code) {
    setLoadingCommits(true);
    const response = await fetch(`/api/projects/commits?team=${team_code}`, {
      method: "GET",
    });
    const data = await response.json();
    setLoadingCommits(false);
    if (response.ok) {
      const result = data.message.valid
        ? "Last commit is valid"
        : "Last commit after the deadline";
      setResultCommits(result);
    } else {
      setResultCommits("Error fetching commits");
    }
  }

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-screen text-green-600">
        Loading...
      </div>
    );
  }

  return (
    <>
      <header className="bg-zinc-950 border-b border-zinc-700 p-4">
        <div className="flex items-center justify-between">
          <h1 className="text-lg font-semibold text-white">Projects</h1>
        </div>
      </header>

      <div className="min-h-screen flex items-center w-full p-4">
        <div className="rounded-xl border border-zinc-700 bg-zinc-800 w-full shadow-lg">
          <div className="p-4 border-b border-zinc-700 flex flex-wrap items-center justify-between gap-4">
            <div className="relative w-full md:w-64">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-500" />
              <input
                placeholder="Search Projects..."
                className="pl-9 bg-zinc-700 border-zinc-600 text-gray-300 focus:border-green-500 rounded"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
              />
            </div>
            <div className="flex gap-2">
              <button
                className={cn(
                  "flex items-center p-2 rounded-xl bg-zinc-700 border-zinc-600 text-gray-300 hover:bg-zinc-600 text-sm",
                  selectedOption === "all"
                    ? "cursor-not-allowed opacity-50"
                    : "",
                )}
                onClick={downloadCvs}
              >
                <div className="flex items-center gap-2">
                  <Download className="h-4 w-4" />
                  <span>CVs</span>
                </div>
              </button>
              <div className="flex items-center gap-2">
                <Dropdown
                  options={options}
                  functionOnChange={filterProjects}
                  client:load
                />
              </div>
            </div>
          </div>
          <div className="flex bg-zinc-800 border-zinc-700 overflow-auto">
            <table className="w-full text-left text-sm text-gray-500 overflow-x-auto">
              <thead className="bg-zinc-700">
                <tr className="border-b border-zinc-600 hover:bg-transparent">
                  <th
                    scope="col"
                    className="text-green-500 font-medium px-6 py-3"
                  >
                    TEAM CODE
                  </th>
                  <th
                    scope="col"
                    className="text-green-500 font-medium px-6 py-3 "
                  >
                    NAME
                  </th>
                  <th
                    scope="col"
                    className="text-green-500 font-medium text-center px-6 py-3"
                  >
                    LINK
                  </th>
                  <th
                    scope="col"
                    className="text-green-500 font-medium text-center px-6 py-3"
                  >
                    SUBMITTED AT
                  </th>
                  <th
                    scope="col"
                    className="text-green-500 font-medium text-center px-6 py-3"
                  >
                    THEME
                  </th>
                  <th
                    scope="col"
                    className="text-green-500 font-medium text-center px-6 py-3"
                  >
                    DESCRIPTION
                  </th>
                  <th
                    scope="col"
                    className="text-green-500 font-medium text-center px-6 py-3"
                  >
                    COMMITS
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-zinc-700">
                {filteredProjects.length > 0 ? (
                  currentProjects.map((project) => (
                    <tr
                      key={project.team_code}
                      className="hover:bg-zinc-700 transition-colors"
                    >
                      <td className="font-mono text-gray-300 px-6 py-4">
                        {project.team_code}
                      </td>
                      <td className="px-6 py-4 font-medium text-white">
                        {project.name}
                      </td>
                      <td className="px-6 py-4 text-center text-white">
                        <a href={project.link}>{project.link}</a>
                      </td>
                      <td className="px-6 py-4 text-gray-400 text-center">
                        {new Date(project.created_at).toLocaleTimeString([], {
                          hour: "2-digit",
                          minute: "2-digit",
                        })}
                      </td>
                      <td className="px-6 py-4 text-center font-medium text-white">
                        {project.theme}
                      </td>
                      <td className="px-6 py-4 text-center max-w-[200px] truncate">
                        {project.description ? project.description : "None"}
                      </td>
                      <td className="px-6 py-4 text-center font-medium text-white">
                        <button
                          onClick={() => CheckCommits(project.team_code)}
                          className="group focus:outline-none focus:ring-2 focus:ring-orange-500 focus:ring-offset-2 focus:ring-offset-zinc-800 rounded-full"
                          title="Check Commits"
                        >
                          <Badge className="bg-green-500/20 border-0 border-green-500/30">
                            <Check className="h-3.5 w-3.5 mr-1 text-green-500" />
                            <span className="text-green-500">
                              Check Commits
                            </span>
                          </Badge>
                        </button>
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr className="text-center">
                    <td colSpan="6" className="py-4 text-gray-400">
                      No Projects found matching your search.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
          {loadingCommits && (
            <InformationModal
              title="Loading Commits"
              content="Please wait while we fetch the commits."
              closeModal={() => setLoadingCommits(false)}
            />
          )}
          {resultCommits && (
            <InformationModal
              title="Commits"
              content={resultCommits}
              closeModal={() => setResultCommits("")}
            />
          )}
          <div className="p-4 border-t border-zinc-700 flex flex-wrap items-center justify-between gap-4 text-sm text-gray-400">
            <div>
              Showing {startIndex + 1}-
              {Math.min(endIndex, filteredProjects.length)} of{" "}
              {filteredProjects.length} projects
            </div>
            <div className="flex items-center gap-2">
              <button
                onClick={goToPreviousPage}
                disabled={currentPage === 1}
                className="flex items-center p-2 rounded-lg bg-zinc-700 border-zinc-600 text-gray-300 hover:bg-zinc-600 disabled:opacity-50"
              >
                <ChevronLeft className="h-4 w-4 mr-1" />
                Previous
              </button>

              <div className="flex gap-1">
                {getPageNumbers().map((pageNumber) => (
                  <button
                    key={pageNumber}
                    onClick={() => goToPage(pageNumber)}
                    className={`p-2 min-w-[2.5rem] border-zinc-600 rounded-lg 
                      ${
                        pageNumber === currentPage
                          ? "bg-green-500 hover:bg-green-600 text-white"
                          : "text-gray-300 hover:bg-zinc-700"
                      }`}
                  >
                    {pageNumber}
                  </button>
                ))}
              </div>

              <button
                onClick={goToNextPage}
                disabled={currentPage === totalPages}
                className="flex items-center p-2 rounded-lg bg-zinc-700 border-zinc-600 text-gray-300 hover:bg-zinc-600 disabled:opacity-50"
              >
                Next
                <ChevronRight className="h-4 w-4 ml-1" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
