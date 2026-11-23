#!/usr/bin/env bash
# Renders the entry video: prompt -> agent working -> real gameplay -> referral end card.
# 16:9, 1920x1080, 30fps, H.264 + AAC, 27.5s total. Music: royalty-free Pixabay track, looped.
# Run from the repo root. Inputs live in ~/workspace/makefun/post-x-game-video/.
set -euo pipefail

VIDEO_DIR="$HOME/workspace/makefun/post-x-game-video"
WORK="$VIDEO_DIR/work"
ASSETS="$VIDEO_DIR/assets"
OUT="$VIDEO_DIR/agent-builds-a-game.mp4"
GAME_WEBM=$(ls "$WORK"/page@*.webm | head -n 1)

echo "== segments =="
# title card: 4s
ffmpeg -y -v error -loop 1 -i "$WORK/title.png" -t 4 -vf fps=30,format=yuv420p -c:v libx264 -r 30 "$WORK/title.mp4"
# code typing: 6s from frames
ffmpeg -y -v error -framerate 30 -i "$WORK/code-%03d.png" -vf format=yuv420p -c:v libx264 -r 30 "$WORK/code.mp4"
# gameplay: skip the 1s settle, take 17.5s (15s main + 2.5s tail under the end card)
ffmpeg -y -v error -ss 1.0 -i "$GAME_WEBM" -t 17.5 -vf fps=30,format=yuv420p -c:v libx264 -r 30 "$WORK/gameplay.mp4"
# first 15s of gameplay for the base cut
ffmpeg -y -v error -i "$WORK/gameplay.mp4" -t 15 -c copy "$WORK/game-main.mp4"
# last 2.5s of gameplay for the end-card tail
ffmpeg -y -v error -ss 15 -i "$WORK/gameplay.mp4" -t 2.5 -c copy "$WORK/tail-sharp.mp4"
# blurred + desaturated copy of the tail (blur ~28px, fades in over 0.8s below)
ffmpeg -y -v error -i "$WORK/tail-sharp.mp4" -vf gblur=sigma=28,eq=saturation=0.25,format=yuv420p -c:v libx264 -r 30 "$WORK/tail-blur.mp4"

echo "== base cut (25s) =="
printf "file '%s/title.mp4'\nfile '%s/code.mp4'\nfile '%s/game-main.mp4'\n" "$WORK" "$WORK" "$WORK" > "$WORK/base-list.txt"
ffmpeg -y -v error -f concat -safe 0 -i "$WORK/base-list.txt" -c copy "$WORK/base.mp4"

echo "== end-card tail (2.5s) =="
ffmpeg -y -v error -i "$WORK/tail-sharp.mp4" -i "$WORK/tail-blur.mp4" -i "$ASSETS/endcard-16x9.webm" -i "$WORK/code.png" \
  -filter_complex "[1:v]format=rgba,fade=t=in:st=0:d=0.8:alpha=1[bl];[0:v][bl]overlay=0:0[bg];[bg][2:v]overlay=0:0[card];[card][3:v]overlay=0:0" \
  -c:v libx264 -pix_fmt yuv420p -r 30 -t 2.5 "$WORK/tail.mp4"

echo "== final assembly (badge + music) =="
printf "file '%s/base.mp4'\nfile '%s/tail.mp4'\n" "$WORK" "$WORK" > "$WORK/final-list.txt"
ffmpeg -y -v error -f concat -safe 0 -i "$WORK/final-list.txt" -i "$ASSETS/badge-16x9.png" -stream_loop 1 -i "$WORK/music-v2.mp3" \
  -filter_complex "[0:v][1:v]overlay=0:0[v];[2:a]volume=0.6,atrim=0:27.5,afade=t=out:st=26:d=1.5[a]" \
  -map "[v]" -map "[a]" -c:v libx264 -pix_fmt yuv420p -r 30 -c:a aac -b:a 128k -t 27.5 "$OUT"

echo "== done =="
ffprobe -v error -show_entries format=duration,size -show_entries stream=width,height,codec_name,r_frame_rate -of default=noprint_wrappers=1 "$OUT"
ls -la "$OUT"
