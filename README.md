# SatConnect — Instant eSIM for 50+ Countries

> Travel smarter with instant eSIM activation. Choose from 50+ countries, affordable data plans, and secure payments. No physical SIM needed — activate in 2 minutes!

---

## 📋 Project Overview

| Field | Value |
|---|---|
| **App Name** | SatConnect |
| **Bundle ID** | `com.satconnect.esim` |
| **Category** | Travel (primary), Utilities (secondary) |
| **Age Rating** | 4+ |
| **Min iOS** | 16.0 |
| **Swift** | 5.0 |

---

## 🔄 Changes Made (Rebrand from VIGOR → SatConnect)

The following configuration changes were applied to transform the project:

### 1. `VIGOR/Info.plist`
- **Display Name**: Changed from `Kamasutra Guide` → `SatConnect`
- **Development Region**: Changed from `ro` → `en`
- **Added eSIM permissions**:
  - `com.apple.developer.networking.cellular-provider` — eSIM carrier entitlement
  - `CarrierDescriptors` — APN configuration
  - `NSLocalNetworkUsageDescription` — network access justification
  - `NSCameraUsageDescription` — QR code scanning for eSIM activation
  - `NSLocationWhenInUseUsageDescription` — region-based plan recommendations
- **Added Background Modes**: `fetch`, `remote-notification`

### 2. `VIGOR.xcodeproj/project.pbxproj`
- **Bundle Identifier**: `com.vigor.fitness` → `com.satconnect.esim` (both Debug & Release)
- **Display Name**: `VIGOR` → `SatConnect` (both Debug & Release)
- **App Category**: `public.app-category.healthcare-fitness` → `public.app-category.travel`

### 3. `AppStoreMetadata.plist` (NEW)
App Store Connect metadata reference file containing:
- Keywords, Subtitle, Promotional Text, Description
- Category, Age Rating, URLs

---

## 🚀 Next Steps for App Store Publication

### Required Before Submission

1. **Apple Developer Account**
   - Ensure you have an active Apple Developer Program membership ($99/year)
   - Set the `DEVELOPMENT_TEAM` in Xcode project settings to your Team ID

2. **App Icon**
   - Replace `VIGOR/Assets.xcassets/AppIcon.appiconset/` with SatConnect branded icons
   - Required sizes: 1024×1024 (App Store), plus all device sizes

3. **Code Signing**
   - Create an App ID for `com.satconnect.esim` in Apple Developer Portal
   - Generate provisioning profiles (Development & Distribution)
   - If using eSIM APIs, enable the **Carrier/eSIM entitlement** — this requires special Apple approval

4. **eSIM Entitlement (Critical)**
   - Apple requires explicit approval for `com.apple.developer.networking.cellular-provider`
   - Apply via: https://developer.apple.com/contact/request/esim/
   - This can take several weeks for approval

5. **Screenshots**
   - Prepare screenshots for all required device sizes:
     - iPhone 6.7" (iPhone 15 Pro Max)
     - iPhone 6.1" (iPhone 15 Pro)
     - iPad Pro 12.9" (if supporting iPad)

6. **Privacy Policy & Support URLs**
   - Set up live pages at the URLs listed in `AppStoreMetadata.plist`
   - Privacy policy is **mandatory** for App Store submission

7. **App Review Information**
   - Prepare demo credentials if the app has login
   - Write clear review notes explaining the eSIM functionality

### Optional Enhancements

- [ ] Add App Store preview video
- [ ] Localize metadata for target markets
- [ ] Set up In-App Purchases for data plans in App Store Connect
- [ ] Configure TestFlight for beta testing
- [ ] Set up App Analytics and crash reporting

---

## 🏗 Project Structure

```
VIGOR/
├── Info.plist                    # App configuration & permissions
├── VIGORApp.swift                # App entry point
├── Assets.xcassets/              # Images, colors, app icon
├── Models/                       # Data models
├── Utilities/                    # App state, components, theme
└── Views/                        # SwiftUI views
    ├── Main/                     # Dashboard, Profile, Discover, Tabs
    ├── Training/                 # Workout views
    ├── Nutrition/                # Nutrition tracking
    ├── Social/                   # Video calls
    ├── Community/                # Community features
    ├── Gamification/             # Rewards, store, unboxing
    └── Watch/                    # Apple Watch integration

VIGOR.xcodeproj/                  # Xcode project configuration
AppStoreMetadata.plist            # App Store Connect metadata reference
```

---

## ⚠️ Important Notes

- The Xcode project folder is still named `VIGOR` / `VIGOR.xcodeproj`. Renaming these folders requires updating all internal references in `project.pbxproj` and is **not recommended** unless doing a full project migration.
- The **Bundle ID** (`com.satconnect.esim`) and **Display Name** (`SatConnect`) are what users and the App Store see — the internal folder names don't matter.
- Ensure all Airalo eSIM API keys and endpoints are configured before submission.

---

© 2026 SatConnect. All rights reserved.
