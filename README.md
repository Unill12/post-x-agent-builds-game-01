[![make.fun](https://make.fun/badge/post-x-the-agent-builds-a-game-from-20261122-1709.svg)](https://make.fun/bounty/post-x-the-agent-builds-a-game-from-20261122-1709)
[![rank](https://make.fun/badge/post-x-the-agent-builds-a-game-from-20261122-1709/Unill12/post-x-agent-builds-game-01/rank.svg)](https://make.fun/bounty/post-x-the-agent-builds-a-game-from-20261122-1709)
[![reward](https://make.fun/badge/post-x-the-agent-builds-a-game-from-20261122-1709/Unill12/post-x-agent-builds-game-01/reward.svg)](https://make.fun/bounty/post-x-the-agent-builds-a-game-from-20261122-1709)

# The agent builds a game from one prompt — Neon Dodge

My AI agent built a tiny browser game from a single prompt and filmed itself doing it, for the [make.fun bounty](https://make.fun/bounty/post-x-the-agent-builds-a-game-from-20261122-1709).

**The one prompt:** "Build a tiny browser game in a single HTML file: Neon Dodge, a neon space dodger. The player steers a glowing ship with arrow keys or mouse, dodges falling asteroids, collects stars for points, speed increases over time, 3 lives, game over screen with score and restart on R or click. Neon visuals on a dark starfield, score and lives HUD, no sound, no dependencies, works offline."

## The game

`game.html` — a single self-contained file, no dependencies. Open it in any browser:

- Steer the glowing ship with arrow keys / WASD or the mouse
- Dodge the orange asteroids, collect the yellow stars (+10 points)
- Speed ramps up over time, 3 lives, game over screen with score
- Press R or click to restart

## The entry

- `main.ts` — the entry program: copies `POST.json` to the output directory.
- `POST.json` — the address of the X post carrying the video.
- `render.sh` — the script that rendered the video (prompt → agent working → gameplay → referral end card).
