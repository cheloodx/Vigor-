# Testing SatConnect Expo App

## Environment Setup

1. Navigate to `SatConnect/` directory
2. Ensure `.env` file exists with `EXPO_PUBLIC_*` variables
3. Start Expo web dev server:
   ```bash
   cd SatConnect && npx expo start --web --port 8082
   ```
4. Open `http://localhost:8082` in Chrome

## Devin Secrets Needed

- `SUPABASE_EMAIL` - Supabase dashboard login email
- `SUPABASE_PASSWORD` - Supabase dashboard login password
- Supabase Project URL and Anon Key (stored in `.env`)

## Key Testing Techniques

### Accessing App Internals via Browser Console

Expo web bundles use Metro's `__r()` function to require modules by index. To find and use the esimProvisioning service:

```javascript
// Find the module index (may change between restarts)
let found = null;
for (let i = 0; i < 2000; i++) {
  try {
    const m = __r(i);
    if (m && m.esimProvisioning) {
      found = m;
      console.log('Found esimProvisioning at module', i);
      break;
    }
  } catch(e) {}
}

// Use it to test provisioning directly
const svc = __r(MODULE_INDEX).esimProvisioning;
svc.provisionESIM('be-5gb').then(r => console.log(JSON.stringify(r)));
```

This is useful when UI interactions (like `Alert.alert` dialogs) are hard to automate on Expo web.

### Alert.alert on Expo Web

React Native's `Alert.alert()` on web may render as browser native dialogs (`window.confirm()`) that can be auto-dismissed by automation tools. When testing flows that trigger alerts:
- Use `__r()` to call service methods directly from console
- Or override `window.confirm = () => true` before triggering the UI action

### Testing Env Var Inlining

Expo's babel-preset-expo only inlines `process.env.EXPO_PUBLIC_*` when accessed as static member expressions. To verify inlining works:
1. Check browser Network tab for requests to the Supabase URL
2. Attempt login with invalid credentials — a 400 from Supabase proves env vars are inlined
3. If login succeeds instantly with mock data, env vars are NOT being inlined

### Testing Dark Mode Persistence

1. Navigate to Profil tab → Setări (Settings)
2. Toggle "Mod întunecat" ON
3. Verify in console: `localStorage.getItem('@satconnect_theme')` returns `'dark'`
4. Hard refresh (Ctrl+Shift+R)
5. Check that `localStorage.getItem('@satconnect_theme')` still returns `'dark'`
6. Navigate back to Settings and verify toggle is still ON

### Testing eSIM Profile Persistence

1. Provision eSIM for country A via console
2. Provision eSIM for country B via console
3. Check `localStorage.getItem('@satconnect_esim_profiles')` — should contain BOTH profiles
4. Hard refresh and check again — both should still be present

### Testing Airalo API Fallthrough Prevention

Requires temporarily modifying `.env`:
1. Set `EXPO_PUBLIC_AIRALO_CLIENT_ID=fake_id` and `EXPO_PUBLIC_AIRALO_CLIENT_SECRET=fake_secret`
2. Restart Expo server (Ctrl+C then restart)
3. Call `provisionESIM()` via console
4. Expected: `{"success":false,"error":"Activarea eSIM a eșuat. Încearcă din nou."}`
5. If it returns `{"success":true}` with mock profile, the fallthrough bug is still present
6. **IMPORTANT**: Restore `.env` to original (empty Airalo credentials) after testing

## Countries with Dynamic Plans

These countries use `generateDefaultPlans()` (no explicit COUNTRY_PLANS entry):
BE, NL, AT, CH, PT, PL, CZ, HU, SE, NO, DK, FI, IE, HR, BG, VN, ID, MY, SG, TW, PH, HK, AR, CO, CL, PE, ZA, MA, IL, NZ

Dynamic plans follow the format: `{cc}-1gb` (€2.99, 7d), `{cc}-5gb` (€8.99, 30d, popular), `{cc}-10gb` (€14.99, 30d)

## Creating Test Users

To create a test user on Supabase for login testing:
```bash
curl -s -X POST 'https://YOUR_SUPABASE_URL/auth/v1/signup' \
  -H 'apikey: YOUR_ANON_KEY' \
  -H 'Content-Type: application/json' \
  -d '{"email":"test@example.com","password":"TestPassword123!"}'
```

## Common Issues

- **Node.js version**: Expo 55 requires Node.js >= 20.19.4. Check with `node --version`
- **Port conflicts**: Default port 8082 may be in use. Kill existing processes or use a different port
- **Env var changes require restart**: After modifying `.env`, you must restart the Expo server for changes to take effect
- **browser_console tool**: May not work if Chrome is not properly in foreground. Use DevTools console directly via F12 as fallback
