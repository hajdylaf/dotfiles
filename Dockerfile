# ===========================================================================
#  Test build for dotfiles setup
#  Two stages: curl-pipe (no REPO_DIR) and local (REPO_DIR set)
#  Pick one: docker build --target curl-pipe  or  --target local
#  Run both: make test
# ===========================================================================
FROM archlinux:latest AS base

RUN pacman -Syu --noconfirm git

WORKDIR /repo
COPY . .

RUN git init && git config user.email test@test && git config user.name test && \
    git add -A && git commit -m "test"

ENV SSH_EMAIL=test@example.com
ENV USER_PASS=testpass
ENV ROOT_PASS=rootpass
ENV NEW_USER=testuser

# --- Curl-pipe test (no REPO_DIR → mktemp + git clone) ---
FROM base AS curl-pipe

RUN cp -a /repo /runner && rm -rf /runner/.git
RUN git config --global url."/repo".insteadOf "https://github.com/hajdylaf/dotfiles.git"

RUN bash /runner/setup.sh && cp -r /runner/tests /opt/tests && bash /opt/tests/run-tests.sh

CMD ["/bin/zsh"]

# --- Local test (REPO_DIR set → direct) ---
FROM base AS local

ENV REPO_DIR=/repo

RUN bash /repo/setup.sh && bash /repo/tests/run-tests.sh

CMD ["/bin/zsh"]
