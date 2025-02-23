"use client"

import { Menu, X, LogOut } from "lucide-react"
import { useState } from "react"

export default function Sidebar({ items }) {
  const [isOpen, setIsOpen] = useState(false)

  async function onSignOut() {
    const response = await fetch("/api/admin", { method: "DELETE", credentials: "include" })
    if (!response.ok) {
      console.error("Failed to sign out")
    }
    else {
      window.location.href = "/"
    }
  }

  return (
    <>
      {/* Mobile Toggle Button */}
      <button
        type="button"
        onClick={() => setIsOpen(!isOpen)}
        className="fixed left-4 top-4 z-40 rounded-md bg-gray-800 p-2 text-white md:hidden"
        aria-label={isOpen ? "Close Menu" : "Open Menu"}
      >
        {isOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
      </button>

      {/* Sidebar */}
      <aside
        className={`${
          isOpen ? "translate-x-0" : "-translate-x-full"
        } fixed left-0 top-0 z-30 flex h-full w-64 flex-col bg-zinc-900 justify-between border-r border-zinc-800 transition-transform duration-300 ease-in-out md:translate-x-0`}
      >
        {/* Logo Area */}
        <div className="p-4">
          <h1 className="text-xl font-bold text-green-600">BackOffice</h1>
        </div>

        {/* Navigation Links */}
        <nav className="flex-1 space-y-1 px-2 py-4">
          {items.map((item) => (
            <a
              key={item.name}
              href={item.url}
              className="flex items-center rounded-lg px-4 py-2 text-gray-700 hover:bg-zinc-800 hover:text-white shadow-md shadow-green-900 cursor-pointer"
            >
              <span>{item.name}</span>
            </a>
          ))}
        </nav>

        {/* Sign Out Button */}
        <div className="p-4">
          <button
            onClick={onSignOut}
            className="flex w-full items-center justify-center gap-2 rounded-lg bg-red-800 p-2 text-white text-sm hover:bg-red-900"
          >
            <LogOut className="h-5 w-5" />
            <span>Sign Out</span>
          </button>
        </div>
      </aside>

      {/* Overlay for mobile */}
      {isOpen && (
        <div className="fixed inset-0 z-20 bg-black bg-opacity-50 md:hidden" onClick={() => setIsOpen(false)} />
      )}
    </>
  )
}

