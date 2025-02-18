import { CircleAlert } from "lucide-react";

export default function ConfirmationModal({ title, content, closeModal }) {
  return (
    <div className="fixed inset-0 bg-gray-800 bg-opacity-75 flex justify-center items-center">
      <div className="relative bg-black border-2 border-gray-500 rounded-lg shadow-lg">
        <div className="p-4 md:p-5 text-center">
          <CircleAlert className="mx-auto mb-4 text-white w-12 h-12" />
          <h3 className="mb-5 text-lg font-normal text-white">{title}</h3>
          <p className="text-white mb-5">{content}</p>
          <button
            className="text-white bg-red-600 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm inline-flex items-center px-5 py-2.5 text-center"
            type="submit"
          >
            Yes, I'm sure
          </button>
          <button
            onClick={closeModal}
            className="py-2.5 px-5 ms-3 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-primary"
            type="button"
          >
            No, cancel
          </button>
        </div>
      </div>
    </div>
  );
}
