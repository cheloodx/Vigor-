# Testing SatConnect (React Native / Expo)

## Environment Setup

1. Navigate to `/home/ubuntu/repos/Vigor-/SatConnect`
2. Ensure `node_modules` exist (run `npm install` if not)
3. Start Expo web server: `npx expo start --web --port 8081`
4. Wait for bundle to complete (~5-10 seconds)
5. Open browser to `http://localhost:8081`

## Navigation Flow

1. **Onboarding**: Click "Sari peste" (Skip) in top-right to bypass
2. **Login**: Click "Mod Demo" button to enter demo mode (no real auth needed)
3. **Tab Navigation**: Bottom tabs are:
   - Acasa (Home) - 1st tab
   - Mesaje (Messages) - 2nd tab
   - **Locatie (Map)** - 3rd tab (MapScreen with satellite tracker)
   - eSIM - 4th tab
   - Planuri (Plans) - 5th tab
   - Profil (Profile) - 6th tab

## MapScreen Testing Checklist

### Visual Verification
- Title: "Satellite Tracker" with "Monitorizare in timp real" subtitle
- LIVE badge (green) in top-right, changes to OFF (red) when tracking disabled
- 3 signal overview cards: Sateliti vizibili (5), Semnal mediu (75%), Precizie GPS (±5m)
- Dark space background (#060E1A) with teal grid lines
- SAT VIEW badge top-right of map
- Coordinate label bottom-left: "45.5943° N, 24.2737° E"

### Animation Verification
- **Satellites**: 5 colored dots (teal, blue, purple, yellow, red) should be visibly moving in elliptical orbits. Wait 3-5 seconds and compare positions between screenshots to confirm movement
- **Coverage zones**: Semi-transparent pulsing colored areas (teal=strong, yellow=moderate, red=weak)
- **GPS marker**: Pulsing teal dot with expanding/fading ring
- **Stars**: 60 tiny white dots with twinkling opacity (subtle on web)

### Interactive Testing
- **Layer toggles** (below map): Sateliti, Acoperire, Istoric - each hides/shows respective elements
- **Tracking toggle**: "Opreste tracking" -> "Porneste tracking" (LIVE badge changes to OFF)
- **Satellite selection**: Tap satellite in list for subtle highlight (more visible on native iOS)
- **Share location**: Uses native Share API - NOT testable on web

### Satellite List Verification
- SAT-01 Iridium: LEO, 780 km, 92% (green bar)
- SAT-02 Globalstar: LEO, 1414 km, 78% (green bar)
- SAT-03 Starlink: LEO, 550 km, 95% (green bar)
- SAT-04 OneWeb: MEO, 1200 km, 65% (yellow bar)
- SAT-05 Telesat: LEO, 1000 km, 45% (red bar)

Signal bar colors: green (>75%), yellow (50-75%), red (<50%)

## Known Limitations on Expo Web

- **Share API**: Not available on web, only works on native iOS/Android
- **GPS**: Uses mock coordinates on web, real GPS only on device
- **Satellite selection highlight**: Very subtle on web, more visible on native
- **Animation smoothness**: React Native Animated with `useNativeDriver: true` may behave slightly differently on web vs native
- **Percentage-based styles**: Must use template literals with `as const` (e.g., `` `${x}%` as const ``) for TypeScript compatibility

## Dark Theme Colors
- Primary background: #0A1628 (deep navy)
- Space/map background: #060E1A (darker navy)
- Accent: #00D4AA (teal)
- Glass panels: rgba(255,255,255,0.05) with border rgba(255,255,255,0.08)
- Success: #00D4AA, Warning: #FBBF24, Error: #F87171

## Branch & PR
- Branch: `devin/1742248215-satconnect-satellite-app`
- PR: https://github.com/cheloodx/Vigor-/pull/7

## Devin Secrets Needed
- No secrets needed for basic Expo web testing (demo mode bypasses auth)
- For full backend testing: SUPABASE_URL, SUPABASE_ANON_KEY, STRIPE_SECRET_KEY, AIRALO_CLIENT_ID, AIRALO_CLIENT_SECRET
