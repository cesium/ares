export default function Checkbox({ param, placeholder }) {
  return (
    <fieldset>
      <legend className="sr-only">{placeholder}</legend>
      <div className="sm:grid sm:grid-cols-3 sm:gap-4 sm:py-6">
        <div className="text-sm font-medium leading-6 text-gray-900" aria-hidden="true">{placeholder}</div>
        <div className="mt-4 sm:col-span-2 sm:mt-0">
          <div className="max-w-lg space-y-6">
            <div className="relative flex gap-x-3">
              <div className="flex h-6 items-center">
                <input id={param} name={param} type="checkbox" className="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-600" />
              </div>
              <div className="text-sm leading-6">
                <p className="text-gray-600">{desc}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </fieldset>
  );
}
