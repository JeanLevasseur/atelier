# put this file inside $HOME/.config/fish/functions

function sharesheet
  if not set -q argv[1]
    if isatty
      echo Usage: sharesheet [FILE]...
      echo
      echo Present share sheet for files and directories.
      echo Alternatively you can pipe in text and call it without arguments.
      echo
      echo If arguments exist inside the Finder or Files app changes made are written back to the server.
      return 0
    end
  end

  set FIFO $(mktemp)
  rm -f $FIFO
  mkfifo $FIFO
 
  if test "$TMUX" = ""
    printf "\033]"
  else
    printf "\033Ptmux;\033\033]"
  end
 
  printf "6;sharesheet://?ver=2&respond="
  echo -n "$FIFO" | base64
  printf "&pwd="
  echo -n "$PWD" | base64
  printf "&home="
  echo -n "$HOME" | base64
  if count $argv > /dev/null
    for var in $argv
      awk 'BEGIN {printf "&path="}'
      echo -n "$var" | base64
    end
  else
    printf "&text="
    while read line
      echo -n "$line" | base64
    end
  end

  if test "$TMUX" = ""
    printf "\a"
  else
    printf "\a\033\\"
  end
 
  read <$FIFO -s REPLY
  rm -f $FIFO
  
  if test -z "$REPLY"
    return 0
  end

  if string match -q "error=*" "$REPLY"
    echo (string replace -r "^error=" "" "$REPLY") | base64 -d
    return 1
  end
  
  if string match -q "result=*" "$REPLY"
    echo (string replace -r "^result=" "" "$REPLY") | base64 -d
  end
end
