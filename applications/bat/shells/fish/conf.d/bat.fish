if status is-interactive
    if command -q brew
        set -gx HOMEBREW_BAT true
    end
end
