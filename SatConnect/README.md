# SatConnect - Aplicatie iOS (React Native/Expo)

Aplicatie mobila pentru conectivitate satelit, WiFi, eSIM si roaming global in 175 de tari.

## Deschidere rapida in Xcode (o singura comanda)

Pe Mac, deschide **Terminal** si ruleaza:

```bash
git clone https://github.com/cheloodx/Vigor-.git
cd Vigor-/SatConnect
chmod +x setup-ios.sh
./setup-ios.sh
```

Scriptul face totul automat: verifica Xcode, instaleaza dependentele, instaleaza pod-urile si deschide proiectul in Xcode.

## Setup manual (pas cu pas)

Daca preferi sa faci manual:

### 1. Cerinte

- **macOS** (Monterey 12+ recomandat)
- **Xcode** - descarca din [Mac App Store](https://apps.apple.com/app/xcode/id497799835)
- **Node.js** - descarca de la [nodejs.org](https://nodejs.org/) (v18+)
- **CocoaPods** - se instaleaza automat sau manual: `sudo gem install cocoapods`
- **Apple ID** - gratuit pentru simulator, 99 EUR/an pentru App Store

### 2. Cloneaza repo-ul

```bash
git clone https://github.com/cheloodx/Vigor-.git
cd Vigor-/SatConnect
```

### 3. Instaleaza dependentele JavaScript

```bash
npm install
```

### 4. Instaleaza dependentele iOS (CocoaPods)

```bash
cd ios
pod install
cd ..
```

### 5. Deschide in Xcode

```bash
open ios/SatConnect.xcworkspace
```

**IMPORTANT:** Deschide fisierul `.xcworkspace`, NU `.xcodeproj`!

### 6. Configurare Xcode

1. In Xcode, selecteaza **SatConnect** in panoul din stanga
2. La **Signing & Capabilities**:
   - Bifeaza **Automatically manage signing**
   - La **Team**, selecteaza Apple ID-ul tau (adauga-l din Xcode > Settings > Accounts daca nu apare)
3. Selecteaza un simulator din bara de sus (ex: **iPhone 16**)
4. Apasa **Play** (▶) sau **Cmd+R** pentru a rula aplicatia

### 7. Rulare pe iPhone fizic

1. Conecteaza iPhone-ul cu cablul USB
2. Pe iPhone: Settings > Privacy & Security > Developer Mode > ON
3. In Xcode, selecteaza iPhone-ul tau in loc de simulator
4. Apasa Play - prima data va cere sa ai incredere in certificat pe iPhone
5. Pe iPhone: Settings > General > VPN & Device Management > aproba certificatul

## Structura proiectului

```
SatConnect/
├── App.tsx                    # Entry point
├── app.json                   # Configurare Expo (bundle ID, permisiuni)
├── setup-ios.sh               # Script automat setup iOS
├── ios/                       # Proiect nativ iOS (Xcode)
│   ├── Podfile                # Dependente CocoaPods
│   ├── SatConnect.xcodeproj/  # Proiect Xcode
│   └── SatConnect/
│       ├── Info.plist         # Configurare iOS (permisiuni, orientare)
│       ├── AppDelegate.swift  # Delegate principal
│       └── Images.xcassets/   # Icon-uri si splash screen
└── src/
    ├── screens/               # 15 ecrane (Home, Login, Map, Plans, etc.)
    ├── components/            # 6 componente reutilizabile
    ├── services/              # 7 servicii (storage, sync, auth, IAP, etc.)
    ├── contexts/              # ThemeContext (dark mode), LanguageContext (i18n)
    ├── constants/             # Teme, date mock, tipuri
    └── i18n/                  # Traduceri (Romana + Engleza)
```

## Functionalitati

- **Conectivitate**: WiFi, Date mobile, Roaming Global (175 tari), GPS Satelit, eSIM, GPS Local
- **eSIM Virtual**: 3 cartele (Europa 50GB, America & Asia 30GB, Global 100GB)
- **Planuri**: Free (3GB), Explorer (100GB/1.99 EUR), Pro (500GB/3.99 EUR), Unlimited (6.99 EUR)
- **Mesagerie**: Chat optimizat pentru bandwidth redus
- **GPS & Harta**: Tracking locatie cu sincronizare offline
- **SOS**: Buton de urgenta (tine apasat 3 secunde)
- **Dark Mode**: Tema intunecata
- **Multi-limba**: Romana + Engleza
- **Contacte**: Adauga/editeaza/sterge contacte
- **Setari**: Notificari, securitate, sincronizare

## Probleme frecvente

### "No bundle URL present"
Ruleaza `npm start` intr-un terminal separat si apoi apasa Play in Xcode.

### "Signing requires a development team"
Xcode > Settings > Accounts > adauga Apple ID-ul tau, apoi selecteaza echipa la Signing & Capabilities.

### Pod install esueaza
```bash
sudo gem install cocoapods
cd ios
pod repo update
pod install
```

### Eroare la compilare
```bash
cd ios
pod deintegrate
pod install
```
Apoi in Xcode: Product > Clean Build Folder (Cmd+Shift+K), apoi Play din nou.

## Bundle ID

- **iOS Bundle ID**: `com.satconnect.app`
- **Versiune**: 1.0.0 (MVP)
