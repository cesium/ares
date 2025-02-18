import { CircleCheckBig } from "lucide-react";

export default function InformationModal({ title, content, closeModal }) {
  return (
    <div className="fixed inset-0 bg-gray-800 bg-opacity-75 flex justify-center items-center">
      <div className="relative bg-black border-2 border-gray-500 rounded-lg shadow-lg">
        <div className="p-4 md:p-5 text-center">
          <CircleCheckBig className="mx-auto mb-4 text-green-500 w-12 h-12" />
          <h3 className="mb-5 text-lg font-normal text-white">{title}</h3>
          <p className="text-white mb-5">{content}</p>
          <button
            onClick={closeModal}
            className="py-2.5 px-5 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-primary"
            type="button"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
}