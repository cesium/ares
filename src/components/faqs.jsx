import { Disclosure } from "@headlessui/react";
import { PlayIcon } from "@heroicons/react/24/solid";
import faqs from "~/data/faqs.json";

export default function Faqs() {
  return (
    <div>
      <div className="mx-auto max-w-7xl px-6 pb-24 sm:pb-32 lg:px-8 lg:pb-40">
        <div className="mx-auto max-w-4xl">
          <h2 className="text-2xl font-bold leading-10 tracking-wide text-white">
            Frequently asked questions
          </h2>
          <p className="mt-6 text-justify text-xl leading-7 uppercase">
            Have a different question and can’t find the answer you’re looking
            for? Reach out to our support team by{" "}
            <a
              href="mailto:geral@bugsbyte.org"
              className="font-semibold text-indigo-400 hover:text-indigo-300"
            >
              sending us an email{" "}
            </a>
            and we’ll get back to you as soon as we can.
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
                            <PlayIcon
                              fill="#66B22E"
                              className="mt-2 mr-3 w-4 h-4 rotate-90"
                            />
                          ) : (
                            <PlayIcon
                              fill="#66B22E"
                              className="mt-2 mr-3 w-4 h-4"
                            />
                          )}
                        </div>
                        <span className="text-xl text-white font-semibold leading-7 uppercase">
                          {faq.question}
                        </span>
                        <span className="ml-6 flex h-7 items-center"></span>
                      </Disclosure.Button>
                    </dt>
                    <Disclosure.Panel as="dd" className="mt-2 pr-12">
                      <p className="font-sans text-base leading-7 text-white ml-7">
                        {faq.answer}
                      </p>
                    </Disclosure.Panel>
                  </>
                )}
              </Disclosure>
            ))}
          </dl>
        </div>
      </div>
    </div>
  );
}
