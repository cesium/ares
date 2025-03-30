import { useState, useEffect } from "react";

export default function AdminForm() {
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    async function checkAuth() {
      const response = await fetch("/api/admin", {
        method: "GET",
        credentials: "include",
      });
      if (response.ok) {
        window.location.href = "/admin/teams";
      }
    }
    checkAuth();
  }, []);

  async function handleSubmit(e) {
    e.preventDefault();
    setIsLoading(true);
    setError("");

    try {
      const formData = new FormData(e.target);
      const response = await fetch("/api/admin", {
        method: "POST",
        body: formData,
      });

      const data = await response.json();

      if (!response.ok) {
        setError(data.message.error);
      } else {
        window.location.href = "/admin/teams"; // Redirect to dashboard
      }
    } catch (err) {
      setError("An unexpected error occurred. Please try again.");
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <div className="flex min-h-screen items-center justify-center mx-auto">
      <div className="w-full max-w-md bg-zinc-500/70 backdrop-blur-sm rounded-lg shadow-xl overflow-hidden">
        <div className="px-6 py-4">
          <h2 className="text-2xl font-bold text-center text-zinc-900">
            Bugsbyte BackOffice 🪲
          </h2>
        </div>
        <div className="pb-4 px-4">
          <form
            className="space-y-4"
            onSubmit={handleSubmit}
            encType="multipart/form-data"
          >
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
                disabled={isLoading}
                className="w-full px-3 py-2 border border-gray-300 rounded-md 
                           focus:outline-none focus:ring-2 focus:ring-gray-400 
                           focus:border-transparent transition-colors text-black"
              />
            </div>
            {error && (
              <div className="rounded-md bg-red-50 p-2">
                <div className="flex items-center">
                  <div className="flex-shrink-0">
                    <svg
                      className="h-5 w-5 text-red-400"
                      viewBox="0 0 20 20"
                      fill="currentColor"
                      aria-hidden="true"
                    >
                      <path
                        fillRule="evenodd"
                        d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.28 7.22a.75.75 0 00-1.06 1.06L8.94 10l-1.72 1.72a.75.75 0 101.06 1.06L10 11.06l1.72 1.72a.75.75 0 101.06-1.06L11.06 10l1.72-1.72a.75.75 0 00-1.06-1.06L10 8.94 8.28 7.22z"
                        clipRule="evenodd"
                      />
                    </svg>
                  </div>
                  <div className="ml-3 text-sm text-red-700 flex items-center">
                    <p>{error}</p>
                  </div>
                </div>
              </div>
            )}
            <button
              className="w-full rounded-lg bg-primary py-2 transition-colors
                         hover:bg-primary/90 disabled:opacity-50 disabled:cursor-not-allowed"
              type="submit"
              disabled={isLoading}
            >
              {isLoading ? "Loading..." : "Login"}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
