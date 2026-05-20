include common-help.mk

##@ Games

guess: ## 🔢 Guess the number (1-100)
	@$(MAKE) -C guess --no-print-directory play

waquizz: ## 🧠 WaQuizz — Solo trivia game
	@$(MAKE) -C waquizz --no-print-directory play

##@ Utilities

clean: ## 🧹 Clean all game state
	@$(MAKE) -C waquizz --no-print-directory clean 2>/dev/null || true
	@echo "All clean!"

.PHONY: guess waquizz clean
