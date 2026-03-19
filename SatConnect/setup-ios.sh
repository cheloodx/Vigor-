#!/bin/bash
# ==============================================
# SatConnect - Script automat setup iOS/Xcode
# ==============================================
# Rulează acest script pe Mac pentru a pregăti
# proiectul pentru Xcode. O singură comandă!
#
# Utilizare:
#   chmod +x setup-ios.sh
#   ./setup-ios.sh
# ==============================================

set -e

# Culori pentru output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     🛰️  SatConnect - Setup iOS/Xcode     ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}"
echo ""

# Pas 1: Verifică dacă suntem pe macOS
echo -e "${YELLOW}[1/6] Verificare sistem...${NC}"
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}EROARE: Acest script funcționează doar pe macOS!${NC}"
    echo "Ai nevoie de un Mac cu Xcode instalat."
    exit 1
fi
echo -e "${GREEN}  ✓ macOS detectat${NC}"

# Pas 2: Verifică dacă Xcode este instalat
echo -e "${YELLOW}[2/6] Verificare Xcode...${NC}"
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}EROARE: Xcode nu este instalat!${NC}"
    echo ""
    echo "Instalează Xcode din Mac App Store:"
    echo "  https://apps.apple.com/app/xcode/id497799835"
    echo ""
    echo "După instalare, rulează:"
    echo "  sudo xcode-select --install"
    echo "  sudo xcodebuild -license accept"
    echo ""
    exit 1
fi
XCODE_VERSION=$(xcodebuild -version | head -1)
echo -e "${GREEN}  ✓ $XCODE_VERSION${NC}"

# Pas 3: Verifică/instalează Node.js
echo -e "${YELLOW}[3/6] Verificare Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}EROARE: Node.js nu este instalat!${NC}"
    echo ""
    echo "Instalează Node.js de la: https://nodejs.org/"
    echo "  sau cu Homebrew: brew install node"
    echo ""
    exit 1
fi
NODE_VERSION=$(node --version)
echo -e "${GREEN}  ✓ Node.js $NODE_VERSION${NC}"

# Pas 4: Instalare dependențe npm
echo -e "${YELLOW}[4/6] Instalare dependențe JavaScript...${NC}"
if [ ! -d "node_modules" ]; then
    npm install
else
    echo "  node_modules există deja, verificare..."
    npm install
fi
echo -e "${GREEN}  ✓ Dependențe instalate${NC}"

# Pas 5: Verifică/instalează CocoaPods și instalează pod-urile
echo -e "${YELLOW}[5/6] Instalare dependențe iOS (CocoaPods)...${NC}"
if ! command -v pod &> /dev/null; then
    echo "  CocoaPods nu este instalat. Se instalează acum..."
    sudo gem install cocoapods
fi
POD_VERSION=$(pod --version)
echo -e "  CocoaPods $POD_VERSION"

cd ios
echo "  Se rulează pod install... (poate dura 1-2 minute)"
pod install
cd ..
echo -e "${GREEN}  ✓ Pod-uri instalate${NC}"

# Pas 6: Deschide în Xcode
echo -e "${YELLOW}[6/6] Deschidere Xcode...${NC}"
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Setup complet! 🎉               ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "Proiectul se deschide în Xcode acum..."
echo ""
echo -e "${BLUE}Pași următori în Xcode:${NC}"
echo "  1. Selectează un simulator (ex: iPhone 16)"
echo "  2. Apasă ▶ (Play) sau Cmd+R pentru a rula"
echo "  3. Dacă cere echipă de dezvoltare:"
echo "     - Xcode → Settings → Accounts → adaugă Apple ID"
echo "     - La Signing & Capabilities → selectează echipa ta"
echo ""
echo -e "${YELLOW}NOTĂ: Prima compilare durează 2-5 minute.${NC}"
echo ""

open ios/SatConnect.xcworkspace
