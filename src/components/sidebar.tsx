"use client"

import { useEffect, useRef, useState } from "react"
import { X } from "lucide-react"

interface SidebarItem {
  name: string
  url: string
}

interface SidebarProps {
  items?: SidebarItem[]
}

export default function Sidebar({ items = [] }: SidebarProps) {
  const [isOpen, setIsOpen] = useState(false)
  const sidebarRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (sidebarRef.current && !sidebarRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }

    document.addEventListener("mousedown", handleClickOutside)
    return () => document.removeEventListener("mousedown", handleClickOutside)
  }, [])

  async function onSignOut() {
    const response = await fetch("/api/admin", { method: "DELETE", credentials: "include" })
    if (!response.ok) {
      console.error("Failed to sign out")
    } else {
      window.location.href = "/"
    }
  }

  return (
    <>
      {/* Overlay */}
      {isOpen && (
        <div className="fixed inset-0 bg-zinc-950 bg-opacity-50 z-30 sm:hidden" onClick={() => setIsOpen(false)} />
      )}

      {/* Toggle Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        type="button"
        className="inline-flex items-center p-2 mt-2 ms-3 text-sm text-gray-500 rounded-lg sm:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200"
      >
        <span className="sr-only">Open sidebar</span>
        <svg
          className="w-6 h-6"
          aria-hidden="true"
          fill="currentColor"
          viewBox="0 0 20 20"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            clipRule="evenodd"
            fillRule="evenodd"
            d="M2 4.75A.75.75 0 012.75 4h14.5a.75.75 0 010 1.5H2.75A.75.75 0 012 4.75zm0 10.5a.75.75 0 01.75-.75h7.5a.75.75 0 010 1.5h-7.5a.75.75 0 01-.75-.75zM2 10a.75.75 0 01.75-.75h14.5a.75.75 0 010 1.5H2.75A.75.75 0 012 10z"
          ></path>
        </svg>
      </button>

      {/* Sidebar */}
      <aside
        ref={sidebarRef}
        className={`fixed top-0 left-0 z-40 w-64 h-screen transition-transform ${
          isOpen ? "translate-x-0" : "-translate-x-full"
        } sm:translate-x-0`}
        aria-label="Sidebar"
      >
        <div className="flex flex-col justify-between h-full px-3 py-4 overflow-y-auto bg-zinc-950">
          <div>
            <div className="flex items-center justify-between pb-4">
              <span className="text-2xl font-bold text-green-500">BugsByte</span>
              <button
                onClick={() => setIsOpen(false)}
                className="p-1 rounded-lg text-gray-400 hover:bg-zinc-800 hover:text-white sm:hidden"
              >
                <X className="h-6 w-6" />
                <span className="sr-only">Close sidebar</span>
              </button>
            </div>
            <ul className="space-y-2 mt-6">
              {items.map((item, index) => (
                <li key={index} className="bg-green-500/10 text-green-500 rounded-lg hover:gd-green-500/20">
                  <a
                    href={item.url}
                    className="flex items-center p-2 rounded-lg hover:bg-green-900 hover:text-green-500"
                    onClick={() => {
                      if (window.innerWidth < 640) {
                        // sm breakpoint
                        setIsOpen(false)
                      }
                    }}
                  >
                    <span className="ms-3">{item.name}</span>
                  </a>
                </li>
              ))}
            </ul>
          </div>
          <button
            onClick={onSignOut}
            className="flex items-center p-2 w-full text-gray-400 hover:text-white hover:bg-zinc-700 rounded-lg"
          >
            <svg
              className="shrink-0 w-5 h-5 transition duration-75 group-hover:text-red-500"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 18 16"
            >
              <path
                stroke="currentColor"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M1 8h11m0 0L8 4m4 4-4 4m4-11h3a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-3"
              />
            </svg>
            <span className="ms-3 whitespace-nowrap">Log Out</span>
          </button>
        </div>
      </aside>
    </>
  )
}
