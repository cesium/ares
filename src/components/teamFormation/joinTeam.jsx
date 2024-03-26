import TextInput from "~/components/forms/textInput.jsx";
import { useState } from "react";
import ConfirmationModal from "~/components/confirmationModal.jsx";

export default function JoinTeam() {
  const [responseErrors, setResponseErrors] = useState("");
  const [showModal, setShowModal] = useState(false);

  async function submit(e) {
    e.preventDefault();
    closeModal();
    const formData = new FormData(e.target);
    const response = await fetch("/api/teams/join", {
      method: "POST",
      body: formData,
    });

    const data = await response.json();
    if (!response.ok) {
      setResponseErrors(data.message.errors);
    } else {
      window.location.href = "/";
    }
  }

  function openModal() {
    setShowModal(true);
  }

  function closeModal() {
    setShowModal(false);
  }

  return (
    <div className="mx-auto max-w-7xl px-4 sm:px-0 pb-24">
      <div className="mx-auto max-w-3xl">
        <form
          onSubmit={submit}
          className="space-y-5"
        >
          <TextInput
            type="text"
            param="code"
            title="Team code"
            placeholder="Enter your team code"
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
          />

          {responseErrors.length > 0 && (
            <div class="rounded-md bg-red-50 p-4">
              <div class="flex">
                <div class="flex-shrink-0">
                  <svg
                    class="h-5 w-5 text-red-400"
                    viewBox="0 0 20 20"
                    fill="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.28 7.22a.75.75 0 00-1.06 1.06L8.94 10l-1.72 1.72a.75.75 0 101.06 1.06L10 11.06l1.72 1.72a.75.75 0 101.06-1.06L11.06 10l1.72-1.72a.75.75 0 00-1.06-1.06L10 8.94 8.28 7.22z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </div>
                <div class="ml-3">
                  <h3 class="text-sm font-medium text-red-800">
                    There were {responseErrors.length} error(s) with your
                    submission
                  </h3>
                  <div class="mt-2 text-sm text-red-700">
                    <ul role="list" class="list-disc space-y-1 pl-5">
                      {responseErrors.map((error) => (
                        <li>{error}</li>
                      ))}
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          )}
          <button
            className="text-white bg-primary hover:bg-primary focus:ring-4 focus:outline-none focus:ring-primary font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center"
            type="button"
            onClick={openModal}
          >
            Join
          </button>
          {showModal &&
            <ConfirmationModal
              placeHolder="Are you sure you want to join this team?"
              closeModal={closeModal}
            />
          }
        </form>
      </div>
    </div>
  );
}
