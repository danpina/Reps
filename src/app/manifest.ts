import type { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "Reps — learn to talk to anyone",
    short_name: "Reps",
    description:
      "Talking to people is a skill, not a personality. Reps teaches you one idea at a time, gives you somewhere to practise it, and keeps a record of every real conversation you use it on.",
    // Opens on the dashboard rather than the marketing page, since anyone who
    // installed this is already signed in.
    start_url: "/today",
    scope: "/",
    display: "standalone",
    orientation: "portrait",
    background_color: "#101214",
    theme_color: "#101214",
    categories: ["lifestyle", "education", "productivity"],
    icons: [
      { src: "/icon-192.png", sizes: "192x192", type: "image/png", purpose: "any" },
      { src: "/icon-512.png", sizes: "512x512", type: "image/png", purpose: "any" },
      {
        src: "/icon-maskable-192.png",
        sizes: "192x192",
        type: "image/png",
        purpose: "maskable",
      },
      {
        src: "/icon-maskable-512.png",
        sizes: "512x512",
        type: "image/png",
        purpose: "maskable",
      },
    ],
    shortcuts: [
      {
        name: "Log a rep",
        short_name: "Log",
        // The reason the app is installed at all: logging happens on the move,
        // minutes after a real conversation.
        url: "/log",
      },
      { name: "Field log", short_name: "Log book", url: "/field-log" },
    ],
  };
}
