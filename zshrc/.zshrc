alias ls="eza --color=always --long --header --icons"
alias grep='grep --color=always'
export BAT_THEME="ansi"

export EDITOR="code --wait"

# Fuzzy find a file or directory recursively from the current path.
ff() {
  # Use fd to find all files/dirs, then pipe to fzf with a smart preview.
  local selection
  selection=$(fd --hidden --follow --exclude .git --exclude node_modules . | fzf --ansi --height '50%' --preview '
    if [ -d {} ]; then
      # If the selection is a directory, show its contents with eza
      eza --tree --level=1 --color=always --icons {}
    else
      # If it is a file, show a syntax-highlighted preview with bat
      bat --color=always --style=numbers --line-range :200 {}
    fi'
  ) || return

  # Print the selection to standard output
  if [[ -n "$selection" ]]; then
    echo "$selection"
  fi
}

fj() {
  local dir
  dir=$(eza --only-dirs --oneline | fzf --ansi --height '40%' --preview 'eza -l --color=always --icons {}') || return
  if [[ -n "$dir" ]]; then
    cd -- "$dir"
  fi
}

fo() {
  # Use fd to find files (excluding common junk), then pipe to fzf for selection.
  # The preview uses 'bat' for syntax-highlighted previews.
  local file
  file=$(fd --type f --hidden --follow --exclude .git --exclude node_modules . | fzf --ansi --height '50%' --preview 'bat --color=always --style=numbers --line-range :500 {}') || return

  # If a file was selected, open it in VS Code.
  if [[ -n "$file" ]]; then
    code -- "$file"
  fi
}

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# bun completions
[ -s "/Users/cmendez/.bun/_bun" ] && source "/Users/cmendez/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

alias cd="z"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opencode
export PATH=/Users/cmendez/.opencode/bin:$PATH

# . "$HOME/.local/bin/env"

# Lazy-load starship
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# # Lazy-load zoxide on first use of `z` command
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

function yt-mp3() {
    yt-dlp --ignore-config --sponsorblock-remove sponsor \
    -x --audio-format mp3 --audio-quality 0 \
    -o "~/Movies/YouTube-Videos/podcasts/%(title)s.%(ext)s" \
    "$@"
}

# compdef yt-mp3=yt-dlp

export PATH="$PATH:$HOME/go/bin"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
eval "$(/Users/cmendez/.local/bin/mise activate zsh)"
