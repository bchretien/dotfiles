#!/bin/bash
# See: http://superuser.com/a/556031/189806

# Generate palette
video="$1"
palette="$(mktemp --tmpdir tmp.palette.XXXXX.png)"
ffmpeg -y -i ${video} -vf fps=10,scale=320:-1:flags=lanczos,palettegen "${palette}"

# Output GIF using palette
ffmpeg -i ${video} -i ${palette} -filter_complex \
  "fps=10,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" "${2:-${video%.*}.gif}"

rm "${palette}"
