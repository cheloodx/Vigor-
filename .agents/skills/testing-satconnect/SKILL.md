# Testing SatConnect (React Native / Expo)

## Quick Start

```bash
cd SatConnect
npm install
npx expo start --web --port 8082
```

Open http://localhost:8082 in Chrome.

## Login

No Supabase env vars configured = mock mode. Any email/password works (e.g. `test@test.com` / `test123`). The login button may be below the visible viewport on desktop — use Tab+Enter or scroll within the app frame.

## Navigating Tabs on Expo Web

The bottom tab bar (Home, Messages, Map, eSIM, Plans, Profile) may be below the visible viewport on desktop browsers. Workaround:

1. Open DevTools (F12)
2. In Console, run:
   ```js
   document.querySelectorAll('[role="tab"]').forEach(el => { if(el.textContent.includes('eSIM')) el.click(); });
   ```
3. Replace `'eSIM'` with the target tab name as needed.

Alternatively, enable responsive/mobile mode in DevTools (iPhone SE, 375x667) to see the tab bar in viewport.

## Known Expo Web Limitations

### Alert.alert renders as window.confirm()

On Expo web, `Alert.alert` with multiple buttons renders as `window.confirm()`. In Chrome for Testing (headless-like), `confirm()` may be auto-dismissed returning `false` (cancel). This means:

- Plan activation confirmation dialogs won't trigger the "Activează acum" callback
- Workaround: Override confirm before clicking: `window.confirm = () => true;`
- Even with override, the activation flow may not trigger reliably on web
- **This is NOT a code bug** — on native iOS/Android, Alert.alert shows proper system dialogs

### Testing activation flow

If Alert.alert workaround doesn't work, the activation logic can be verified by:
1. Checking TypeScript compilation passes (`npx tsc --noEmit`)
2. Verifying the mock provisionESIM function in esimProvisioning.ts (1.5s delay → success)
3. Testing on native iOS simulator via Xcode (where Alert.alert works properly)

## eSIM Screen Test Checklist

1. **Country selection**: "Unde mergi?" title, search bar, popular destinations grid, region-grouped list
2. **Search**: Type partial country name (e.g. "Jap") → filters to matching countries
3. **Per-country pricing**: Each country has unique plans. Verify:
   - Japan: 1GB €2.99, 5GB €8.99
   - USA: 1GB €3.99, 5GB €12.99
   - Romania: 1GB €1.99, 5GB €4.99
4. **POPULAR badge**: Plans marked as popular show green accent border + "POPULAR" badge
5. **No provider names**: UI shows only "Internet pentru [Țară]" — no Airalo/carrier names
6. **Back navigation**: "Înapoi" button returns to country selection
7. **Activation flow**: Select plan → confirm → activating screen → success screen (test on native iOS)

## Devin Secrets Needed

None required for mock mode testing. For real API testing:
- `EXPO_PUBLIC_SUPABASE_URL` - Supabase project URL
- `EXPO_PUBLIC_SUPABASE_ANON_KEY` - Supabase anon key
- `EXPO_PUBLIC_AIRALO_CLIENT_ID` - Airalo partner client ID
- `EXPO_PUBLIC_AIRALO_CLIENT_SECRET` - Airalo partner client secret
