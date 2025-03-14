export default function TextInput({
  param,
  type,
  title,
  placeholder,
  help = "",
}) {
  return (
    <div>
      <label
        htmlFor={param}
        className="block mb-2 text-sm font-medium text-white dark:text-white"
      >
        <div className="flex flex-col">
          {title}
          {help && <span className="text-xs text-gray-400">{help}</span>}
        </div>
      </label>
      <input
        type={type}
        id={param}
        name={param}
        className={
          "bg-gray-50 border border-white text-gray-900 text-sm rounded-lg focus:ring-primary focus:border-green-500 block w-full p-2.5"
        }
        placeholder={placeholder}
        required
      />
    </div>
  );
}
