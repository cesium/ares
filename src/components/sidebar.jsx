"use client"

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
      <button data-drawer-target="logo-sidebar" data-drawer-toggle="logo-sidebar" aria-controls="logo-sidebar" type="button" className="inline-flex items-center p-2 mt-2 ms-3 text-sm text-gray-500 rounded-lg sm:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 ">
          <span className="sr-only">Open sidebar</span>
          <svg className="w-6 h-6" aria-hidden="true" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
            <path clipRule="evenodd" fillRule="evenodd" d="M2 4.75A.75.75 0 012.75 4h14.5a.75.75 0 010 1.5H2.75A.75.75 0 012 4.75zm0 10.5a.75.75 0 01.75-.75h7.5a.75.75 0 010 1.5h-7.5a.75.75 0 01-.75-.75zM2 10a.75.75 0 01.75-.75h14.5a.75.75 0 010 1.5H2.75A.75.75 0 012 10z"></path>
          </svg>
      </button>

      <aside id="logo-sidebar" className="fixed top-0 left-0 z-40 w-64 h-screen transition-transform -translate-x-full sm:translate-x-0 items-" aria-label="Sidebar">
          <div className="flex flex-col justify-between h-full px-3 py-4 overflow-y-auto bg-zinc-900">
            <div>
               <div className="flex items-center justify-center pb-4">
                   <span className="text-xl font-bold whitespace-nowrap text-green-500">BugsByte</span>
               </div>
               <ul className="space-y-2 font-medium">
                   {items.map((item, index) => (
                        <li key={index} className="shadow-lg shadow-green-900 bg-zinc-800 rounded">
                            <a href={item.url} className="flex items-center p-2 text-white rounded-lg hover:bg-green-900 group">
                                 <span className="ms-3">{item.name}</span>
                            </a>
                        </li>    
                   ))}
               </ul>
            </div>
            <button onClick={onSignOut} className="flex items-center p-2 text-white rounded-lg bg-zinc-800 hover:bg-red-800 group">
                  <svg className="shrink-0 w-5 h-5 text-gray-500 transition duration-75 group-hover:text-red-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 18 16">
                     <path stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M1 8h11m0 0L8 4m4 4-4 4m4-11h3a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-3"/>
                  </svg>
                  <span className="ms-3 whitespace-nowrap">Log Out</span>
            </button>
          </div>
      </aside>
   </>
)
}

