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
RUN bash tests/run-tests.sh

CMD ["/bin/zsh"]
