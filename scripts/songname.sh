#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

source "$CURRENT_DIR/helpers.sh"

get_songname() {
  local songname=$(jq -r '.item.name' $CURRENT_DIR/../response.json)
  echo $songname > /tmp/songname.txt
  printf "$songname"
}

main() {
  get_songname
}

main
