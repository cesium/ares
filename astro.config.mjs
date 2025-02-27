import tailwind from "@astrojs/tailwind";
import icon from "astro-icon";
import { defineConfig } from "astro/config";
import react from "@astrojs/react";

import netlify from "@astrojs/netlify";

// https://astro.build/config
export default defineConfig({
  site: import.meta.env.PUBLIC_HOST_URL,
  integrations: [tailwind(), icon(), react()],
  output: "server",
  adapter: netlify(),
});
