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
echo -e "${YELLOW}[1/8] Verificare sistem...${NC}"
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}EROARE: Acest script functioneaza doar pe macOS!${NC}"
    echo "Ai nevoie de un Mac cu Xcode instalat."
    exit 1
fi
echo -e "${GREEN}  OK - macOS detectat${NC}"

# Pas 2: Verifică dacă Xcode este instalat
echo -e "${YELLOW}[2/8] Verificare Xcode...${NC}"
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
echo -e "${YELLOW}[3/8] Verificare Node.js...${NC}"
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
echo -e "${YELLOW}[4/8] Verificare CocoaPods...${NC}"
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
echo -e "${YELLOW}[5/8] Instalare dependente JavaScript...${NC}"
npm install
echo -e "${GREEN}  OK - Dependente instalate${NC}"

# Pas 6: Regenerare proiect iOS nativ
echo -e "${YELLOW}[6/8] Generare proiect iOS nativ (poate dura 2-3 minute)...${NC}"
echo "  Se sterge ios/ vechi si se regenereaza..."
rm -rf ios
npx expo prebuild --platform ios --no-install

# Pas 6b: Fix Xcode 15/16 sandbox — disable ENABLE_USER_SCRIPT_SANDBOXING in MAIN project
echo "  Se dezactiveaza sandbox pentru Xcode 15/16..."
PBXPROJ="ios/SatConnect.xcodeproj/project.pbxproj"
if [ -f "$PBXPROJ" ]; then
  if ! grep -q "ENABLE_USER_SCRIPT_SANDBOXING" "$PBXPROJ"; then
    sed -i '' 's/buildSettings = {/buildSettings = {\
				ENABLE_USER_SCRIPT_SANDBOXING = NO;\
				SKIP_BUNDLING = 1;/g' "$PBXPROJ"
  fi
fi

echo "  Se instaleaza pod-uri..."
cd ios
pod install
cd ..

# Fix sandbox in Pods project too (after pod install generates it)
PODS_PBXPROJ="ios/Pods/Pods.xcodeproj/project.pbxproj"
if [ -f "$PODS_PBXPROJ" ]; then
  if ! grep -q "ENABLE_USER_SCRIPT_SANDBOXING" "$PODS_PBXPROJ"; then
    sed -i '' 's/buildSettings = {/buildSettings = {\
				ENABLE_USER_SCRIPT_SANDBOXING = NO;/g' "$PODS_PBXPROJ"
  fi
fi
echo -e "${GREEN}  OK - Proiect iOS generat, pod-uri instalate, sandbox dezactivat${NC}"

# Pas 7: Bundling JavaScript pentru offline use
echo -e "${YELLOW}[7/8] Bundling JavaScript (aplicatia va merge fara Metro server)...${NC}"
# Use Expo's built-in bundler (no extra CLI dependencies needed)
npx expo export --platform ios --output-dir ios/expo-bundle
# Find the JS/HBC bundle from expo export and copy it as main.jsbundle
# Expo with Hermes produces .hbc files (Hermes bytecode), not .js
BUNDLE_FILE=$(find ios/expo-bundle -name "*.hbc" -o -name "*.js" 2>/dev/null | grep "_expo/static/js" | head -1)
if [ -n "$BUNDLE_FILE" ]; then
  cp "$BUNDLE_FILE" ios/main.jsbundle
  echo -e "${GREEN}  OK - JavaScript bundle creat${NC}"
else
  echo -e "${YELLOW}  WARN - Bundle nu a fost gasit, se va folosi Metro la runtime${NC}"
fi
rm -rf ios/expo-bundle

# Pas 8: Setare Release mode si deschidere Xcode
echo -e "${YELLOW}[8/8] Deschidere Xcode...${NC}"

# Change scheme to Release mode so it uses the embedded JS bundle
SCHEME_FILE="ios/SatConnect.xcodeproj/xcshareddata/xcschemes/SatConnect.xcscheme"
if [ -f "$SCHEME_FILE" ]; then
  sed -i '' '/<LaunchAction/,/<\/LaunchAction/ s/buildConfiguration = "Debug"/buildConfiguration = "Release"/g' "$SCHEME_FILE"
fi
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
