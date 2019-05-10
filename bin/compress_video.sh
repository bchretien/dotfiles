#!/bin/bash

display_help() {
  echo "Compress a video with ffmpeg"
  echo
  echo "Usage: $0 input_video output_video" >&2
  echo
  exit 1
}

if [ "$#" -lt 2 ]; then
    echo "Error: illegal number of parameters"
    echo
    display_help
fi

input_video=$1
output_video=$2
shift
shift

ffmpeg -y -i "$input_video" -c:v libx264 -preset medium -b:v 555k $@ \
       -pass 1 -strict -2 -f mp4 /dev/null
ffmpeg -i "$input_video" -c:v libx264 -preset medium -b:v 555k $@ \
       -pass 2 -strict -2 "$output_video"

# Remove ffmpeg files
rm ffmpeg2pass-0.log
rm ffmpeg2pass-0.log.mbtree
