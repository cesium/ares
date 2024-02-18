import { defineCollection, z } from "astro:content";

const showcase = defineCollection({
  type: "data",
  schema: ({ image }) =>
    z.array(
      image()
    ),
});

export const collections = {
  showcase
};
