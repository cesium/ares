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
            className="cursor-pointer rounded-lg bg-gray1 border border-gray2 shadow-sm hover:border-purple px-4 py-6 mt-10"
        >
            <div>
                {isOpen ? (
                    <FontAwesomeIcon
                        icon={faCaretDown}
                        className="text-secondary mr-2 w-[16px]"
                    />
                ) : (
                    <FontAwesomeIcon
                        icon={faCaretRight}
                        className="text-secondary mr-2 w-[16px]"
                    />
                )}
                <span className="text-white font-semibold">{faq.question}</span>
            </div>
            {isOpen && <div className="text-white mt-2 text-2xl">{faq.answer}</div>}
        </div>
    );
}