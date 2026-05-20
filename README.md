# 🎮 Makefile Games

A collection of terminal games implemented entirely in GNU Make. No compilation needed — just `make` and play!

## Quick Start

```bash
git clone https://github.com/erwann/makefile-games.git
cd makefile-games
make            # Launch interactive game menu
```

## Screenshot

```
  ┌─────────────────────────────────────┐
  │        🎮  G A M E   M E N U       │
  └─────────────────────────────────────┘

   #  Game
  ───────────────────────────────────
   1) 🔴 Connect 4 — four in a row
   2) 🔢 Guess the number (1-100)
   3) 🪢 Hangman — guess the word
   4) 🔮 Mastermind — crack the code
   5) 🌤️  Show weather forecast
   6) 💣 Minesweeper
   7) 🧠 Quizz — Solo trivia
   8) 📦 Sokoban — push boxes onto targets
   9) ❌ Tic-Tac-Toe vs computer
  10) 🟩 Wordle — guess the 5-letter word
  ───────────────────────────────────
   0) 🚪  Quit

  Choose a game (0-10):
```

## Games

| # | Game | Command | Description |
|---|------|---------|-------------|
| 🔴 | [Connect 4](connect4/) | `make connect4` | Four in a row vs AI (minimax) |
| 🔢 | [Guess](guess/) | `make guess` | Guess a number between 1 and 100 |
| 🪢 | [Hangman](hangman/) | `make hangman` | Guess the word before you're hanged |
| 🔮 | [Mastermind](mastermind/) | `make mastermind` | Crack the secret color code |
| 🌤️ | [Meteo](meteo/) | `make meteo` | Weather forecast (via wttr.in) |
| 💣 | [Minesweeper](minesweeper/) | `make minesweeper` | Classic minesweeper grid |
| 🧠 | [Quizz](quizz/) | `make quizz` | Solo trivia with 5 questions |
| 📦 | [Sokoban](sokoban/) | `make sokoban` | Push boxes onto targets |
| ❌ | [Tic-Tac-Toe](tictactoe/) | `make tictactoe` | Play against the computer |
| 🟩 | [Wordle](wordle/) | `make wordle` | Guess the 5-letter word in 6 tries |

## Requirements

- **GNU Make** (pre-installed on macOS/Linux)
- **curl** — required by Quizz and Meteo
- **jq** — required by Quizz
- **uuidgen** — required by Quizz

## Options

Some games accept configuration variables:

```bash
# Minesweeper
make minesweeper ROWS=10 COLS=10 MINES=15

# Mastermind
make mastermind PEGS=5 COLORS=8 MAX_ATTEMPTS=12

# Sokoban
make sokoban LEVEL=3

# Meteo
make meteo CITY=London DAYS=1 WLANG=fr

# Quizz
make quizz AMOUNT=10 DIFFICULTY=hard CATEGORY=19
```

## Adding a New Game

The menu auto-discovers games. Just:

1. Create a folder: `mkdir mygame`
2. Add a `Makefile` with a `play` target:
   ```makefile
   include ../common-help.mk

   .PHONY: play clean

   play: ## 🕹️ My awesome game
   	@echo "Hello from my game!"

   clean: ## Reset game state
   	@echo "Cleaned!"
   ```
3. That's it! The game appears in the menu automatically.

## Utilities

```bash
make help    # Show all available targets
make clean   # Reset all game states
```

## License

This project is licensed under the [MIT License](LICENSE).

