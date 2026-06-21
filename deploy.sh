#!/bin/bash
# ════════════════════════════════════════════════════════════
#  deploy.sh — Full auto deploy script for Kali Linux
#  Handles: Node.js, npm permissions, Firebase CLI, .env,
#           build, login, and Firebase Hosting deploy
# ════════════════════════════════════════════════════════════

# ─── Colors ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

# ─── Helpers ─────────────────────────────────────────────────
ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
warn() { echo -e "  ${YELLOW}⚠  $1${NC}"; }
err()  { echo -e "\n  ${RED}${BOLD}✗ ERROR: $1${NC}\n"; exit 1; }
step() { echo -e "\n${CYAN}${BOLD}[$1/$TOTAL]${NC} $2"; }

TOTAL=6

# ─── Banner ──────────────────────────────────────────────────
clear
echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║      Firebase Deploy — Kali Linux        ║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════╝${NC}"
echo ""

# ════════════════════════════════════════════════════════════
# STEP 1 — Fix npm global permissions (ALWAYS run first)
# ════════════════════════════════════════════════════════════
step 1 "Fixing npm global permissions..."

NPM_GLOBAL="$HOME/.npm-global"
mkdir -p "$NPM_GLOBAL"
npm config set prefix "$NPM_GLOBAL" 2>/dev/null

# Add to PATH for this session
export PATH="$NPM_GLOBAL/bin:$PATH"

# Persist to ~/.bashrc if not already there
if ! grep -q 'npm-global' "$HOME/.bashrc" 2>/dev/null; then
    {
        echo ''
        echo '# npm global packages — no sudo needed'
        echo 'export PATH="$HOME/.npm-global/bin:$PATH"'
    } >> "$HOME/.bashrc"
    ok "Added ~/.npm-global/bin to PATH in ~/.bashrc"
else
    ok "npm global path already configured"
fi

# ════════════════════════════════════════════════════════════
# STEP 2 — Check / Install Node.js
# ════════════════════════════════════════════════════════════
step 2 "Checking Node.js..."

if ! command -v node &>/dev/null; then
    warn "Node.js not found. Installing via nvm..."

    # Install nvm
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

    nvm install --lts
    nvm use --lts
    ok "Node.js $(node -v) installed via nvm"
else
    ok "Node.js $(node -v) already installed"
fi

# ════════════════════════════════════════════════════════════
# STEP 3 — Check / Install Firebase CLI
# ════════════════════════════════════════════════════════════
step 3 "Checking Firebase CLI..."

# Always ensure npm-global/bin is on PATH (covers fresh installs this session)
export PATH="$NPM_GLOBAL/bin:$PATH"

if ! command -v firebase &>/dev/null; then
    warn "Firebase CLI not found. Installing to ~/.npm-global (no sudo)..."
    npm install -g firebase-tools

    # Re-export PATH and re-check after install
    export PATH="$NPM_GLOBAL/bin:$PATH"
    hash -r 2>/dev/null || true

    if ! command -v firebase &>/dev/null; then
        err "Firebase CLI install failed. Try: source ~/.bashrc && ./deploy.sh"
    fi
    ok "Firebase CLI $(firebase --version) installed"
else
    ok "Firebase CLI $(firebase --version) already installed"
fi

# ════════════════════════════════════════════════════════════
# STEP 4 — Check .env credentials
# ════════════════════════════════════════════════════════════
step 4 "Checking Firebase credentials (.env)..."

if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        warn ".env created from .env.example"
    else
        err ".env.example not found. Cannot continue."
    fi
fi

# Check if .env still has placeholder values
if grep -q "your_api_key_here" ".env"; then
    echo ""
    echo -e "  ${RED}${BOLD}⚠  .env has placeholder values — fill in your Firebase credentials!${NC}"
    echo ""
    echo -e "  ${CYAN}Opening .env in nano...${NC}"
    echo -e "  ${YELLOW}  Save with Ctrl+O → Enter → Ctrl+X${NC}"
    echo ""
    sleep 2
    nano .env

    # Check again after editing
    if grep -q "your_api_key_here" ".env"; then
        err ".env still has placeholder values. Fill them in and re-run."
    fi
fi

ok ".env credentials look good"

# ════════════════════════════════════════════════════════════
# STEP 5 — npm install + build
# ════════════════════════════════════════════════════════════
step 5 "Installing dependencies & building..."

npm install --silent
ok "Dependencies installed"

# Skip TypeScript type-check; use Vite directly (avoids TS18003 on fresh clones)
if npx vite build; then
    ok "Production build complete"
else
    err "Build failed — check the errors above."
fi

# ════════════════════════════════════════════════════════════
# STEP 6 — Firebase login + deploy
# ════════════════════════════════════════════════════════════
step 6 "Deploying to Firebase Hosting..."

echo ""
echo -e "  ${YELLOW}A browser window will open for Firebase login.${NC}"
echo -e "  ${YELLOW}If on a headless system, use: firebase login --no-localhost${NC}"
echo ""

# Auto-detect if running headless (no display)
if firebase projects:list &>/dev/null; then
    ok "Already logged in to Firebase"
else
    if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
        warn "No display detected — using headless login mode"
        firebase login --no-localhost
    else
        firebase login
    fi
fi

# Activate the project (fixes: No project active)
firebase use default

firebase deploy --only hosting

# ─── Done ────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║       ✓ Deployment Complete! 🎉          ║${NC}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${CYAN}Run this to refresh your terminal PATH:${NC}"
echo -e "  ${BOLD}source ~/.bashrc${NC}"
echo ""
