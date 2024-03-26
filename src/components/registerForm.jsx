import TextInput from "~/components/forms/textInput.jsx";
import NumberInput from "~/components/forms/numberInput.jsx";
import Selector from "~/components/forms/selector.jsx";
import TextBox from "~/components/forms/textBox.jsx";
import FileUpload from "~/components/forms/fileUpload.jsx";
import ToggleButton from "~/components/forms/toggleButton.jsx";
import { useState } from "react";

import universities from "~/data/institutes.json";

export default function Form() {
  const [responseErrors, setResponseErrors] = useState("");

  async function submit(e) {
    e.preventDefault();
    const formData = new FormData(e.target);
    const response = await fetch("/api/register", {
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

  return (
    <div className="mx-auto max-w-7xl px-4 pb-24 sm:px-6 lg:px-8">
      <div className="mx-auto max-w-3xl">
        <div className="mt-10 mb-10">
          <h2 className="font-semibold tracking-wide text-3xl leading-7 text-white">
            Personal Information
          </h2>
          <p className="mt-1 max-w-2xl text-xl leading-6 text-white">
            Use a permanent address where you can receive mail.
          </p>
        </div>

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
                      fill-rule="evenodd"
                      d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.28 7.22a.75.75 0 00-1.06 1.06L8.94 10l-1.72 1.72a.75.75 0 101.06 1.06L10 11.06l1.72 1.72a.75.75 0 101.06-1.06L11.06 10l1.72-1.72a.75.75 0 00-1.06-1.06L10 8.94 8.28 7.22z"
                      clip-rule="evenodd"
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
                      {responseErrors.map((error) => (
                        <li>{error}</li>
                      ))}
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          )}
          <div className="flex items-center mb-5">
            <div className="flex items-center h-5">
              <input id="terms" type="checkbox" value="" class="w-4 h-4 border border-gray-300 text-primary rounded bg-gray-50 focus:ring-3 focus:ring-primary" required />
            </div>
            <label htmlFor="terms" class="ms-2 text-sm font-medium text-white ">I agree with the <a href="/docs/regulation.pdf" class="text-primary hover:underline">event regulations</a></label>
          </div>
          <button className="text-white bg-primary hover:bg-primary focus:ring-4 focus:outline-none focus:ring-primary font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center">
            Send
          </button>
        </form>
      </div>
    </div>
  );
}
