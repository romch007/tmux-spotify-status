#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

source "$CURRENT_DIR/helpers.sh"

get_artist() {
  local artist=$(jq -r '.item.artists[0].name' $CURRENT_DIR/../response.json)
  printf "$artist"
}

main () {
  get_artist
}

main
