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

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

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

# Pas 3: Verifică/instalează Node.js >= 20.19.4 (necesar pentru Expo 55)
echo -e "${YELLOW}[3/7] Verificare Node.js...${NC}"
NODE_MIN_MAJOR=20
NODE_MIN_MINOR=19
NODE_MIN_PATCH=4

check_node_version() {
    local ver
    ver=$(node --version 2>/dev/null | sed 's/^v//')
    if [ -z "$ver" ]; then return 1; fi
    local major minor patch
    major=$(echo "$ver" | cut -d. -f1)
    minor=$(echo "$ver" | cut -d. -f2)
    patch=$(echo "$ver" | cut -d. -f3)
    if [ "$major" -gt "$NODE_MIN_MAJOR" ]; then return 0; fi
    if [ "$major" -eq "$NODE_MIN_MAJOR" ] && [ "$minor" -gt "$NODE_MIN_MINOR" ]; then return 0; fi
    if [ "$major" -eq "$NODE_MIN_MAJOR" ] && [ "$minor" -eq "$NODE_MIN_MINOR" ] && [ "$patch" -ge "$NODE_MIN_PATCH" ]; then return 0; fi
    return 1
}

# Try brew node@22 path first if default node is too old
if ! command -v node &> /dev/null || ! check_node_version; then
    for p in /opt/homebrew/opt/node@22/bin /usr/local/opt/node@22/bin /opt/homebrew/opt/node/bin /usr/local/opt/node/bin; do
        if [ -d "$p" ]; then
            export PATH="$p:$PATH"
            echo "  Se foloseste Node.js din $p"
            break
        fi
    done
fi

# Try nvm if still not good enough
if ! command -v node &> /dev/null || ! check_node_version; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    if command -v nvm &> /dev/null; then
        nvm use 22 2>/dev/null || nvm use node 2>/dev/null || true
    fi
fi

if ! command -v node &> /dev/null; then
    echo -e "${RED}EROARE: Node.js nu este instalat!${NC}"
    echo ""
    echo "Instaleaza Node.js 22:"
    echo "  brew install node@22"
    echo "  sau descarca de la: https://nodejs.org/"
    echo ""
    exit 1
fi

if ! check_node_version; then
    echo -e "${YELLOW}  Node.js $(node --version) e vechi. Se incearca instalare automata...${NC}"
    if command -v brew &> /dev/null; then
        brew install node@22 2>/dev/null || brew upgrade node 2>/dev/null || true
        for p in /opt/homebrew/opt/node@22/bin /usr/local/opt/node@22/bin; do
            if [ -d "$p" ]; then
                export PATH="$p:$PATH"
                break
            fi
        done
    fi
    if ! check_node_version; then
        echo -e "${RED}EROARE: Node.js $(node --version) e prea vechi! Trebuie >= v${NODE_MIN_MAJOR}.${NODE_MIN_MINOR}.${NODE_MIN_PATCH}${NC}"
        echo ""
        echo "Descarca Node.js 22 de la: https://nodejs.org/en/download"
        echo "Alege macOS ARM64 (Apple Silicon) sau macOS x64 (Intel)"
        echo ""
        exit 1
    fi
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

# Fix Xcode 15/16 sandbox — disable ENABLE_USER_SCRIPT_SANDBOXING
echo "  Se dezactiveaza sandbox pentru Xcode 15/16..."
PBXPROJ="ios/SatConnect.xcodeproj/project.pbxproj"
if [ -f "$PBXPROJ" ]; then
  if ! grep -q "ENABLE_USER_SCRIPT_SANDBOXING" "$PBXPROJ"; then
    sed -i '' 's/buildSettings = {/buildSettings = {\
				ENABLE_USER_SCRIPT_SANDBOXING = NO;/g' "$PBXPROJ"
  fi
fi

echo "  Se instaleaza pod-uri..."
cd ios
pod install
cd ..

# Fix sandbox in Pods project too
PODS_PBXPROJ="ios/Pods/Pods.xcodeproj/project.pbxproj"
if [ -f "$PODS_PBXPROJ" ]; then
  if ! grep -q "ENABLE_USER_SCRIPT_SANDBOXING" "$PODS_PBXPROJ"; then
    sed -i '' 's/buildSettings = {/buildSettings = {\
				ENABLE_USER_SCRIPT_SANDBOXING = NO;/g' "$PODS_PBXPROJ"
  fi
fi
echo -e "${GREEN}  OK - Proiect iOS generat, pod-uri instalate, sandbox dezactivat${NC}"

# Pas 7: Creare script run-app.sh si pornire
echo -e "${YELLOW}[7/7] Pregatire lansare...${NC}"

# Creare script run-app.sh pentru lansari viitoare
cat > run-app.sh << 'RUNEOF'
#!/bin/bash
# SatConnect - Lansare aplicatie (Metro + Xcode)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Auto-detect Node.js
for p in /opt/homebrew/opt/node@22/bin /usr/local/opt/node@22/bin /opt/homebrew/opt/node/bin; do
  if [ -d "$p" ]; then export PATH="$p:$PATH"; break; fi
done
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

echo "Pornire Metro packager + Xcode..."
echo "Metro va servi JavaScript-ul catre simulator."
echo ""

# Deschide Xcode
open ios/SatConnect.xcworkspace

# Porneste Metro in prim-plan
npx expo start --localhost
RUNEOF
chmod +x run-app.sh
echo -e "${GREEN}  OK - Script run-app.sh creat pentru lansari viitoare${NC}"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Setup complet!                  ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Se porneste Metro packager si se deschide Xcode...${NC}"
echo ""
echo -e "${BLUE}Pasi in Xcode:${NC}"
echo "  1. Selecteaza un simulator (ex: iPhone 16)"
echo "  2. Apasa Play (▶) sau Cmd+R"
echo "  3. Daca cere echipa de dezvoltare:"
echo "     - Xcode > Settings > Accounts > adauga Apple ID"
echo "     - La Signing & Capabilities > selecteaza echipa ta"
echo ""
echo -e "${YELLOW}IMPORTANT: Nu inchide acest Terminal! Metro trebuie sa ruleze.${NC}"
echo -e "${YELLOW}Prima compilare dureaza 2-5 minute.${NC}"
echo ""
echo -e "${GREEN}Data viitoare ruleaza doar: ./run-app.sh${NC}"
echo ""

# Deschide Xcode
open ios/SatConnect.xcworkspace

# Porneste Metro in prim-plan (nu inchide terminal-ul!)
npx expo start --localhost
