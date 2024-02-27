export default function Selector({ param, title, options }) {
  return (
    <div>
      <label htmlFor={param} className="block mb-2 text-sm font-medium text-white dark:text-white">{title}</label>
      <select 
        id={param} 
        name={param}
        className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary focus:border-primary block w-full p-2.5"
      >
        <option value="">--Please choose an option--</option>
        {
          options.map(( option ) => (
            <option key={option}>{option}</option>
          ))
        }
      </select>
    </div>
  );
}
