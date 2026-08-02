import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Домовой",
  description: "Граф-система управления жизнью семьи",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ru">
      <body className="min-h-screen bg-white text-neutral-900 antialiased">
        {children}
      </body>
    </html>
  );
}
