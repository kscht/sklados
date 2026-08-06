import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: { "@": "/src" },
  },
  server: {
    // локальная разработка: vite dev проксирует /db в SurrealDB
    proxy: {
      "/db": {
        target: process.env.SURREAL_HTTP ?? "http://127.0.0.1:8000",
        rewrite: (p) => p.replace(/^\/db/, ""),
      },
    },
  },
});
