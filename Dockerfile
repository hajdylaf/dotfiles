# ===========================================================================
#  Test build for dotfiles setup
#  Build:  docker build -t dotfiles-test .
#  Verify it succeeds — all RUN checks are inside the image.
# ===========================================================================
FROM archlinux:latest

# Pacman init + git needed to clone (if fallback path is hit)
RUN pacman -Syu --noconfirm git

WORKDIR /opt/dotfiles
COPY . .

# Non-interactive mode via environment variables
ENV NEW_USER=testuser
ENV USER_PASS=testpass
ENV ROOT_PASS=rootpass
ENV SSH_EMAIL=test@example.com
ENV REPO_DIR=/opt/dotfiles

RUN bash setup.sh

# ── Verify everything is in place ──────────────────────────────────────────
RUN echo "=== Verifying setup ===" && \
    id testuser && echo "PASS: user exists" && \
    sudo -l -U testuser 2>&1 | grep -E "\(ALL.*ALL\)" && echo "PASS: user can sudo (wheel)" && \
    cat /etc/sudoers.d/99-dotfiles && \
    grep -q "^%wheel.*ALL=(ALL:ALL) ALL" /etc/sudoers.d/99-dotfiles && \
    echo "PASS: sudo drop-in present" && \
    [ -d /home/testuser/.oh-my-zsh ] && echo "PASS: oh-my-zsh installed" && \
    [ -f /home/testuser/.ssh/id_ed25519 ] && echo "PASS: SSH key exists" && \
    [ -f /home/testuser/.ssh/id_ed25519.pub ] && echo "PASS: SSH pubkey exists" && \
    [ -f /home/testuser/.zshrc ] && echo "PASS: .zshrc synced" && \
    [ -f /home/testuser/.tmux.conf ] && echo "PASS: .tmux.conf synced" && \
    [ -f /home/testuser/.gitconfig ] && echo "PASS: .gitconfig synced" && \
    [ -x /home/testuser/.local/bin/frm ] && echo "PASS: frm script executable" && \
    [ -x /home/testuser/.local/bin/rmtrail ] && echo "PASS: rmtrail script executable" && \
    [ -x /home/testuser/.local/bin/update ] && echo "PASS: update script executable" && \
    command -v yay && echo "PASS: yay installed" && \
    command -v nvim && echo "PASS: neovim installed" && \
    command -v zsh && echo "PASS: zsh installed" && \
    command -v bat && echo "PASS: bat installed" && \
    command -v fzf && echo "PASS: fzf installed" && \
    command -v tmux && echo "PASS: tmux installed" && \
    echo "" && \
    echo "====================================" && \
    echo "#      ALL TESTS PASSED            #" && \
    echo "===================================="

CMD ["/bin/zsh"]
