import { useState } from "react";
import FormsTemplate from "./forms/formsTemplate.jsx";
import TextInput from "~/components/forms/textInput.jsx";
import TextBox from "~/components/forms/textBox.jsx";
import ConfirmationModal from "~/components/confirmationModal.jsx";
import Button from "./button.jsx";
import ErrorBox from "~/components/forms/errorBox.jsx";

export default function ProjectDelivery() {
  const [responseErrors, setResponseErrors] = useState([]);
  const [loadingState, setLoadingState] = useState(false);
  const [showModal, setShowModal] = useState(false);

  async function submit(e) {
    console.log("submit");
    e.preventDefault();
    closeModal();
    setLoadingState(true);
    const formData = new FormData(e.target);
    const response = await fetch("/api/projects/create", {
      method: "POST",
      body: formData,
    });

    const data = await response.json();
    console.log(data);
    if (!response.ok) {
      setResponseErrors(data.message.errors);
      setLoadingState(false);
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
    <FormsTemplate
      title="Project Delivery"
      description="To deliver your project, please provide the following information."
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
            placeHolder="Are you sure you want to submit?"
            closeModal={closeModal}
          />
        )}
      </form>
    </FormsTemplate>
  );
}
