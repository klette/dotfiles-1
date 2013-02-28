#!/bin/bash

# Whether or not we have a command
# http://dotfiles.org/~steve/.bashrc
have() {
  type "$1" &> /dev/null
}

# Filter through running processes
psgrep() {
  ps aux | \grep -e "$@" | \grep -v "grep -e $@"
}

# One command to rule them all
# http://dotfiles.org/~krib/.bashrc
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)  tar xjf $1      ;;
      *.tar.gz)   tar xzf $1      ;;
      *.bz2)      bunzip2 $1      ;;
      *.rar)      rar x $1        ;;
      *.gz)       gunzip $1       ;;
      *.tar)      tar xf $1       ;;
      *.tbz2)     tar xjf $1      ;;
      *.tgz)      tar xzf $1      ;;
      *.zip)      unzip $1        ;;
      *.Z)        uncompress $1   ;;
      *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# http://dotfiles.org/~krib/.bashrc
bu() {
  if [ "$(dirname $1)" == "." ]; then
    mkdir -p ~/.backup/$(pwd)
    cp $1 ~/.backup/$(pwd)/$1-$(date +%Y%m%d%H%M).backup
  else
    mkdir -p ~/.backup/$(dirname $1)
    cp $1 ~/.backup/$1-$(date +%Y%m%d%H%M).backup
  fi
}

# http://dotfiles.org/~kparnell/.bashrc
mkcdir() {
  mkdir -p $1
  cd $1
}

# Attach tmux sessions
play() {
  local session="${1:-$(hostname)}"
  [[ -n $TMUX_SOCKET_DIR ]] && socket="-S ${TMUX_SOCKET_DIR}/${session}"

  if tmux has-session -t $session; then
    tmux -2 attach-session -t $session $socket
  else
    if [[ -e ~/.tmux/sessions/$session ]]; then
      echo "No session to attach, trying to create one"; wait 1
      . ~/.tmux/sessions/$session $socket
    else
      echo "No session exist for $session, looked in ~/.tmux/sessions/$session"
    fi
  fi
}

# Sort the "du" output and use human-readable units.
# https://github.com/janmoesen/tilde/blob/master/.bash/commands
duh() {
  du -sk ${@:-*} | sort -n | while read size fname; do
    for unit in KiB MiB GiB TiB PiB EiB ZiB YiB; do
      if [ "$size" -lt 1024 ]; then
        echo -e "${size} ${unit}\t${fname}"
        break
      fi
      size=$((size/1024))
    done
  done
}

# Edit the files found with the previous "ack" command using Vim
# https://github.com/janmoesen/tilde/blob/master/.bash/commands
vack() {
  local cmd=''
  if [ $# -eq 0 ]; then
    cmd="$(fc -nl -1)"
    cmd="${cmd:2}"
  else
    cmd='ack'
    for x; do
      cmd="$cmd $(printf '%q' "$x")"
    done
    echo "$cmd"
  fi
  if [ "${cmd:0:4}" != 'ack ' ]; then
    $cmd
    return $?
  fi
  declare -a files
  while read -r file; do
    echo "$file"
    files+=("$file")
  done < <(bash -c "${cmd/ack/ack -l}")
  "${EDITOR:-vim}" "${files[@]}"
}

# Git log with per-commit clickable GitHub URLs.
# https://github.com/cowboy/dotfiles/commit/78fde838a429250e923f5611e233c6e4e942b377
gf() {
  local remote="$(git remote -v | awk '/^origin.*\(push\)$/ {print $2}')"
  [[ "$remote" ]] || return
  local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
  git log $* --name-status --color | awk "$(cat <<AWK
    /^.*commit [0-9a-f]+/ {sha=substr(\$2,1,7); printf "%s\thttps://github.com/$user_repo/commit/%s\033[0m\n", \$1, sha; next}
    /^[MA]\t/ {printf "%s\thttps://github.com/$user_repo/blob/%s/%s\n", \$1, sha, \$2; next}
    /.*/ {print \$0}
AWK
  )" | less -R
}

# Usage: dimscreen 0-100
dimscreen() {
  local max=$(cat /sys/class/backlight/acpi_video0/max_brightness)
  local amount="${1:-$max}"
  local dim=$(printf "%.0f" $(awk -v m=$max -v a=$amount 'BEGIN { print m * a / 100}'))

  sudo bash -c "for i in /sys/class/backlight/acpi_video*/brightness; do echo $dim > \$i; done"
}

toggletouch() {
  local touchpad=$(xinput list | grep 'TouchPad' | sed -e 's/.*id=\([0-9]\+\).*/\1/')
  local trackpad=$(xinput list | grep 'TrackPoint' | sed -e 's/.*id=\([0-9]\+\).*/\1/')
  local enabled=$(xinput list-props $touchpad | grep 'Device Enabled' | sed 's/.*:.\+\([01]\).*/\1/')
  ((enabled)) && local status=0 || local status=1
  xinput --set-prop $touchpad "Device Enabled" $status
  xinput --set-prop $trackpad "Device Enabled" $status
}

imageshadow() {
  local input="$1"
  local output="${2:-${input%.*}-shadow.${input#*.}}"
  convert "$input" \( +clone -background black -shadow 100x10+0+10 \) \
    +swap -background transparent -layers merge +repage "$output"
}

screenshot() {
  [[ $1 ]] && echo "Grabbing screenshot in $1 sec" && sleep $1
  local activeWindow=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)")
  local id=${activeWindow:40}
  local filename="$(date +%F_%H%M%S).png"
  import -window "$id" -frame $filename
  imageshadow $filename $filename
}

windowsize() {
  local width=${1:-640}
  local height=${2:-400}
  wmctrl -r :ACTIVE: -e 0,-1,-1,$width,$height
}

yslow() {
  [ ! -f ~/.local/lib/yslow.js ] && echo "Couldn't find yslow in ~/.local/lib/yslow.js" && return
  [[ $# -eq 1 ]] && local flags='--info grade --format tap'
  phantomjs ~/.local/lib/yslow.js $flags "$@"
}
