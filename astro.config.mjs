import tailwind from "@astrojs/tailwind";
import icon from "astro-icon";
import { defineConfig } from "astro/config";
import react from "@astrojs/react";

import netlify from "@astrojs/netlify";

// https://astro.build/config
export default defineConfig({
  site: import.meta.env.HOST_URL,
  integrations: [tailwind(), icon(), react()],
  output: "hybrid",
  adapter: netlify(),
});
