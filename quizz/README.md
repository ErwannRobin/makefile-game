# 🧠 Quizz — Solo Trivia

A trivia game powered by an external API, implemented in GNU Make.

## How to Play

```bash
make play
```

## Screenshot

```
  ┌─────────────────────────────────┐
  │       W A   Q U I Z Z           │
  │         Solo Trivia             │
  └─────────────────────────────────┘

  Question 1 / 5
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  What is the largest planet in our solar system?

  [A] Saturn
  [B] Jupiter
  [C] Neptune
  [D] Mars

  Your answer (A/B/C/D): B
  → Answer submitted, waiting for results…

  ✓ Correct! (Score: 1500)
```

## Features

- 5 trivia questions per game
- Multiple choice (A/B/C/D)
- Score tracking
- HTML entity decoding for special characters
- Powered by external trivia API

## Requirements

- `curl` — for API calls
- `jq` — for JSON parsing
