#!/usr/bin/env bash
# ===========================================================================
#  dotfiles — one-shot setup for Arch Linux
#  Usage (curl pipe):  sh -c "$(curl -fsSL https://raw.githubusercontent.com/hajdylaf/dotfiles/refs/heads/main/setup.sh)"
#  Usage (local):      sudo bash setup.sh
# ===========================================================================

# ── Helpers ────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'
NC='\033[0m'
log()  { printf "${GREEN}[  OK  ]${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}[ WARN ]${NC} %s\n" "$*"; }
fail() { printf "${RED}[ FAIL ]${NC} %s\n" "$*"; exit 1; }
info() { printf "${BLUE}[ INFO ]${NC} %s\n" "$*"; }

# ── Root check ─────────────────────────────────────────────────────────────
[ "$(whoami)" = "root" ] || fail "This script must be run as root."

# ── Detect mode: local clone vs curl pipe ──────────────────────────────────
if [ -n "${REPO_DIR:-}" ]; then
    TMPDIR=""
    info "Using REPO_DIR from environment: $REPO_DIR"
elif [ -f "$(dirname "$0")/.git/HEAD" ] 2>/dev/null; then
    REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
    TMPDIR=""
    info "Running from local clone at $REPO_DIR"
else
    TMPDIR=$(mktemp -d)
    if ! command -v git &>/dev/null; then
        info "git not found, installing..."
        pacman -Syu --noconfirm --quiet git >/dev/null
    fi
    info "Fetching dotfiles repository..."
    git clone --depth 1 https://github.com/hajdylaf/dotfiles.git "$TMPDIR/dotfiles"
    REPO_DIR="$TMPDIR/dotfiles"
    cd "$REPO_DIR" || exit
fi

# Ensure repo files are traversable/readable by the user we're about to create
[ -n "$TMPDIR" ] && chmod a+rX "$TMPDIR" 2>/dev/null || true
chmod -R a+rX "$REPO_DIR" 2>/dev/null || true

# ── Input collection (everything upfront) ──────────────────────────────────
if [ -z "${NEW_USER:-}" ]; then
    echo
    echo "===================================="
    echo "#       SETUP CONFIGURATION        #"
    echo "===================================="
    echo

    read -r -p "Username [user]: " input
    NEW_USER="${input:-user}"

    while true; do
        read -r -s -p "Password for $NEW_USER: " USER_PASS; echo
        read -r -s -p "Confirm password: " confirm; echo
        [ "$USER_PASS" = "$confirm" ] && break
        echo "Passwords do not match. Try again."
    done

    read -r -s -p "Root password (leave empty to keep current): " ROOT_PASS
    export ROOT_PASS; echo
    read -r -p "Email for SSH key: " SSH_EMAIL
else
    info "Non-interactive mode — using NEW_USER=$NEW_USER"
    USER_PASS="${USER_PASS:-changeme}"
    SSH_EMAIL="${SSH_EMAIL:-test@localhost}"
fi

echo
echo "===================================="
echo "#      STARTING INSTALLATION       #"
echo "===================================="
for i in 5 4 3 2 1; do printf "%s..." "$i"; sleep 1; done; echo

# ── Run root-phase modules ─────────────────────────────────────────────────
ROOT_MODULES="00-system.sh 01-user.sh 02-yay.sh 03-packages.sh"

# shellcheck disable=SC1090,SC2218
for mod in $ROOT_MODULES; do
    source "$REPO_DIR/modules/$mod"
    module_run
done

# ── Run user-phase modules via su ──────────────────────────────────────────
info "Switching to user $NEW_USER for user-level setup..."

USER_SCRIPT="/tmp/dotfiles-user.sh"
cat > "$USER_SCRIPT" << USEREOF
#!/usr/bin/env bash
REPO_DIR="$REPO_DIR"
SSH_EMAIL="$SSH_EMAIL"
NEW_USER="$NEW_USER"

log()  { printf "\033[0;32m[  OK  ]\033[0m %s\n" "\$*"; }
warn() { printf "\033[1;33m[ WARN ]\033[0m %s\n" "\$*"; }

USER_MODULES="04-ohmyzsh.sh 05-dotfiles.sh 06-curl-installs.sh 07-ssh.sh"

for mod in \$USER_MODULES; do
    # shellcheck disable=SC1090,SC2218
    source "\$REPO_DIR/modules/\$mod"
    module_run
done
USEREOF

chmod +x "$USER_SCRIPT"
su - "$NEW_USER" -c "bash $USER_SCRIPT" || warn "User-phase setup had issues, check output above"

# ── Cleanup ────────────────────────────────────────────────────────────────
# shellcheck disable=SC1090,SC2218
source "$REPO_DIR/modules/08-cleanup.sh"
module_run

# ── Completion ─────────────────────────────────────────────────────────────
echo
echo "===================================="
echo "#      INSTALLATION COMPLETE       #"
echo "===================================="
echo
echo
