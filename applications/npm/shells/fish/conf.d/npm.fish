if status is-interactive
    if set -q XDG_CONFIG_HOME
        set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
    else
        set -gx NPM_CONFIG_USERCONFIG "$HOME/.config/npm/npmrc"
    end
end
