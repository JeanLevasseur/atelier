# Shows notification on your device with Secure ShellFish installed
# optionally opening URL or running Shortcut when notification is
# opened.
#
# This command sends encrypted data through push notifications such
# that it doesn't need to run from a Secure ShellFish terminal.
#
# put this file inside $HOME/.config/fish/functions

function notify
  if not set -q argv[1]
    echo 'Usage: notify [--shortcut NameOfShortcut] [--url https://url.to.open/] [title] <body> ...'
  else
    set --local key ebff034baffaf85350ab67def4efbd5067690adc1588e76201452c41cbec48e2
    set --local user U1xXZLieey6GTyytm1aVMt0sDNfUiX7o4ZvmGiek
    set --local iv ab5bbeb426015da7eedcee8bee3dffb7

    set plain "$(
      echo Secure ShellFish Notify 1.0
      for arg in $argv
        echo "$arg"
      end
    )"
    set --local base64 $(echo "$plain" | openssl enc -aes-256-cbc -base64 -K $key -iv $iv)
    curl -sS -X POST -H "Content-Type: text/plain" --data "$base64" "https://secureshellfish.app/push/?user=$user"

  end
end
