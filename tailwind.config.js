/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx}",
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",

    // Or if using `src` directory:
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      backgroundImage: {
        hero: "url('/background.png')",
      },
      fontFamily: {
        terminal: ["Terminal"],
        alarm: ["Alarm Clock"],
        karrik: ["Karrik"],
      },
      colors: {
        primary: "#000000",
        secondary: "#00E600",
      },
    },
  },
  plugins: [],
};
