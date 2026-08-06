import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  allowedDevOrigins: ["v1.spiridus.ru"],
  experimental: {
    serverActions: {
      allowedOrigins: ["v1.spiridus.ru", "localhost:3000"],
    },
  },
};

export default nextConfig;
