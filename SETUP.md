# Osmanlı Bilgi Yarışı — Setup Guide

This walks through everything you need to do in external dashboards and on your
own machine to get **Sign in with Apple** + **RevenueCat subscriptions** fully
working. The code is already in place; these are the manual steps only you can do.

The stack:

- **iOS app** — Swift/SwiftUI, Sign in with Apple, RevenueCat
- **Backend** — Next.js on Vercel, Prisma, Neon Postgres
- **Subscriptions** — RevenueCat (free up to $2.5k monthly tracked revenue)
- **Auth** — Sign in with Apple → our backend issues a session JWT

Everything listed below is free, except Apple's $99/year developer membership.

---

## 1. Apple Developer Portal

Go to https://developer.apple.com/account and sign in.

### 1a. Enable Sign in with Apple on your App ID

1. Identifiers → find `com.osmanli.bilgiyarisi` (or create it if missing).
2. Scroll to **Sign in with Apple** → check the box.
3. Save.

### 1b. Create a Sign in with Apple Key (only needed if you later do web/server flows)

For an iOS-only app using the native `SignInWithAppleButton`, you do **not** strictly
need a separate key — verification on the backend works off Apple's public JWKS
automatically. Skip this section for now unless you later add a web sign-in flow.

### 1c. Record these values

You'll need them later:

- **Team ID** — top-right of the developer portal (10 characters)
- **Bundle ID** — `com.osmanli.bilgiyarisi`

---

## 2. App Store Connect — Subscription product

Go to https://appstoreconnect.apple.com.

1. **My Apps → (your app) → Monetization → Subscriptions**.
2. Create a **Subscription Group** (e.g. "Premium"). Group name shown to users.
3. Add a subscription inside the group:
   - **Reference Name**: "Premium Monthly" (internal)
   - **Product ID**: `com.osmanli.bilgiyarisi.premium.monthly` — **write this down**
   - **Duration**: 1 Month
   - **Price**: e.g. ₺19.99 (or pick a price tier)
4. Fill required metadata (display name, description) and save.
5. Complete the **Paid Applications Agreement** in **Agreements, Tax, and Banking**
   if you haven't. Without this, your app cannot sell subscriptions.

You can add an **annual** subscription later inside the same group if you want
to offer a yearly discount.

---

## 3. RevenueCat

Go to https://app.revenuecat.com and sign up (free).

### 3a. Create a Project and App

1. New Project → name it "Osmanlı Bilgi Yarışı".
2. **Apps → + New App → App Store**.
3. App Bundle ID: `com.osmanli.bilgiyarisi`.
4. Upload an **App Store Connect In-App Purchase Key** (Users and Access → Integrations → In-App Purchase → `+` → download `.p8`, note the Key ID and Issuer ID, paste into RevenueCat). This is how RC validates receipts against Apple.

### 3b. Create the Entitlement

1. **Entitlements → + New**. ID: `premium`. (The iOS code looks for exactly this string.)
2. Attach products once they appear (see next step).

### 3c. Import your product

1. **Products → + New → App Store**.
2. Product identifier: `com.osmanli.bilgiyarisi.premium.monthly` (must match App Store Connect exactly).
3. Attach it to the `premium` entitlement.

### 3d. Create the Offering

1. **Offerings → + New**. Identifier: `default`.
2. Add a **Package** → choose "Monthly" → attach your monthly product.
3. Mark this offering as **Current**.

### 3e. Get the iOS SDK key

1. **Project settings → API keys → Apple App Store**. Copy the **public SDK key** (starts with `appl_...`).
2. Paste it into `Sources/Info.plist` as the value of `REVENUECAT_API_KEY`, replacing `REPLACE_ME_REVENUECAT_IOS_SDK_KEY`.

### 3f. Configure the webhook

1. **Project settings → Integrations → Webhooks → + Add**.
2. URL: `https://<your-vercel-domain>/api/revenuecat/webhook` (fill this in after deploying, see step 5).
3. Authorization header: pick a long random string (e.g. `openssl rand -hex 32`). Save this as `REVENUECAT_WEBHOOK_SECRET` in Vercel env vars — the backend expects it in the form `Bearer <secret>` so configure the header value exactly as `Bearer <your-secret>`.
4. Send a test event — check Vercel logs to confirm it arrives with status 200.

---

## 4. Neon Postgres

Go to https://console.neon.tech and sign up (free).

1. **New Project → Create**. Region: pick whatever is closest to your Vercel region.
2. After creation, go to **Dashboard → Connection string → Pooled connection**.
3. Copy the connection string. It looks like:
   `postgresql://user:pass@ep-xxx-pooler.region.aws.neon.tech/neondb?sslmode=require`
4. This is your `DATABASE_URL`.

Run migrations locally once:

```bash
cd backend
cp .env.example .env.local
# Paste DATABASE_URL, APPLE_BUNDLE_ID, SESSION_SECRET into .env.local
npm install
npx prisma migrate dev --name init
```

That creates the `User` and `SubscriptionEvent` tables.

