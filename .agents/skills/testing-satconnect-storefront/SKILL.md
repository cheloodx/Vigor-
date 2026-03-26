# Testing SatConnect Storefront

## Environment

- **Production URL**: https://satconnect.net
- **Hetzner Server**: 46.224.164.70 (SSH as root)
- **Backend Port**: 3001 (proxied via nginx on port 443)
- **Backend Directory on Server**: /root/backend
- **Server Logs**: /tmp/satconnect.log
- **Health Check**: https://satconnect.net/health (returns JSON with service status)

## Devin Secrets Needed

- `HETZNER_SATCONNECT_SSH_KEY` - SSH key for accessing the Hetzner server (stored at /home/ubuntu/.ssh/hetzner_satconnect)
- Supabase credentials are configured in /root/backend/.env on the server
- Stripe keys are configured in /root/backend/.env on the server

## Deploying Changes

1. Use `scp` to copy files to the server:
   ```
   scp -i /home/ubuntu/.ssh/hetzner_satconnect -o StrictHostKeyChecking=no <local-file> root@46.224.164.70:/root/backend/<path>
   ```
2. Restart the server:
   ```
   ssh -i /home/ubuntu/.ssh/hetzner_satconnect -o StrictHostKeyChecking=no root@46.224.164.70 'killall -q ts-node node 2>/dev/null || true; sleep 1; cd /root/backend && nohup npx ts-node src/index.ts > /tmp/satconnect.log 2>&1 & echo started'
   ```
   Note: The SSH command may hang after printing "started" because nohup backgrounds the process. Use Ctrl+C to close the SSH session - the server will continue running.
3. Wait ~8 seconds, then verify: `curl -s https://satconnect.net/health`

## Key Frontend Files

- `backend/public/index.html` - Main storefront with 3D globe (Three.js), search, region tabs, country grid, modal
- `backend/public/payment-success.html` - Payment confirmation page with polling for eSIM provisioning
- `backend/public/payment-cancel.html` - Payment cancellation page
- `backend/src/index.ts` - Express server with CSP configuration

## Testing the Storefront

### 1. Page Load & Globe
- Navigate to https://satconnect.net
- Verify the page loads with dark theme and 3D globe background
- Check console: only Two.js deprecation warnings are expected (not errors)
- Verify `document.getElementById('globe-canvas')` exists with non-zero dimensions
- Note: On VMs without GPU, WebGL falls back to software rendering (shows a warning but still works)

### 2. Plans Loading
- Plans load from `/plans` endpoint
- Should show 179+ countries with flags, plan counts, and prices
- Stats row shows "179+ Tari acoperite", "30s Activare medie", "24/7 Disponibilitate"

### 3. Search
- Type in the search input to filter countries
- Autocomplete dropdown appears with matching results (flag + country name)
- Clicking an autocomplete item opens the country modal

### 4. Region Tabs
- Tabs: Toate, Europa, Asia, Americas, Africa & ME, Oceania
- Each tab filters the grid to show only countries in that region
- Europa shows ~49 countries, Asia shows ~37, etc.

### 5. Country Modal
- Click a country card to open the modal
- Modal shows: flag, country name, list of plans with data/validity/price
- Select a plan by clicking it (radio-style selection)
- Buy button enables after selection, shows plan details
- Three close methods: X button, Escape key, overlay click

### 6. Checkout Redirect
- Clicking buy redirects to Stripe checkout (checkout.stripe.com)
- **WARNING**: Stripe is in LIVE mode - clicking buy will create a real checkout session
- Verify the redirect URL contains the correct plan info
- Do NOT complete a real payment during testing

### 7. Payment-Success Page
- Test with invalid session: `/payment-success.html?session_id=cs_test_invalid123`
- Should show "Plata nefinalizata" error with "Inapoi la magazin" link
- The page should NOT crash or show a blank white screen
- With a valid session, it polls `/api/orders/{sessionId}` for eSIM details
- If provisioning takes >60s, shows "Plata confirmata!" fallback with continued background polling

## Common Issues

- **Supabase project suspension**: Free tier Supabase projects auto-suspend after inactivity. Check if the Supabase URL in .env is still active. The project ID may need to be updated if a new project is created.
- **SSH exit code 255**: When running `pkill` or `kill` via SSH, the command may return exit code 255 if no process is found. Use `|| true` to suppress this.
- **Three.js deprecation**: Using v0.160.0 from unpkg.com shows a deprecation warning about build scripts. This is cosmetic and doesn't affect functionality.
- **Browser console**: `browser_console` tool requires Chrome to be in the foreground. Click on the Chrome window first if the tool reports "Chrome is not in the foreground".
