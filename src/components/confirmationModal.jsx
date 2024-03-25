export default function ConfirmationModal({ placeHolder, closeModal }) {

  return (
    <div className="fixed top-0 bottom-0 left-0 right-0 bg-gray-800 bg-opacity-75 flex justify-center items-center">
      <div className="relative bg-black rounded-lg shadow-lg">
        <div className="p-4 md:p-5 text-center">
          <svg
            className="mx-auto mb-4 text-gray-400 w-12 h-12"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 20 20"
          >
            <path
              stroke="currentColor"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              d="M10 11V6m0 8h.01M19 10a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
            />
          </svg>
          <h3 className="mb-5 text-lg font-normal text-white">
            {placeHolder}
          </h3>
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
