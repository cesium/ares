import { useState } from "react";
import TextInput from "~/components/forms/textInput.jsx";
import ConfirmationModal from "~/components/confirmationModal.jsx";
import InformationModal from "~/components/informationModal.jsx";
import Button from "~/components/button.jsx";

export default function CreateTeam() {
  const [responseErrors, setResponseErrors] = useState("");
  const [showConfirmationModal, setShowConfirmationModal] = useState(false);
  const [showInformationModal, setShowInformationModal] = useState(false);
  const [loadingState, setLoadingState] = useState(false);

  async function submit(e) {
    e.preventDefault();
    closeConfirmationModal();
    setLoadingState(true);
    const formData = new FormData(e.target);
    const response = await fetch("/api/teams/create", {
      method: "POST",
      body: formData,
    });

    const data = await response.json();
    if (!response.ok) {
      setResponseErrors(data.message.errors);
      setLoadingState(false);
    } else {
      openInformationModal();
    }
  }

  function goBack() {
    closeInformationModal();
    window.location.href = "/";
  }

  function openConfirmationModal() {
    setShowConfirmationModal(true);
  }

  function closeConfirmationModal() {
    setShowConfirmationModal(false);
  }

  function openInformationModal() {
    setShowInformationModal(true);
  }

  function closeInformationModal() {
    setShowInformationModal(false);
  }

  return (
    <div className="mx-auto max-w-7xl px-4 sm:px-0 pb-24">
      <div className="mx-auto max-w-3xl">
        <form onSubmit={submit} className="space-y-5">
          <TextInput
            type="text"
            param="name"
            title="Team name"
            placeholder="Enter your new team name"
          />

          <TextInput
            type="email"
            param="email"
            title="Your email"
            placeholder="Enter the email you used to register"
          />

          <TextInput
            type="text"
            param="confirmation"
            title="Confirmation code"
            placeholder="Enter your confirmation code"
            help="The code emailed to you when you registered"
          />

          {responseErrors.length > 0 && (
            <div className="rounded-md bg-red-50 p-4">
              <div className="flex">
                <div className="flex-shrink-0">
                  <svg
                    className="h-5 w-5 text-red-400"
                    viewBox="0 0 20 20"
                    fill="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      fillRule="evenodd"
                      d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.28 7.22a.75.75 0 00-1.06 1.06L8.94 10l-1.72 1.72a.75.75 0 101.06 1.06L10 11.06l1.72 1.72a.75.75 0 101.06-1.06L11.06 10l1.72-1.72a.75.75 0 00-1.06-1.06L10 8.94 8.28 7.22z"
                      clipRule="evenodd"
                    />
                  </svg>
                </div>
                <div className="ml-3">
                  <h3 className="text-sm font-medium text-red-800">
                    There were {responseErrors.length} error(s) with your
                    submission
                  </h3>
                  <div className="mt-2 text-sm text-red-700">
                    <ul role="list" className="list-disc space-y-1 pl-5">
                      {responseErrors.map((error, index) => (
                        <li key={index}>{error}</li>
                      ))}
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          )}
          <Button
            loadingState={loadingState}
            placeholder="Create"
            onClick={openConfirmationModal}
          />
          {showConfirmationModal && (
            <ConfirmationModal
              title="Are you sure you want to create this team?"
              content={
                <>
                  The cost of the participation is 2€ per person in the team, to a maximum of 5 people. <br />
                  When your team is complete, go to the CeSIUM room (DI 1.04) to make the payment.
                </>
              }
              closeModal={closeConfirmationModal}
            />
          )}
          {showInformationModal && (
            <InformationModal
              title="Team created!"
              content={
                <>
                  Your team was successfully created! <br />
                  We sent you an email with the confirmation code related to your team.<br />
                  Share this code with your teammates so they can join the team.
                </>
              }
              closeModal={goBack}
            />
          )}
        </form>
      </div>
    </div>
  );
}
