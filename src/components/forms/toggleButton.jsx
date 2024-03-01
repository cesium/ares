export default function ToggleButton({ param, title }) {
  return (
    <label className="inline-flex items-center mb-5 cursor-pointer">
      <span className="mr-3 text-sm font-medium text-white dark:text-gray-300">
        {title}
      </span>
      <input name={param} type="checkbox" className="sr-only peer" />
      <div className="relative w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary dark:peer-focus:ring-primary rounded-full peer dark:bg-primary peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:w-5 after:h-5 after:transition-all dark:border-gray-600 peer-checked:bg-primary"></div>
    </label>
  );
}
