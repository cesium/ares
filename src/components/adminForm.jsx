import { useState } from "react";
import ErrorBox from "~/components/forms/errorBox.jsx";

export default function AdminForm() {
  const [error, setError] = useState("");

  async function handleSubmit(e) {
    e.preventDefault();
    const formData = new FormData(e.target);
    const response = await fetch("/api/admin", {
      method: "POST",
      body: formData,
    });

    const data = await response.json();

    if (!response.ok) {
      setError(data.message.error);
    } else {
      window.location.href = "/";
    }
  }

  return (
    <div className="relative flex min-h-screen items-center justify-center">
      <div className="w-full max-w-md bg-zinc-500 backdrop-blur-sm rounded-lg shadow-xl overflow-hidden">
        <div className="px-6 py-4">
          <h2 className="text-2xl font-bold text-center text-zinc-900">
            Bugsbyte BackOffice 🪲
          </h2>
        </div>
        <div className="pb-4 px-4">
          <form className="space-y-4" onSubmit={handleSubmit}>
            <div className="space-y-2">
              <label 
                htmlFor="password" 
                className="block text-sm font-medium text-zinc-900"
              >
                Password
              </label>
              <input
                id="password"
                name="password"
                type="password"
                placeholder="Enter your password"
                required
                className="w-full px-3 py-2 border border-gray-300 rounded-md 
                           focus:outline-none focus:ring-2 focus:ring-gray-400 
                           focus:border-transparent transition-colors text-black"
              />
              {error.length > 0 && (
                <ErrorBox responseErrors={error}/>
              )}
            </div>
            <button className="w-full rounded-lg bg-primary py-2" type="submit">
              Login
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};