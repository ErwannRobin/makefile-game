# 🎮 Makefile Games

A collection of terminal games implemented entirely in GNU Make. No compilation needed — just `make` and play!

## Games

| Game | Command | Description |
|------|---------|-------------|
| 🔢 Guess | `make guess` | Guess a random number between 1 and 100 |
| 🧠 WaQuizz | `make waquizz` | Solo trivia quiz with 5 questions |

## Quick Start

```bash
git clone https://github.com/erwann/makefile-games.git
cd makefile-games
make help    # Show available games
make guess   # Play the number guessing game
make waquizz # Play the trivia game
```

## Requirements

- **GNU Make** (pre-installed on macOS/Linux)
- **WaQuizz** additionally requires: `curl`, `jq`, `uuidgen`

## WaQuizz Options

```bash
make waquizz AMOUNT=10          # 10 questions
make waquizz DIFFICULTY=hard    # hard | medium | easy
make waquizz CATEGORY=19       # See categories below
make waquizz DEBUG=1            # Verbose curl logging
```

**Categories:** `all` | `9` General | `17` Science | `19` Math | `21` Sports | `23` History | `27` Animals

## Project Structure

```
makefile-games/
├── Makefile          ← Game menu
├── common-help.mk   ← Shared colors & auto-generated help
├── guess/
│   └── Makefile      ← Number guessing game
└── waquizz/
    └── Makefile      ← Trivia game (WaQuizz API)
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
