import { useState } from "react";
import JoinTeam from "./teamFormation/joinTeam.jsx";
import CreateTeam from "./teamFormation/createTeam.jsx";
import FormsTemplate from "./forms/formsTemplate.jsx";

export default function TeamFormation() {
  const [selectedTab, setSelectedTab] = useState("create");

  return (
    <FormsTemplate
      title="Team Formation"
      description="If you have already registered, you can join a team or create a new one."
    >
      <div className="text-sm font-medium text-center text-white dark:text-gray-400 dark:border-gray-700 mb-4">
        <ul className="flex flex-wrap justify-center -mb-px">
          <li className="me-2">
            <button
              className={`inline-block p-4 border-b-2 border-transparent rounded-t-lg ${
                selectedTab === "create"
                  ? "text-secondary border-white"
                  : "text-white hover:text-secondary"
              }`}
              onClick={() => setSelectedTab("create")}
            >
              Create a team
            </button>
          </li>
          <li className="me-2">
            <button
              className={`inline-block p-4 border-b-2 border-transparent rounded-t-lg ${
                selectedTab === "join"
                  ? "text-secondary border-white"
                  : "text-white hover:text-secondary"
              }`}
              onClick={() => setSelectedTab("join")}
            >
              Join a team
            </button>
          </li>
        </ul>
      </div>
      {selectedTab === "join" ? <JoinTeam /> : <CreateTeam />}
    </FormsTemplate>
  );
}
