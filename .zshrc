# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
# eval "$(ssh-agent -s)"
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)

source $ZSH/oh-my-zsh.sh

# Example: bold green text
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
# Example: light grey (color 8 from 256-color palette)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
# Prioritize history, then fall back to completion
ZSH_AUTOSUGGEST_STRATEGY=(completion history)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1 # Disable pyenv-virtualenv's default prompt modification
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"

# --- Cached Python Environment Information ---
# Initialize a global variable to store the Python environment info for the prompt.
_pyenv_cached_info=""

# Function to update the cached Python environment information.
# This version directly queries pyenv for its active version.
function _update_pyenv_prompt_info() {
  # Get the currently active pyenv version as seen by `pyenv`.
  # `pyenv version --bare` outputs the current active environment name (e.g., 'UNIBS'),
  # or 'system', 'global', or 'none' if no specific virtualenv is active.
  # We redirect stderr to null to suppress any error messages if pyenv isn't fully ready.
  local active_pyenv_version="$(pyenv version --bare 2>/dev/null)"

  if [[ -n "$active_pyenv_version" && "$active_pyenv_version" != "system" && "$active_pyenv_version" != "none" ]]; then
    # If a specific pyenv virtual environment is active, display its name.
    _pyenv_cached_info=" %F{blue}(${active_pyenv_version})%f"
  else
    # Otherwise, clear the cached info.
    _pyenv_cached_info=""
  fi
}

# Add functions to the chpwd hook.
# `typeset -gU chpwd_functions` must be declared only once.
# We add `_chpwd_debug_check` first to see the state before our update.
# Remember: `pyenv virtualenv-init -` will have added its own `chpwd` function *before* these lines
# because of their order in your .zshrc.
typeset -gU chpwd_functions
# chpwd_functions+=( _chpwd_debug_check )      # Add our new debug function
chpwd_functions+=( _update_pyenv_prompt_info ) # Add our update function

# Call _update_pyenv_prompt_info once when the shell starts for initial prompt state.
_update_pyenv_prompt_info

# --- Your Custom Prompt Definition (the one that worked for display) ---
PROMPT=$'\n%B%F{green}%n%f%b | %F{blue}%c%f %$_pyenv_cached_info \n󱞩 '
RPROMPT=$'%{%F{white}%}%D{%H:%M}%k'
# ==================================

bindkey -v


