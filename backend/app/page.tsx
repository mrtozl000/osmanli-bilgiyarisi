export default function Home() {
  return (
    <main style={{ padding: 40, fontFamily: "system-ui, sans-serif" }}>
      <h1>Osmanlı Bilgi Yarışı API</h1>
      <p>API is running. This service is consumed by the iOS app.</p>
      <ul>
        <li><code>POST /api/auth/apple</code> — Sign in with Apple</li>
        <li><code>GET /api/user/me</code> — Current user (requires session)</li>
        <li><code>POST /api/revenuecat/webhook</code> — RevenueCat events</li>
      </ul>
    </main>
  );
}
