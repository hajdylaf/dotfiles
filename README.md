# dotfiles

My configuration files for ArchLinux WSL, ZSH and other tools. Setup guide:

1) Install WSL (Powershell):

```powershell
wsl --install -d ArchLinux --location E:/
```

2) Install deps (bash as root):

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/hajdylaf/dotfiles/refs/heads/main/install.sh)"
```

3) Create user with sudo:

```sh
useradd -G wheel -m user
passwd user
su user
```

```sh
cd $HOME
```

4) Install Oh-my-zsh:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

5) Sync dotfiles:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/hajdylaf/dotfiles/refs/heads/main/sync.sh)"
```

5) Set up SSH key:

```sh
ssh-keygen -t ed25519 -C "your_email@example.com"
```

6) Set default WSL user (Powershell)

```powershell
wsl --manage ArchLinux --set-default-user user
```
