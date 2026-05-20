# 💣 Minesweeper

Classic Minesweeper with flood-fill reveal and flag system, implemented in GNU Make.

## How to Play

```bash
make play
```

## Screenshot

```
  ┌──────────────────────────────────┐
  │        M I N E S W E E P E R     │
  └──────────────────────────────────┘

     1  2  3  4  5  6  7  8
  1  .  .  .  .  .  .  .  .
  2  .  .  .  .  .  .  .  .
  3  .  1  1  1  .  .  .  .
  4  .  1     1  1  1  1  .
  5  .  1     1  1  🚩 .  .
  6  .  1  1  2  .  .  .  .
  7  .  .  .  .  .  .  .  .
  8  .  .  .  .  .  .  .  .

  Action (r=reveal, f=flag) [r/f row col]: _
```

## Options

| Variable | Default | Description |
|----------|---------|-------------|
| `ROWS`   | 8       | Grid height |
| `COLS`   | 8       | Grid width  |
| `MINES`  | 10      | Number of mines |

```bash
make play ROWS=10 COLS=10 MINES=15
```

## Rules

- Reveal cells to find safe squares
- Numbers indicate adjacent mines
- Flag cells you think contain mines
- Reveal a mine = game over!
- Clear all non-mine cells to win
