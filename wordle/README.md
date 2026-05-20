# 🟩 Wordle

Guess the 5-letter word in 6 tries, implemented in GNU Make.

## How to Play

```bash
make play
```

## Screenshot

```
  ┌─────────────────────────────┐
  │       W O R D L E           │
  │    Guess the 5-letter word   │
  └─────────────────────────────┘

  You have 6 attempts.
  █ = correct spot  █ = wrong spot  █ = not in word

   c  r  a  n  e
   s  l  a  t  e
   _  _  _  _  _
   _  _  _  _  _
   _  _  _  _  _
   _  _  _  _  _

  Attempt 3 / 6
  Enter guess: _
```

## Rules

- Guess a valid 5-letter word each turn
- Colors indicate:
  - 🟩 **Green** — correct letter, correct position
  - 🟨 **Yellow** — correct letter, wrong position
  - ⬜ **Gray** — letter not in the word
- You have 6 attempts to find the word

## Word List

Includes 300+ common English 5-letter words. A new word is randomly selected each game.
