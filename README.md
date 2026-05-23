# dotfiles

My configuration files for Arch Linux, ZSH and other tools.

1) Install deps (root):

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/hajdylaf/dotfiles/refs/heads/main/install.sh)"
```

2) Create user with sudo:

```sh
useradd -G wheel -m user
passwd user
su user
cd
```

3) Install Oh-my-zsh:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

4) Sync dotfiles:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/hajdylaf/dotfiles/refs/heads/main/sync.sh)"
```

5) Set up SSH key:

```sh
ssh-keygen -t ed25519 -C "your_email@example.com"
```
