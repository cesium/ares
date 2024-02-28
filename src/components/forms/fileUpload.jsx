
export default function FileUpload({ param, title }) {
  return (
    <div>
      <label className="block mb-2 text-sm font-medium text-white" htmlFor={param}>{title}</label>
      <input id={param} type="file" name={param} required className="block w-full text-sm text-gray-900 rounded-lg cursor-pointer bg-gray-50 focus:outline-none" />
      <div className="mt-1 text-sm text-gray-400" id={param}>Upload your CV so that the companies at the event know who you are 👀</div>
    </div>
  );
}
