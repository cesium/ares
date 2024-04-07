import TextInput from "~/components/forms/textInput.jsx";
import NumberInput from "~/components/forms/numberInput.jsx";
import Selector from "~/components/forms/selector.jsx";
import TextBox from "~/components/forms/textBox.jsx";
import FileUpload from "~/components/forms/fileUpload.jsx";
import ToggleButton from "~/components/forms/toggleButton.jsx";
import Button from "~/components/button.jsx";
import ConfirmationModal from "~/components/confirmationModal.jsx";
import FormsTemplate from "./forms/formsTemplate.jsx";
import ErrorBox from "~/components/forms/errorBox.jsx";
import { useState } from "react";

import universities from "~/data/institutes.json";

export default function Form() {
  const [responseErrors, setResponseErrors] = useState("");
  const [loadingState, setLoadingState] = useState(false);
  const [showModal, setShowModal] = useState(false);

  async function submit(e) {
    e.preventDefault();
    closeModal();
    setLoadingState(true);
    const formData = new FormData(e.target);
    const response = await fetch("/api/register", {
      method: "POST",
      body: formData,
    });

    const data = await response.json();
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
      title="Personal Information"
      description="Use a permanent address where you can receive mail."
    >
      <form
        encType="multipart/form-data"
        onSubmit={submit}
        className="space-y-5"
      >
        <TextInput
          type="text"
          param="name"
          title="Full name"
          placeholder="John Doe"
        />

        <TextInput
          type="email"
          param="email"
          title="Your email"
          placeholder="your-email@bugsbyte.org"
        />

        <TextInput
          type="tel"
          param="mobile"
          title="Phone number"
          placeholder="929 357 457"
        />

        <NumberInput param="age" title="Age" placeholder="18+" />

        <Selector
          param="university"
          title="University"
          options={universities}
        />

        <TextInput
          type="text"
          param="course"
          title="Course"
          placeholder="Engenharia Informática"
        />

        <ToggleButton title="Vegan" param="vegan" />

        <TextBox
          param="notes"
          title="Notes"
          placeholder="If you have any notes about food restrictions or anything else let us know"
        />

        <FileUpload param="cv" title="Upload CV" />

        {responseErrors.length > 0 && (
          <ErrorBox responseErrors={responseErrors} />
        )}

        <div className="flex items-center mb-5">
          <div className="flex items-center h-5">
            <input
              id="terms"
              type="checkbox"
              value=""
              className="w-4 h-4 border border-gray-300 text-primary rounded bg-gray-50 focus:ring-3 focus:ring-primary"
              required
            />
          </div>
          <label
            htmlFor="terms"
            className="ms-2 text-sm font-medium text-white "
          >
            I agree with the{" "}
            <a
              href="/docs/regulation.pdf"
              className="text-primary hover:underline"
            >
              event regulations
            </a>
          </label>
        </div>
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
