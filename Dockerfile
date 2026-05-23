# ===========================================================================
#  Test build for dotfiles setup
#  Tests both local (REPO_DIR set) and curl-pipe (no REPO_DIR) paths
#  Build:  make test
# ===========================================================================
FROM archlinux:latest

RUN pacman -Syu --noconfirm git

WORKDIR /repo
COPY . .

RUN git init && git config user.email test@test && git config user.name test && \
    git add -A && git commit -m "test"

# Curl-pipe path needs a copy without .git/ + git config redirect
RUN cp -a /repo /runner && rm -rf /runner/.git
RUN git config --global url."/repo".insteadOf "https://github.com/hajdylaf/dotfiles.git"

ENV SSH_EMAIL=test@example.com
ENV USER_PASS=testpass
ENV ROOT_PASS=rootpass
ENV NEW_USER=testuser

# === Test 1: curl-pipe path (no REPO_DIR → mktemp + git clone) ===
RUN bash /runner/setup.sh && cp -r /runner/tests /opt/tests && bash /opt/tests/run-tests.sh

# === Test 2: local path (REPO_DIR set → direct) ===
ENV REPO_DIR=/repo
RUN bash /repo/setup.sh && bash /repo/tests/run-tests.sh

CMD ["/bin/zsh"]
