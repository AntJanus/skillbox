import "./globals.css";

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <header className="topbar">
          <a href="/">ProjectHub</a>
          <nav>
            <a href="/dashboard">Dashboard</a>
            <a href="/analytics">Analytics</a>
            <a href="/pricing">Pricing</a>
            <a href="/settings">Settings</a>
          </nav>
        </header>
        <main>{children}</main>
      </body>
    </html>
  );
}
