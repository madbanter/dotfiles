# Environment variables
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
#export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export EDITOR=$(which mvim)
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
[ -x "$(command -v npm)" ] && export NODE_PATH=`npm root -g`

# Internal variables
me=$(whoami)

# OpenColorIO
export OCIO=/Users/$me/.config/OCIO/OpenColorIO-Configs/aces_1.2/config.ocio

# Terminal settings
set -o vi

# Fzf settings
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Powerline setup
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
if [ -f /usr/local/lib/python3.9/site-packages/powerline/bindings/bash/powerline.sh ]
then
	powerline_script="/usr/local/lib/python3.9/site-packages/powerline/bindings/bash/powerline.sh"
else
	powerline_script=$(pip3 show powerline-status | grep Location | sed 's/Location: //g')/powerline/bindings/bash/powerline.sh
	echo WARNING: powerline.sh script not found at /usr/local/lib/python3.9/site-packages/powerline/bindings/bash/powerline.sh
	echo Checking current install location.
fi
. $powerline_script

# Aliases
alias tq='python3 /Users/$me/Documents/Python/Scripts/text_quote.py'

alias getnumbers='python3 /Users/$me/Documents/Python/Scripts/get_numbers_clipboard.py'

alias getnames='python3 /Users/$me/Documents/Python/Scripts/get_names_clipboard.py'

alias vim='mvim -v'

alias vi='mvim -v'

alias ls='ls -GFh'

alias ogrip='youtube-dl -o "/users/$me/Downloads/%(title)s.%(ext)s" -f bestaudio[ext=m4a] $1 --prefer-ffmpeg --embed-thumbnail --metadata-from-title "%(artist)s - %(title)s" --add-metadata'

alias rip='yt-dlp -o "/users/$me/Downloads/%(title)s.%(ext)s" -f bestaudio[ext=m4a] $1 --prefer-ffmpeg --embed-thumbnail --metadata-from-title "%(artist)s - %(title)s" --add-metadata'

alias saferip='youtube-dl -o "/users/$me/Downloads/%(title)s.%(ext)s" -f bestaudio[ext=m4a] $1 --prefer-ffmpeg --embed-thumbnail'

alias gpom='git push origin master'

alias gpo='git push origin $(git branch --show-current)'

alias ga='git add -A && git commit -m'

# Functions
addalias() { alias "$1"="${*:2}" ; echo alias "$1"=\'"${*:2}"\' >> ~/.bash_profile ; echo -e '\n' >> ~/.bash_profile ; }

rewrap() { filename="$@" ; namestem="$(basename "$filename" | sed 's/\(.*\)\..*/\1/')" ; ffmpeg -hide_banner -hwaccel auto -i "$filename" -c copy -movflags +faststart "$namestem"_rewrap.mov ; }

pix720() { filename="$@" ; namestem="$(basename "$filename" | sed 's/\(.*\)\..*/\1/')" ; ffmpeg -hide_banner -hwaccel auto -i "$filename" -vcodec libx264 -profile:v high -preset medium -b:v 2400000 -vf "scale='min(iw,1280)':-1" -acodec aac -g 6 -pix_fmt yuv420p -movflags +faststart "$namestem"_720.mov ; }

pix1080() { filename="$@" ; namestem="$(basename "$filename" | sed 's/\(.*\)\..*/\1/')" ; ffmpeg -hide_banner -hwaccel auto -i "$filename" -vcodec libx264 -profile:v high -preset medium -b:v 8000000 -vf "scale='min(iw,1920)':-1" -acodec aac -g 6 -pix_fmt yuv420p -movflags +faststart "$namestem"_1080.mov ; }

flac2mp3() { filename="$@" ; namestem="$(basename "$filename" | sed 's/\(.*\)\..*/\1/')" ; ffmpeg -hide_banner -i "$filename" -ab 320k -map_metadata 0 -id3v2_version 3 "$namestem.mp3" ; }

flac2mp3dir() { cd "$@" ; for input in *.flac ; do flac2mp3 "$input" ; done }

cd() { builtin cd "$@"; ls; }

#   cdf:  'Cd's to frontmost window of MacOS Finder
#   ------------------------------------------------------
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd $currFolderPath"
        cd "$currFolderPath"
    }

#   jt: 'Cd's to item's parent directory
#   ------------------------------------------------------
jt() { cd "$(dirname "$@")" ; }

#   jtt: jt's to last argument from previous command
#   ------------------------------------------------------
jtt() { jt "$_" ; }

