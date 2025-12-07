#!/bin/sh
printf '\033c\033]0;%s\a' MinimalServer
base_path="$(dirname "$(realpath "$0")")"
"$base_path/minimal_server.x86_64" "$@"
