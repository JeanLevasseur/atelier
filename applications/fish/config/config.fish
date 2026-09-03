if status is-interactive
    # Setup less history file
    if set -q XDG_STATE_HOME
        set -gx LESSHISTFILE "$XDG_STATE_HOME/lesshst"
    else
        set -gx LESSHISTFILE "$HOME/.local/state/lesshst"
    end

    # Setup homebrew if present
    if test -d /opt/homebrew/bin
        fish_add_path /opt/homebrew/bin
    end

    if command -q brew
        set -gx HOMEBREW_NO_ENV_HINTS true
    end

    # Disable greeting message
    set -g fish_greeting

    # Aliases
    alias la 'ls -a'
    alias ll 'ls -l'

    # Color theme
    fish_config theme choose catppuccin-mocha
end
