const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: ["./src/**/*.{astro,html,js,jsx,svelte,ts,tsx,vue}"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter Variable", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        primary: "var(--color-primary)",
        secondary: "var(--color-secondary)",
      },
      textColor: {
        default: "var(--color-text)",
        offset: "var(--color-text-offset)",
      },
      backgroundColor: {
        default: "var(--color-background)",
        offset: "var(--color-background-offset)",
      },
      borderColor: {
        default: "var(--color-border)",
      },
      keyframes: {
        squiggle: {
          "0%": { filter: "url('#squiggly-0')" },
          "25%": { filter: "url('#squiggly-1')" },
          "50%": { filter: "url('#squiggly-2')" },
          "75%": { filter: "url('#squiggly-3')" },
          "100%": { filter: "url('#squiggly-4')" },
        },
      },
      animation: {
        squiggle: "squiggle 0.45s ease-in-out infinite",
      },
    },
  },
  corePlugins: {
    fontSize: false,
  },
  plugins: [require("tailwindcss-fluid-type")],
};