---

## 5. Vercel

Go to https://vercel.com and sign up (free) with GitHub.

1. Push the `backend/` folder to a GitHub repo.
2. Vercel → **Add New → Project** → import that repo.
3. **Root directory**: `backend` (important — the backend is a subfolder).
4. Framework preset: Next.js (auto-detected).
5. Before the first deploy, add environment variables:

| Key | Value |
|-----|-------|
| `DATABASE_URL` | your Neon pooled connection string |
| `APPLE_BUNDLE_ID` | `com.osmanli.bilgiyarisi` |
| `SESSION_SECRET` | output of `openssl rand -hex 64` |
| `REVENUECAT_WEBHOOK_SECRET` | same secret you configured in RevenueCat (without `Bearer ` prefix) |

6. Deploy. You'll get a URL like `https://osmanli-bilgiyarisi.vercel.app`.
7. Go back to `Sources/Info.plist` in Xcode and set `API_BASE_URL` to that URL.
8. Go back to RevenueCat webhook config and paste the full URL
   `https://.../api/revenuecat/webhook`.

After deploy, run `prisma migrate deploy` from Vercel's build log (it runs
automatically via the `postinstall` script in `package.json`).

---

## 6. Xcode

1. Open `OsmanliBilgiYarisi.xcworkspace` (not `.xcodeproj` — use the workspace because we use CocoaPods).
2. Run `pod install` from the project folder if you haven't since updating the Podfile:

```bash
cd /Users/muratozel/Desktop/OsmanliBilgiYarisi
pod install
```

3. Regenerate the Xcode project from `project.yml` (if you use XcodeGen):

```bash
xcodegen generate
```

4. In Xcode, select the project → **Signing & Capabilities**:
   - Confirm **Sign in with Apple** is listed. If not, `+ Capability → Sign in with Apple`.
   - Ensure your Team is selected and provisioning profile is automatic.
5. Verify `Sources/Info.plist` has real values for `REVENUECAT_API_KEY` and `API_BASE_URL`.
6. Run on a **real device** (simulator Sign in with Apple is unreliable).

---

## 7. Test checklist

### Auth
- [ ] Tap "Sign in with Apple" on first launch → Apple sheet appears with your name + email.
- [ ] After approving, Neon shows a new row in `User` with your `appleSub`.
- [ ] Sign out from your AuthManager → sign back in → same `appleSub` is looked up, no duplicate row.

### Subscription
- [ ] Tap "Premium'a Geç" → paywall shows a real price from the App Store.
- [ ] Use a **Sandbox Apple ID** (Settings → App Store → Sandbox Account) to buy the subscription.
- [ ] RevenueCat dashboard → Customers → see the event.
- [ ] Vercel logs show a POST to `/api/revenuecat/webhook` with 200 response.
- [ ] Your user row in Neon shows `isPremium=true` and a `premiumExpiresAt` in the future.
- [ ] App level 6+ unlocks; interstitial ads don't show.

### Edge cases
- [ ] Delete the app, reinstall, sign in with Apple → subscription status restores via RevenueCat (no manual "Restore" needed, but verify "Geri Yükle" also works).
- [ ] Cancel in App Store settings → wait for EXPIRATION event (or force one from RC dashboard) → user drops back to free tier.

---

## 8. Before App Store submission

- [ ] Replace AdMob test IDs with your real production AdMob app ID + ad unit ID in `Sources/Info.plist` and `Sources/Utils/AdManager.swift`.
- [ ] Replace `REPLACE_ME_REVENUECAT_IOS_SDK_KEY` with the real key in `Sources/Info.plist`.
- [ ] Replace `https://your-vercel-app.vercel.app` with your real deployed URL.
- [ ] Write a **Privacy Policy** (required for Sign in with Apple + AdMob + subscriptions) and a **Terms of Service**. Host them (GitHub Pages works). Link them in App Store Connect.
- [ ] Privacy nutrition labels: declare email collection (Sign in with Apple), purchase history (subscriptions), and advertising data (AdMob).
- [ ] Test subscription purchase in TestFlight before going live.

---

## Troubleshooting

**`nonce_mismatch` from `/api/auth/apple`** — the raw nonce sent in the POST body and the hash in the JWT don't match. Check `prepareNonce()` is called inside the `request` closure of `SignInWithAppleButton` (not ahead of time) and that the same raw nonce is sent to the backend.

**`invalid_token` from `/api/auth/apple`** — most often `APPLE_BUNDLE_ID` in Vercel env vars doesn't exactly match the app's Bundle ID. Spaces, trailing newlines, or wrong project settings will all break verification.

**`REVENUECAT_API_KEY is missing from Info.plist`** printed on launch — you forgot to replace the placeholder in `Sources/Info.plist`.

**Webhook fires but user stays on free tier** — confirm `Purchases.shared.logIn(userId)` was called with our backend `User.id`, not Apple's `sub`. Check RevenueCat Customer dashboard — the `App User ID` there must match what your Neon `User.id` column stores.
