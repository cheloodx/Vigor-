# Testing EchilibruApp (React Native Expo)

## Overview
EchilibruApp is a React Native Expo (SDK 52) mobile app under `EchilibruApp/`. It uses TypeScript, React Navigation (bottom tabs + stack), and Context API for state management. All data is hardcoded (no backend).

## Setup & Running

```bash
cd EchilibruApp
npm install
npx expo start --web --port 8082
```

The app runs in Expo web mode at `http://localhost:8082`. No authentication or backend services are needed.

## Phone Resolution Testing
The app constrains to 430px max width on web (via `Platform.OS === 'web'` check in App.tsx). When testing in browser, the app appears centered with gray margins on either side.

## Key Test Flows

### 1. Recipes Tab (122 recipes)
- Click "Retete" in bottom tab bar
- Verify header shows "Retete Sanatoase"
- Category filters: Toate, Mic Dejun, Pranz, Cina, Desert
- FlatList is virtualized (initialNumToRender=8) so only ~8 cards render initially
- Click a recipe card to open RecipeDetail screen

### 2. Exercises Tab (85 exercises)
- Click "Exercitii" in bottom tab bar
- Verify header shows "Toate exercitiile (85)"
- Click an exercise card to open ExerciseDetail
- Video player: Click "Vezi Video" play button on the exercise image
- Video uses expo-av with placeholder Google sample videos

### 3. Home Screen CTA Buttons
- Scroll down on Home to find the green CTA section
- "Incepe Acum - £4.99/luna" → opens Subscription screen (modal)
- "Exploreaza Gratuit" → navigates to Recipes tab
- IMPORTANT: Screen names in navigation are 'Recipes', 'Exercises', 'Plans', 'Profile' — NOT the Romanian tab labels

### 4. Subscription Screen
- Comparison table: Basic (Gratuit) vs Premium (£4.99/luna)
- Basic gets checkmarks for: 10 retete (i=0), 10 exercitii (i=1), Calculator basic (i=3)
- Basic gets X for: Fara video (i=2), and all items i>=4
- The condition is `(i < 2 || i === 3)` — hardcoded to array order
- Subscribe button simulates purchase with 2s setTimeout + Alert

### 5. Profile & Settings
- Click "Profil" tab → shows Login prompt if not authenticated
- Login with any email/password (simulated)
- Settings tab has Apple Watch and Notifications toggles
- Both are Premium-gated: toggling without Premium shows upgrade alert

### 6. Shopping List Reset on Logout
- After login, go to Profile > Lista de Cumparaturi tab
- Verify 8 default items present
- Logout → Login again → verify defaults restored (not empty)

## Common Issues
- Navigation: Tab screen names differ from tabBarLabels. Use 'Recipes' not 'Retete', 'Exercises' not 'Exercitii', etc.
- The `removeClippedSubviews` FlatList prop might cause blank cards on some Android devices during fast scrolling
- Video URLs are Google sample videos, not real exercise content
- All auth/subscription state is in-memory and resets on app restart

## TypeScript Checks
```bash
cd EchilibruApp && npx tsc --noEmit
```

## No CI
This repo has no CI configured. Run TypeScript checks locally before pushing.

## Devin Secrets Needed
None — the app has no backend, no real auth, and no external API calls.
