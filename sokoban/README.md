# 📦 Sokoban

Classic box-pushing puzzle game, implemented in GNU Make.

## How to Play

```bash
make play           # Start level 1
make play LEVEL=3   # Start at level 3
```

## Screenshot

```
  ┌─────────────────────────────────┐
  │       S O K O B A N             │
  │    Push boxes onto targets!      │
  └─────────────────────────────────┘

  Controls: W/A/S/D = move, R = restart, Q = quit

  ────────────────────
  Level: 2  Moves: 3

  ████████████
  ██        ██
  ██  😀◉ ✦ ██
  ██    ◉ ✦ ██
  ██        ██
  ████████████

  Move: _
```

## Controls

| Key | Action |
|-----|--------|
| `W` | Move up |
| `A` | Move left |
| `S` | Move down |
| `D` | Move right |
| `R` | Restart level |
| `Q` | Quit |

## Legend

| Symbol | Meaning |
|--------|---------|
| 😀 | Player |
| ◉ | Box |
| ✦ | Target |
| ◈ | Box on target |
| ██ | Wall |

## Levels

5 levels of increasing difficulty:
1. **Tutorial** — 1 box, straight push
2. **Pair** — 2 boxes, simple alignment
3. **Divider** — 2 boxes separated by a wall
4. **Vertical** — 2 boxes, push up and down
5. **Quad** — 4 boxes, requires planning

All levels are verified solvable!
