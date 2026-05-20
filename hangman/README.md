# 🪢 Hangman

Classic word guessing game with ASCII art gallows, implemented in GNU Make.

## How to Play

```bash
make play
```

## Screenshot

```
  ┌─────────────────────────────┐
  │       H A N G M A N         │
  └─────────────────────────────┘

    ┌───┐
    │   O
    │  /│\
    │
    │
  ──┴──

  Word:  _ _ _ _ _ _

  Guessed: A, E, R, S
  Lives: ❤️ ❤️ ❤️

  Your guess (a-z): _
```

## Rules

- Guess one letter at a time
- You have 6 lives (wrong guesses)
- The gallows builds up with each wrong guess
- Find the word before the hangman is complete!

## Word List

The game includes 30 built-in words. No external dependencies needed.
