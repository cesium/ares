export default function InformationModal({ title, content, closeModal }) {
  return (
    <div className="fixed inset-0 bg-gray-800 bg-opacity-75 flex justify-center items-center">
      <div className="relative bg-black border-2 border-gray-500 rounded-lg shadow-lg">
        <div className="p-4 md:p-5 text-center">
          <div className="flex justify-center mb-4">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-circle-check-big text-center text-green-500 h-12 w-12">
              <path d="M21.801 10A10 10 0 1 1 17 3.335"/>
              <path d="m9 11 3 3L22 4"/>
            </svg>
          </div>
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