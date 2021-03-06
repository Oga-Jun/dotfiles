# vim like keybindings
bindkey -v

# Entering to vim-cmd-mode by pressing 'jk'
bindkey 'jk' vi-cmd-mode

# reset vi keybind for specific keys.
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# history search by inputted cmd name
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^[OA" history-search-backward
bindkey "^[OB" history-search-forward

# Interactive selection
zmodload zsh/complist # load to set menuselect key bindings
bindkey -M menuselect '\t' forward-char
bindkey -M menuselect '^l' forward-char
bindkey -M menuselect '^j' down-line-or-history
bindkey -M menuselect '^k' up-line-or-history
bindkey -M menuselect '^h' backward-char

# Enable using commnd stack by pressing C-q
show_buffer_stack() {
    POSTDISPLAY="
    stack: $LBUFFER"
      zle push-line-or-edit
    }
zle -N show_buffer_stack
bindkey '^Q' show_buffer_stack

function select-history() {
  BUFFER=$(\history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history
