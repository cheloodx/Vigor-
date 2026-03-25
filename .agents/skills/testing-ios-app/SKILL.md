# Testing: Kamasutra Guide iOS App (VIGOR)

## App Overview
- Native iOS app built with SwiftUI (not a web app)
- 57 intimate positions with cartoon illustrations stored in Xcode asset catalog
- 6 couple games, 10 discover features, favorites system
- 5 tabs: Pozitii, Jocuri, Favorite, Info, Descopera
- All content is in Romanian

## Testing on Linux (No Xcode Available)

This is a native iOS app that **cannot be built or run** on Linux. Testing is limited to:

### What CAN Be Tested
1. **Asset catalog structural integrity** - verify all imageset folders have correct JPEG + Contents.json
2. **Code-to-asset consistency** - verify all position IDs in `Gamification.swift` match asset catalog folder names
3. **Swift code reference checks** - verify `Image(position.id)` pattern is used correctly, no broken references
4. **Visual preview via HTML gallery** - serve images locally and verify all 57 illustrations render
5. **PR review comment compliance** - verify flagged issues (e.g., nested NavigationView, NSAllowsArbitraryLoads) are fixed

### What CANNOT Be Tested
- Building the project in Xcode (compile errors are likely since code was never compiled)
- Running on iOS simulator
- Interactive testing (favorites persistence, games, timer, navigation)
- Image quality on Retina displays (@2x/@3x)
- App Store submission readiness

## Key File Locations
- **Position data**: `VIGOR/Models/Gamification.swift` - all 57 positions with IDs, descriptions, categories
- **Asset catalog**: `VIGOR/Assets.xcassets/Positions/` - 57 imageset folders, one per position
- **Image loading code**: `VIGOR/Utilities/Components.swift:14` (PositionCard), `VIGOR/Views/Main/ProfileView.swift:57` (detail view), `VIGOR/Views/Training/WorkoutDetailView.swift:314` (roulette game)
- **App state**: `VIGOR/Utilities/AppState.swift` - favorites with UserDefaults persistence
- **Theme**: `VIGOR/Utilities/Theme.swift` - rose/pink/purple gradients, dark mode

## Asset Catalog Structure
Each position has:
```
{position-id}.imageset/
  ├── {position-id}.jpeg
  └── Contents.json  (references jpeg, idiom: universal, scale: 1x)
```

## Automated Verification Script
Run this to verify asset integrity:
```bash
python3 -c "
import os, json, re
ASSET_DIR = 'VIGOR/Assets.xcassets/Positions'
with open('VIGOR/Models/Gamification.swift') as f:
    code_ids = set(re.findall(r'id:\s*\"([^\"]+)\"', f.read()))
asset_ids = set(d.replace('.imageset','') for d in os.listdir(ASSET_DIR) if d.endswith('.imageset'))
print(f'Code: {len(code_ids)}, Assets: {len(asset_ids)}')
print(f'Missing in assets: {code_ids - asset_ids}')
print(f'Missing in code: {asset_ids - code_ids}')
for pid in sorted(asset_ids):
    p = os.path.join(ASSET_DIR, f'{pid}.imageset', f'{pid}.jpeg')
    if not os.path.exists(p): print(f'MISSING: {p}')
"
```

## HTML Preview Gallery
To visually verify illustrations without Xcode:
1. Generate an HTML gallery file that references all JPEG images from the asset catalog
2. Serve with `python3 -m http.server` and view in browser
3. Verify all 57 images load, show correct cartoon style, no broken images

## Known Limitations
- Only 1x scale images provided (may appear blurry on Retina @2x/@3x displays)
- 3 positions share duplicate images (54 unique source images for 57 positions)
- The `image` field in Gamification.swift contains old Unsplash URLs (dead code, not used by views)
- File names don't match content (e.g., `DailyRewardsView.swift` contains `RomanticQuotesView`) - intentional to avoid modifying .xcodeproj

## No CI Configured
This repo has no CI checks. All verification must be done manually or via scripts.

## Devin Secrets Needed
None required for testing. Apple Developer credentials (`cheloodx@yahoo.com`) needed only for App Store submission.
