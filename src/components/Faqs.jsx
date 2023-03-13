import { useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faCaretRight, faCaretDown } from "@fortawesome/free-solid-svg-icons";

export default function Faqs({ faq }) {
  const [isOpen, setIsOpen] = useState(false);

  function toggleFaq() {
    setIsOpen((latest) => !latest);
  }

  return (
    <div
      onClick={toggleFaq}
      className="mt-10 cursor-pointer rounded-lg border px-4 py-6 shadow-sm hover:border-secondary"
    >
      <div>
        {isOpen ? (
          <FontAwesomeIcon
            icon={faCaretDown}
            className="mr-2 w-[16px] text-secondary"
          />
        ) : (
          <FontAwesomeIcon
            icon={faCaretRight}
            className="mr-2 w-[16px] text-secondary"
          />
        )}
        <span className="font-semibold text-white">{faq.question}</span>
      </div>
      {isOpen && (
        <div className="mt-2 text-base text-white xl:text-2xl">
          {faq.answer}
        </div>
      )}
    </div>
  );
}
