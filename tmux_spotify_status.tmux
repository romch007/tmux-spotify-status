#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

TOKEN_FILE=$CURRENT_DIR/token.txt

source "$CURRENT_DIR/scripts/helpers.sh"

songname_interpolation="\#{spotify_songname}"
artist_interpolation="\#{spotify_artist}"

do_interpolation() {
  local input=$1
  local result=""

  local token=$(head -1 $TOKEN_FILE)
  local response=$(curl -X "GET" "https://api.spotify.com/v1/me/player/currently-playing?market=ES" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $token")

  local songname=$(echo $response | jq -r '.item.name')
  local artist=$(echo $response | jq -r '.item.artists[0].name')

  result=${input/$songname_interpolation/$songname}
  result=${result/$artist_interpolation/$artist}
  
  echo $result
}

update_tmux_option() {
  local option=$1
  local option_value=$(get_tmux_option "$option")
  local new_option_value=$(do_interpolation "$option_value")
  set_tmux_option "$option" "$new_option_value"
}

main () {
  if [ ! -f "$TOKEN_FILE" ]; then
    tmux new-window $CURRENT_DIR/scripts/server 8000 $TOKEN_FILE
    xdg-open  "https://accounts.spotify.com/authorize?response_type=code&client_id=5c8d1e5d2a4c4187999207db11e57a95&scope=user-read-currently-playing&redirect_uri=http%3A%2F%2Flocalhost%3A8000"
  fi

  update_tmux_option "status-right"
}

main
