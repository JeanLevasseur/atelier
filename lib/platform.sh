# lib/platform.sh

_os_id() {
    case "$(uname -s)" in
        Darwin)
            printf '%s\n' "macos"
            ;;
        Linux)
            if [ -r /etc/os-release ]; then
                . /etc/os-release
            elif [ -r /usr/lib/os-release ]; then
                . /usr/lib/os-release
            else
                return 1
            fi

            printf '%s\n' "$ID"
            ;;
        *)
            return 1
            ;;
    esac
}

validate_os() {
    expected_os="$1"

    current_os="$(_os_id)" || {
        echo "Unable to determine the operating system." >&2
        exit 1
    }

    if [ "$current_os" != "$expected_os" ]; then
        echo "This bootstrap requires $expected_os; detected $current_os." >&2
        exit 1
    fi
}
