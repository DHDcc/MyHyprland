blue="\033[1;34m"
pink="\033[0;35m"
red="\033[1;31m"
gray="\033[0;90m"
colorOff="\033[0m"
info() {
  echo -e "${blue}info:${colorOff} $1";
}
error() {
  echo -e "${red}error:${colorOff} $1";
}

usage() {
  echo -e "$blue{type}"
  echo -e " screenshot $gray(default)$blue"
  echo " video"
  echo ""
  echo -e "$pink--selection"
  echo "--audio"
  echo -e "--help$colorOff"
}
if [[ "$1" == "--help" ]]; then
  usage
  exit 0
fi

video=false
selection=false
audio=false
while [[ $# -gt 0 ]]; do 
  case $1 in
    screenshot) shift ;;
    video) video=true; shift ;;
    --selection) selection=true; shift ;;
    --audio) audio=true; shift ;;
    *)
      error "Unknown argument: $1";
      exit 1;;
  esac
done

selectArea() {
  local appData=~/.config/system-ui/app-data.json
  local color=$(grep -oP '(?<="primary_40":")[^"]+' $appData)
  area=$(slurp -b "${color}40" -w 0)
}

recording=true
recordFile="/tmp/recording.mp4"
stopRecording() {
  recording=false
  echo ""
  if killall --signal SIGINT wf-recorder &> /dev/null; then
    info "Screen record saved: $recordFile"
  else
    error "No screen record running."
  fi
}
record() {
  local command="yes | wf-recorder -f $recordFile"
  if $selection; then
    selectArea
    command+=" -g \"$area\""
  fi
  if $audio; then command+=' --audio="$(pactl get-default-sink).monitor"'; fi
  command+=" &>/dev/null & disown"
  eval $command

  trap stopRecording EXIT
  
  local seconds=0
  while $recording; do
    printf "\r${red}Recording screen %02d:%02d$colorOff" $((seconds/60)) $((seconds%60))
    sleep 1
    ((seconds++))
  done
}

screenshot() {
  local file=/tmp/screenshot.png

  if $selection; then
    selectArea
  else
    grim $file
  fi
  wl-copy < $file
}

if $video
then record
else screenshot
fi
