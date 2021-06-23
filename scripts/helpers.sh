#!/bin/bash -

TOKEN_FILE=$CURRENT_DIR/token.txt

get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value="$(tmux show-option -gqv "$option")"

    if [[ -z "$option_value" ]]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

set_tmux_option() {
    local option=$1
    local value=$2
    tmux set-option -gq "$option" "$value"
}

make_request() {
  local token=$(head -1 $TOKEN_FILE)
  curl -X "GET" "https://api.spotify.com/v1/me/player/currently-playing?market=ES" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $token" -o $CURRENT_DIR/response.json
}
