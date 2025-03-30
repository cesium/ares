import { useState } from "react";
import FormsTemplate from "./forms/formsTemplate.jsx";
import TextInput from "~/components/forms/textInput.jsx";
import TextBox from "~/components/forms/textBox.jsx";
import Selector from "~/components/forms/selector.jsx";
import ConfirmationModal from "~/components/confirmationModal.jsx";
import InformationModal from "~/components/informationModal.jsx";
import Button from "./button.jsx";
import ErrorBox from "~/components/forms/errorBox.jsx";
import themes from "~/data/themes.json";

export default function ProjectDelivery() {
  const [responseErrors, setResponseErrors] = useState([]);
  const [loadingState, setLoadingState] = useState(false);
  const [showModal, setShowModal] = useState(false);
  const [showInfoModal, setShowInfoModal] = useState(false);

  async function submit(e) {
    e.preventDefault();
    closeModal();
    setLoadingState(true);
    const formData = new FormData(e.target);
    const response = await fetch("/api/projects/create", {
      method: "POST",
      body: formData,
    });

    const data = await response.json();

    if (!response.ok) {
      setResponseErrors(data.message.errors);
      setLoadingState(false);
    } else {
      setShowInfoModal(true);
      setLoadingState(false);
    }
  }

  function openModal() {
    setShowModal(true);
  }

  function closeModal() {
    setShowModal(false);
  }

  function goBack() {
    closeInfoModal();
    window.location.href = "/";
  }

  function closeInfoModal() {
    setShowInfoModal(false);
  }

  return (
    <FormsTemplate
      title="Project Submission"
      description="To submit your project, please provide the following information."
    >
      <form onSubmit={submit} className="space-y-5">
        <TextInput
          type="text"
          param="team_code"
          title="Team code"
          help="The code emailed to you when you registered your team."
          placeholder="Enter your team code"
        />
        <TextInput
          type="text"
          param="name"
          title="Project name"
          placeholder="Insert your project name"
        />
        <TextInput
          type="link"
          param="link"
          title="Project link"
          placeholder="Insert your project repo link"
        />

        <Selector
          param="theme"
          title="Project Theme"
          options={themes.map((theme) => ({
            key: theme.company,
            value: `${theme.company}: ${theme.theme}`
          }))}
        />

        <TextBox
          param="description"
          title="Project description"
          help="Please provide a detailed description of your project."
          placeholder="Insert your project description"
        />

        {responseErrors.length > 0 && (
          <ErrorBox responseErrors={responseErrors} />
        )}

        <Button
          loadingState={loadingState}
          placeholder="Submit"
          onClick={openModal}
        />
        {showModal && (
          <ConfirmationModal
            title="Are you sure you want to submit?"
            content="This is a unique submission and cannot be undone."
            closeModal={closeModal}
          />
        )}
        {showInfoModal && (
          <InformationModal
            title="Project submitted!"
            content={
              <>
                Your project has been successfully submitted!
                Thank you for participating in <span class="text-primary">Hackathon Bugsbyte</span>. Good luck!
              </>
            }
            closeModal={goBack}
          />
        )}

      </form>
    </FormsTemplate>
  );
}
