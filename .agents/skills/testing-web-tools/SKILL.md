# Testing AutoDiag Pro Website Tools

## Overview
AutoDiag Pro is a React + Vite web app with 27 tool pages organized into 5 categories. Tools connect to a backend API at `https://agenticmax.co.uk/autodiag` with fallback mock data when API is down.

## Deployed URL
- Live site: Deployed via `deploy` tool with `command: frontend, dir: dist`
- Build before deploy: `npm run build` (from project root)
- The site may also be deployed at a custom domain in the future

## Tool Categories & Routes
- **DIAGNOSTIC** (7): scor-sanatate, diagrama, scan, scanner-piese, dtc, sound, diagnostic-rapid
- **AI & PREDICTII** (5): chat, predictor, radar-itp, digital-twin, european
- **VEHICUL** (5): cv-auto, vin, obd2, recall, blockchain
- **SERVICE & COSTURI** (7): service-calendar, costuri, calculator-consum, estimator-valoare, voce, comparator, comparator-rca
- **EUROPA & MARKETPLACE** (3): harta-service, marketplace, legal-amenzi

All routes are at `/tools/{slug}`. The hub page is at `/tools`.

## Full E2E Testing Procedure

### ToolsHub Verification
1. Navigate to `/tools`
2. Verify 5 section headings: DIAGNOSTIC, AI & PREDICTII, VEHICUL, SERVICE & COSTURI, EUROPA & MARKETPLACE
3. Count tool cards per section: 7, 5, 5, 7, 3 (total 27)
4. Each card should show green LIVE badge

### Testing Each Tool Type

#### Client-side calculators (exact output verification)
- **Calculator Consum**: Enter 450km/35L/7.50RON -> expect CONSUM=7.78, COST/100KM=58.33, COST/KM=0.583
- **Comparator RCA**: Enter 1600cc/5yr/Bucuresti -> expect 6 insurers sorted by price, CEL MAI IEFTIN badge on cheapest
- **Service Calendar**: Test full CRUD cycle — add entry, verify display, toggle checkbox (strikethrough), delete (restores empty state)

#### API-connected tools (have fallback)
These call the backend but gracefully fallback to mock data if API is down:
- **Scor Sanatate**: Enter BMW/320d/2018/120000 -> expect score 20-100, 6 category rows with progress bars
- **Predictor AI**: Enter Renault/Megane/2016/130000/Diesel -> expect risk predictions with cost estimates
- **Radar ITP**: Enter Dacia/Logan/2015/180000 -> expect pass percentage + 8 check categories
- **Digital Twin**: Enter Toyota/Corolla/2020/60000 -> expect score + 6 system health bars
- **CV Auto**: Enter VIN (min 11 chars, e.g. WVWZZZ3CZWE123456) -> expect decoded make/model + timeline
- **Recall Check**: Enter Ford/Focus/2018 -> expect recall count + detailed descriptions
- **Diagnostic Rapid**: Select 2+ symptoms -> expect AI diagnosis text with causes
- **Costuri**: Select 2+ operations -> expect total range + itemized breakdown
- **Scanner Piese**: Click quick tag or search -> expect 5 part results with prices
- **Estimator Valoare**: Enter Audi/A4/2017/100000 -> expect EUR value + depreciation %

#### Static display tools (verify rendering)
- **OBD2 Avansat**: Expect 12 PID values in grid (RPM, Temp, Speed, etc.)
- **Marketplace**: Expect 5+ mechanic listings with ratings and Contacteaza buttons
- **Diagrama Auto**: Expect car diagram with clickable component markers (click Motor for detail panel)
- **Comparator**: Expect 8 operations with Autorizat vs Independent pricing comparison table
- **Harta Service**: Expect 5 service listings with filter buttons (Toate/Autorizate/Independente) — test filter
- **Legal & Amenzi**: Expect Viteza expanded by default with 4 fines, click another section to test accordion

#### Special interaction tools
- **Voce**: Use manual text input (mic requires real device), verify transcription appears
- **Blockchain Passport**: Enter VIN + country -> expect Trust Score, Blockchain ID, EU Compliant badge
- **VIN Decoder**: Enter 17-char VIN -> expect NHTSA Verified badge, make/model/year/country
- **AI European**: Select brand + country from dropdowns -> expect Fiabilitate %, Popularitate %, RON/an
- **Mecanic AI Chat**: Type question -> expect AI response in Romanian

### Common Verification Points
1. Every tool page has a back arrow (ArrowLeft) linking to `/tools`
2. Every tool has a title and subtitle in the header
3. No blank screens or console errors on any page
4. Forms validate input (empty fields don't submit)

## Chrome Setup on Devin VM
The `google-chrome` wrapper connects to a CDP instance. Navigate via URL bar or use navbar links.
Before recording, maximize browser: `DISPLAY=:0 wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz`

## Tech Stack
- React + Vite + TypeScript
- Tailwind CSS + Framer Motion
- React Router for navigation
- Backend: FastAPI on Hetzner server at agenticmax.co.uk

## Devin Secrets Needed
No secrets needed for testing the deployed website. Backend API is public.
Hetzner server credentials may be needed if backend needs restarting (saved as HETZNER_PASSWORD).
