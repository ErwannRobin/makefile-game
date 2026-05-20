include common-help.mk

##@ Games

guess: ## 🔢 Guess the number (1-100)
	@$(MAKE) -C guess --no-print-directory play

quizz: ## 🧠 Quizz — Solo trivia game
	@$(MAKE) -C quizz --no-print-directory play

tictactoe: ## ❌ Tic-Tac-Toe vs computer
	@$(MAKE) -C tictactoe --no-print-directory play

hangman: ## 🪢 Hangman — guess the word
	@$(MAKE) -C hangman --no-print-directory play

minesweeper: ## 💣 Minesweeper
	@$(MAKE) -C minesweeper --no-print-directory play

connect4: ## 🔴 Connect 4 — four in a row
	@$(MAKE) -C connect4 --no-print-directory play

wordle: ## 🟩 Wordle — guess the 5-letter word
	@$(MAKE) -C wordle --no-print-directory play

meteo: ## 🌤️  Weather forecast
	@$(MAKE) -C meteo --no-print-directory play CITY=$(or $(CITY),Paris) DAYS=$(or $(DAYS),3) WLANG=$(or $(WLANG),en)

mastermind: ## 🔮 Mastermind — crack the code
	@$(MAKE) -C mastermind --no-print-directory play

##@ Utilities

clean: ## 🧹 Clean all game state
	@$(MAKE) -C quizz --no-print-directory clean 2>/dev/null || true
	@$(MAKE) -C tictactoe --no-print-directory clean 2>/dev/null || true
	@$(MAKE) -C hangman --no-print-directory clean 2>/dev/null || true
	@$(MAKE) -C minesweeper --no-print-directory clean 2>/dev/null || true
	@$(MAKE) -C connect4 --no-print-directory clean 2>/dev/null || true
	@$(MAKE) -C wordle --no-print-directory clean 2>/dev/null || true
	@$(MAKE) -C mastermind --no-print-directory clean 2>/dev/null || true
	@echo "All clean!"

.PHONY: guess quizz tictactoe hangman minesweeper connect4 wordle meteo mastermind clean
