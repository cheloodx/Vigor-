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
echo -e "${BLUE}║     SatConnect - Setup iOS/Xcode         ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}"
echo ""

# Pas 1: Verifică dacă suntem pe macOS
echo -e "${YELLOW}[1/7] Verificare sistem...${NC}"
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}EROARE: Acest script functioneaza doar pe macOS!${NC}"
    echo "Ai nevoie de un Mac cu Xcode instalat."
    exit 1
fi
echo -e "${GREEN}  OK - macOS detectat${NC}"

# Pas 2: Verifică dacă Xcode este instalat
echo -e "${YELLOW}[2/7] Verificare Xcode...${NC}"
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}EROARE: Xcode nu este instalat!${NC}"
    echo ""
    echo "Instaleaza Xcode din Mac App Store:"
    echo "  https://apps.apple.com/app/xcode/id497799835"
    echo ""
    echo "Dupa instalare, ruleaza:"
    echo "  sudo xcode-select --install"
    echo "  sudo xcodebuild -license accept"
    echo ""
    exit 1
fi
XCODE_VERSION=$(xcodebuild -version | head -1)
echo -e "${GREEN}  OK - $XCODE_VERSION${NC}"

# Pas 3: Verifică/instalează Node.js
echo -e "${YELLOW}[3/7] Verificare Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}EROARE: Node.js nu este instalat!${NC}"
    echo ""
    echo "Instaleaza Node.js de la: https://nodejs.org/"
    echo "  sau cu Homebrew: brew install node"
    echo ""
    exit 1
fi
NODE_VERSION=$(node --version)
echo -e "${GREEN}  OK - Node.js $NODE_VERSION${NC}"

# Pas 4: Verifică/instalează CocoaPods
echo -e "${YELLOW}[4/7] Verificare CocoaPods...${NC}"
if ! command -v pod &> /dev/null; then
    echo "  CocoaPods nu este instalat. Se instaleaza acum..."
    if command -v brew &> /dev/null; then
        brew install cocoapods
    else
        sudo gem install cocoapods
    fi
fi
POD_VERSION=$(pod --version)
echo -e "${GREEN}  OK - CocoaPods $POD_VERSION${NC}"

# Pas 5: Instalare dependențe npm
echo -e "${YELLOW}[5/7] Instalare dependente JavaScript...${NC}"
npm install
echo -e "${GREEN}  OK - Dependente instalate${NC}"

# Pas 6: Regenerare proiect iOS nativ
echo -e "${YELLOW}[6/7] Generare proiect iOS nativ (poate dura 2-3 minute)...${NC}"
echo "  Se sterge ios/ vechi si se regenereaza..."
rm -rf ios
npx expo prebuild --platform ios --no-install
echo "  Se instaleaza pod-uri..."
cd ios
pod install
cd ..
echo -e "${GREEN}  OK - Proiect iOS generat si pod-uri instalate${NC}"

# Pas 7: Deschide în Xcode
echo -e "${YELLOW}[7/7] Deschidere Xcode...${NC}"
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Setup complet!                  ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "Proiectul se deschide in Xcode acum..."
echo ""
echo -e "${BLUE}Pasi urmatori in Xcode:${NC}"
echo "  1. Selecteaza un simulator (ex: iPhone 16)"
echo "  2. Apasa Play sau Cmd+R pentru a rula"
echo "  3. Daca cere echipa de dezvoltare:"
echo "     - Xcode > Settings > Accounts > adauga Apple ID"
echo "     - La Signing & Capabilities > selecteaza echipa ta"
echo ""
echo -e "${YELLOW}NOTA: Prima compilare dureaza 2-5 minute.${NC}"
echo ""

open ios/SatConnect.xcworkspace
