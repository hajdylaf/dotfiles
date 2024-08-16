ZDOTDIR=$HOME/.zsh

# >>> PLUGINS >>>
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source $ZDOTDIR/plugins/zsh-you-should-use/you-should-use.plugin.zsh
# <<< PLUGINS <<<

# >>> visual editing >>>
export EDITOR=nvim
export VISUAL=nvim
export KEYTIMEOUT=1
bindkey -v
bindkey "^?" backward-delete-char
bindkey "^R" history-incremental-search-backward
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd " " edit-command-line
# change cursor color on vi mode change
zle-keymap-select () {
    if [ $KEYMAP = vicmd ]; then
        echo -ne "\033]12;Yellow1\007"
    else
        echo -ne "\033]12;White1\007"
    fi
}
zle -N zle-keymap-select
zle-line-init () {
    zle -K viins
    echo -ne "\033]12;White1\007"
}
zle -N zle-line-init
# <<< visual editing <<<

# >>> history settings >>>
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE=~/.zsh/.zsh_history
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt +o nomatch 		 # Remove globbing warning when no matches are found.
# <<< history settings <<<

# >>> aliases >>>
if [ -f "$ZDOTDIR/.zsh_aliases" ]; then
    . "$ZDOTDIR/.zsh_aliases"
fi
# <<< aliases <<<

# >>> private bin >>>
if [ -d "$HOME/.local/bin" ]; then
    PATH="$PATH:$HOME/.local/bin"
fi
# <<< private bin <<<

# >>> syntax colors <<<
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=green,standout
ZSH_HIGHLIGHT_STYLES[alias]=fg=green
ZSH_HIGHLIGHT_STYLES[builtin]=fg=green
ZSH_HIGHLIGHT_STYLES[function]=fg=green
ZSH_HIGHLIGHT_STYLES[command]=fg=green
ZSH_HIGHLIGHT_STYLES[precommand]=fg=214
ZSH_HIGHLIGHT_STYLES[commandseparator]=green
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
ZSH_HIGHLIGHT_STYLES[path]=fg=cyan
ZSH_HIGHLIGHT_STYLES[globbing]=fg=magenta
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,standout
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=green
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=green
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[assign]=none
# <<< syntax colors <<<

# >>> OTHER >>>
# ask for ssh password only at zsh session start
eval `keychain --agents ssh --eval id_rsa`
# Starship Prompt Theme
eval "$(starship init zsh)"
export PATH=$PATH:$HOME/.local/share/USalign/
source /etc/profile.d/modules.sh
# <<< OTHER <<<
