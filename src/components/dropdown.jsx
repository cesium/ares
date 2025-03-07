import { useEffect } from "react";

export default function Dropdown({ options, functionOnChange }) {
  return (
    <select
      className="block w-full bg-zinc-700 border-zinc-600 text-gray-300 rounded-md focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm"
      onChange={(e) => functionOnChange(e.target.value)}
    >
      {options.map((option, index) => (
        <option key={index} value={option.value}>
          {option.label}
        </option>
      ))}
    </select>
  );
}
