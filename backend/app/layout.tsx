export const metadata = {
  title: "Osmanlı Bilgi Yarışı API",
  description: "Backend for the Osmanlı Bilgi Yarışı iOS app",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="tr">
      <body>{children}</body>
    </html>
  );
}
