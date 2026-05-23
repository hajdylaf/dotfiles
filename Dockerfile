# ===========================================================================
#  Test build for dotfiles setup
#  Simulates curl | sh — exercises mktemp + git clone path
#  Build:  make test
# ===========================================================================
FROM archlinux:latest

RUN pacman -Syu --noconfirm git

WORKDIR /repo
COPY . .

# Init a local git repo as the clone source
RUN git init && git config user.email test@test && git config user.name test && \
    git add -A && git commit -m "test"

# Create a copy without .git/ so setup.sh takes the curl-pipe path (no REPO_DIR, no local clone)
RUN cp -a /repo /runner && rm -rf /runner/.git

# Redirect the git clone URL in setup.sh to our local repo
RUN git config --global url."/repo".insteadOf "https://github.com/hajdylaf/dotfiles.git"

ENV SSH_EMAIL=test@example.com
ENV USER_PASS=testpass
ENV ROOT_PASS=rootpass
ENV NEW_USER=testuser

# No REPO_DIR set — forces the curl-pipe code path (mktemp + git clone)
RUN bash /runner/setup.sh

# Run tests (copy from /runner since the temp clone was cleaned up)
RUN cp -r /runner/tests /opt/tests && bash /opt/tests/run-tests.sh

CMD ["/bin/zsh"]
