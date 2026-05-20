# 🎮 Makefile Games

A collection of terminal games implemented entirely in GNU Make. No compilation needed — just `make` and play!

## Games

| Game | Command | Description |
|------|---------|-------------|
| 🔢 Guess | `make guess` | Guess a random number between 1 and 100 |
| 🧠 Quizz | `make quizz` | Solo trivia quiz with 5 questions |
| ❌ Tic-Tac-Toe | `make tictactoe` | Play against the computer |

## Quick Start

```bash
git clone https://github.com/erwann/makefile-games.git
cd makefile-games
make help       # Show available games
make guess      # Play the number guessing game
make quizz      # Play the trivia game
make tictactoe  # Play tic-tac-toe vs CPU
```

## Requirements

- **GNU Make** (pre-installed on macOS/Linux)
- **Quizz** additionally requires: `curl`, `jq`, `uuidgen`

## Quizz Options

```bash
make quizz AMOUNT=10          # 10 questions
make quizz DIFFICULTY=hard    # hard | medium | easy
make quizz CATEGORY=19       # See categories below
make quizz DEBUG=1            # Verbose curl logging
```

**Categories:** `all` | `9` General | `17` Science | `19` Math | `21` Sports | `23` History | `27` Animals

## Project Structure

```
makefile-games/
├── Makefile          ← Game menu
├── common-help.mk   ← Shared colors & auto-generated help
├── guess/
│   └── Makefile      ← Number guessing game
├── quizz/
│   └── Makefile      ← Trivia game
└── tictactoe/
    └── Makefile      ← Tic-Tac-Toe vs computer
```

## Adding a New Game

1. Create a folder: `mkdir mygame`
2. Add a `Makefile` inside with a `play` target:
   ```makefile
   include ../common-help.mk

   .PHONY: play

   play: ## Short description of your game
   	@echo "Hello from my game!"
   ```
3. Register it in the root `Makefile`:
   ```makefile
   mygame: ## 🕹️  My awesome game
   	@$(MAKE) -C mygame --no-print-directory play
   ```

## License

This project is licensed under the [MIT License](LICENSE).
