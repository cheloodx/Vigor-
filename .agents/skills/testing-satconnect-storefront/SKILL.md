# Testing SatConnect Storefront

## Overview
The SatConnect storefront is a single-page HTML application served from `SatConnect/backend/public/index.html`. It features a Three.js 3D globe, 14-language i18n, video background, animated counters, parallax effects, and interactive globe click-to-modal functionality.

## Live Site
- **URL**: https://satconnect.net
- **Deployment**: Hetzner server at 46.224.164.70
- **Deploy command**: `scp -i ~/.ssh/hetzner_satconnect SatConnect/backend/public/index.html root@46.224.164.70:/root/backend/public/index.html`

## Devin Secrets Needed
- `HETZNER_SATCONNECT_SSH_KEY` - SSH key for deploying to the Hetzner server (stored at `~/.ssh/hetzner_satconnect`)

## Testing Features via Browser Console

Since many effects are hard to visually verify in automated testing, use the browser DevTools console (F12) to programmatically verify:

### Animated Gradient
```js
var gt = document.querySelector('.gradient-text');
var cs = window.getComputedStyle(gt);
console.log('Animation:', cs.animationName, '| Duration:', cs.animationDuration, '| BgSize:', cs.backgroundSize);
// Expected: gradientFlow | 8s | 400% 100%
```

### Animated Counters
```js
// Check counter elements exist and have correct attributes
var stats = document.querySelectorAll('[data-count-to]');
stats.forEach(function(s) {
  console.log('STAT:' + s.textContent + '|target:' + s.getAttribute('data-count-to') + '|counted:' + s.dataset.counted);
});
// Expected final values: 179+, 50K+, 30s, 99.0%
// counted=1 means animation has fired
```

To re-trigger counter animation, scroll the stats row into view:
```js
window.scrollTo({top: 400, behavior: 'instant'});
// Then wait 2.5s and check values
```

### Interactive Globe
```js
var c = document.getElementById('globe-canvas');
console.log('pointer-events:', c.style.pointerEvents); // Should be 'auto'
console.log('tooltip exists:', !!document.getElementById('globe-tooltip')); // true
console.log('plans loaded:', !!window._allPlansRef, 'count:', Object.keys(window._allPlansRef || {}).length); // true, 179
```

Note: Globe city dots are very small (~4px) and difficult to hit precisely with automated mouse movements. The raycaster threshold is 0.08. Verify the infrastructure is correct (pointer-events, tooltip element, plans data) rather than trying to pixel-hunt dots.

### Parallax Effect
Use synthetic mouse events to verify parallax transforms:
```js
document.dispatchEvent(new MouseEvent('mousemove', {clientX: 10, clientY: 200}));
setTimeout(function() { console.log('LEFT:', document.querySelector('.hero h1').style.transform); }, 100);
// Then:
document.dispatchEvent(new MouseEvent('mousemove', {clientX: 1000, clientY: 200}));
setTimeout(function() { console.log('RIGHT:', document.querySelector('.hero h1').style.transform); }, 100);
// h1 should shift ~22px total between left and right
```

### Language Switching
```js
// Verify all stat labels are translated (not showing raw keys)
document.querySelectorAll('.stat-label').forEach(function(l) {
  console.log('LABEL:' + l.textContent + '|' + l.getAttribute('data-i18n'));
});
// Key labels to check: stat_countries, stat_clients, stat_activation, stat_uptime
// If textContent matches the data-i18n key name, translation is missing
```

### Video Background
```js
var v = document.querySelector('video');
console.log('paused:', v.paused, 'loop:', v.loop, 'muted:', v.muted);
// Expected: paused=false, loop=true, muted=true
```

## Common Issues

- **browser_console tool says 'Chrome not in foreground'**: Click on the Chrome window title bar or use `super+Up` to maximize it. If that doesn't work, open DevTools with F12 and type commands directly in the console panel.
- **Stats show 0 and don't animate**: The IntersectionObserver requires 50% visibility. Use `window.scrollTo()` to scroll the stats into view.
- **Globe canvas blocks clicks on UI elements**: The canvas has `pointer-events: auto` set by JS but higher z-index elements (.bg-overlay, .container) should still receive clicks. If UI elements become unclickable, check z-index ordering.
- **Counter shows wrong final value**: The 50K counter has a hardcoded '50K' string in the completion handler. If the target changes from 50000, update the hardcoded value too.

## Test Plan Structure
When testing premium effects, structure tests as:
1. **TC1: Gradient** - Verify CSS animation properties via computed style
2. **TC2: Counters** - Hard refresh, scroll to trigger, verify final values and `counted` flag
3. **TC3: Globe** - Verify infrastructure (pointer-events, tooltip, plans ref), attempt hover if possible
4. **TC4: Parallax** - Dispatch synthetic mousemove events at opposite screen edges, compare transforms
5. **TC5: Regression** - Switch language (especially CJK like JA), verify new translation keys, test search + modal, verify video playing
