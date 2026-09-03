if status is-interactive
    # Disable greeting message
    set -g fish_greeting

    # Aliases
    alias la 'ls -a'
    alias ll 'ls -l'

    # Color theme
    fish_config theme choose catppuccin-mocha
end
