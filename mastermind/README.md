# 🔮 Mastermind

Crack the secret color code, implemented in GNU Make.

## How to Play

```bash
make play
```

## Screenshot

```
  ┌─────────────────────────────────┐
  │     M A S T E R M I N D         │
  │     Crack the secret code!       │
  └─────────────────────────────────┘

  4 pegs, 6 colors, 10 attempts

  Colors:  ●=1  ●=2  ●=3  ●=4  ●=5  ●=6
  Feedback: ◆ = right color & position  ◇ = right color, wrong position

  ● ● ● ●  │ ◆◇
  ● ● ● ●  │ ◆◆◇
  ● ● ● ●  │ ◆◆◆◆  ← WIN!

  Attempt 3 / 10
  Your guess (4 digits, 1-6): _
```

## Options

| Variable | Default | Description |
|----------|---------|-------------|
| `PEGS`   | 4       | Code length |
| `COLORS` | 6       | Number of colors |
| `MAX_ATTEMPTS` | 10 | Max guesses |

```bash
make play PEGS=5 COLORS=8 MAX_ATTEMPTS=12
```

## Rules

- The computer generates a secret code
- Enter your guess as digits (e.g., `1234`)
- Feedback after each guess:
  - **◆** — correct color in the correct position
  - **◇** — correct color but wrong position
- Crack the code before running out of attempts!
