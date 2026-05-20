# 🔴 Connect 4

Four-in-a-row against an AI opponent with minimax strategy, implemented in GNU Make.

## How to Play

```bash
make play
```

## Screenshot

```
  ┌─────────────────────────────┐
  │     C o n n e c t   4       │
  │      You = X, CPU = O       │
  └─────────────────────────────┘

   1 2 3 4 5 6 7
  ───────────────
  | | | | | | | |
  | | | | | | | |
  | | | |O| | | |
  | | |O|X| | | |
  | |O|X|X|O| | |
  |X|X|O|X|X|O| |
  ───────────────

  Drop in column (1-7): _
```

## Features

- 7×6 board (standard Connect 4 dimensions)
- AI uses **minimax with alpha-beta pruning** (depth 4)
- CPU evaluates positions, blocks threats, and builds winning lines
- Color-coded pieces in terminal

## AI Strategy

The CPU opponent:
1. Wins immediately if possible
2. Blocks your winning moves
3. Evaluates board positions using window-based scoring
4. Prefers center columns
5. Avoids moves that give you a win above
