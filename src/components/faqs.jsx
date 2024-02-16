import { Disclosure } from '@headlessui/react'
import { PlayIcon } from '@heroicons/react/24/solid'
const faqs = [
  {
    question:
      "I'm not a student from Universidade do Minho, can I still participate in the event?",
    answer:
      "Yes, all higher education students over 18 can participate in the event.",
  },
  {
    question: "Is it free to participate in the BugsByte Hackathon?",
    answer: "Yes, the event is completely free.",
  },
  {
    question: "Do I need to register to be able to participate in the event?",
    answer:
      "Yes, it is necessary to register to be able to participate in the event. Very soon we'll make a link available on our website to do so.",
  },
  {
    question: "Do I need to register as a team?",
    answer:
      "No, only individual registration is required. Once registered, you can form a team with other participants at your convenience.",
  },
  {
    question: "How many people can a team contain?",
    answer: "The sizes of the teams may vary between 2 to 5 elements.",
  },
  {
    question: "Can I leave the space of the event during the weekend?",
    answer:
      "Yes, you're completely free to enter and exit the premisses of the event during the weekend.",
  },
  {
    question: "Which technology/tools are we gonna work with?",
    answer:
      "You're going to be totally free to choose the stack you'll work on.",
  },
  {
    question: "Where am I going to sleep?",
    answer:
      "If you intend to sleep during the event, we will have a dedicated place for you to rest. Only bring what you find essential such as pillows, sleeping bags, blankets, etc.",
  },
  {
    question: "What am I going to eat during the event?",
    answer: "All food is provided by the BugsByte organization.",
  },
];

export default function Faqs() {
  return (
    <div>
      <div className="mx-auto max-w-7xl px-6 pb-24 sm:pb-32 lg:px-8 lg:pb-40">
        <div className="mx-auto max-w-4xl">
          <h2 className="text-2xl font-bold leading-10 tracking-wide text-white">Frequently asked questions</h2>
          <p className="mt-6 text-justify text-xl leading-7">
            Have a different question and can’t find the answer you’re looking for?
            Reach out to our support team by <a
              href="mailto:geral@bugsbyte.org"
              className="font-semibold text-indigo-400 hover:text-indigo-300"
              >sending us an email </a
            >and we’ll get back to you as soon as we can.
          </p>
        </div>
        <div className="mx-auto max-w-4xl divide-y">
          <dl className="mt-10 space-y-6 divide-y divide-white">
            {faqs.map((faq) => (
              <Disclosure as="div" key={faq.question} className="pt-6">
                {({ open }) => (
                  <>
                    <dt>
                      <Disclosure.Button className="flex w-full items-start justify-start text-left text-white">
                        <div>
                          {open ? (
                            <PlayIcon fill="#66B22E" className="mt-2 mr-3 w-4 h-4 rotate-90" />
                          ) : (
                            <PlayIcon fill="#66B22E" className="mt-2 mr-3 w-4 h-4" />
                          )}
                        </div>
                        <span className="text-xl text-white font-semibold leading-7">{faq.question}</span>
                        <span className="ml-6 flex h-7 items-center">
                        </span>
                      </Disclosure.Button>
                    </dt>
                    <Disclosure.Panel as="dd" className="mt-2 pr-12">
                      <p className="font-sans text-base leading-7 text-white ml-7">{faq.answer}</p>
                    </Disclosure.Panel>
                  </>
                )}
              </Disclosure>
            ))}
          </dl>
        </div>
      </div>
    </div>
  )
}
