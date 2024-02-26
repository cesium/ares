import TextInput from "~/components/forms/textInput.jsx"
import NumberInput from "~/components/forms/numberInput.jsx"
import Selector from "~/components/forms/selector.jsx"
import TextBox from "~/components/forms/textBox.jsx"
import FileUpload from "~/components/forms/fileUpload.jsx"
import ToggleButton from "~/components/forms/toggleButton.jsx"
import { useState } from "react";

import universities from "~/data/institutes.json";

export default function Form() {

  const [responseMessage, setResponseMessage] = useState("");

  async function submit(e) {
    e.preventDefault();
    const formData = new FormData(e.target);
    const response = await fetch("/api/register", {
      method: "POST",
      body: formData,
    });

    const data = await response.json();
    console.log(data)
    if (!response.ok) {
      setResponseMessage(data.message);
    }
    else {
      window.location.href = "/";
    }
  }

  return (
    <div className="mx-auto max-w-7xl px-4 pb-24 sm:px-6 lg:px-8">
      <div className="mx-auto max-w-3xl">
          <div className="mt-28 mb-10">
            <h2 className="font-semibold tracking-wide text-3xl leading-7 text-white">Personal Information</h2>
            <p className="mt-1 max-w-2xl text-xl leading-6 text-white">Use a permanent address where you can receive mail.</p>
          </div>
          
          <form onSubmit={submit} className="space-y-5">
            <TextInput type="text" param="name" title="Full name" placeholder="John Doe" />

            <TextInput type="email" param="email" title="Your email" placeholder="your-email@bugsbyte.org" error={responseMessage.email} />

            <TextInput type="tel" param="mobile" title="Phone number" placeholder="929 357 457" error={responseMessage.mobile} />

            <NumberInput param="age" title="Age" placeholder="18+" />

            <Selector param="university" title="University" options={universities} />

            <TextInput type="text" param="course" title="Course" placeholder="Engenharia Informática" />

            <ToggleButton title="Vegan" param="vegan" />

            <TextBox param="notes" title="Notes" placeholder="If you have any notes about food restrictions or anything else let us know" />

            <FileUpload param="cv" title="Upload CV" error={responseMessage.cv} />

            <button className="text-white bg-primary hover:bg-primary focus:ring-4 focus:outline-none focus:ring-primary font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center">
              Send
            </button>
          </form>
      </div>
    </div>
  );
}
