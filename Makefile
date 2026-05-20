SECRET ?= $(shell echo $$((RANDOM % 100 + 1)))

guess:
	@echo "I'm thinking of a number between 1 and 100..."
	@$(MAKE) --no-print-directory _guess SECRET=$(SECRET)

_guess:
	@read -p "Guess a number: " n; \
	if [ "$$n" -eq "$(SECRET)" ]; then \
		echo "Correct!"; \
	elif [ "$$n" -lt "$(SECRET)" ]; then \
		echo "Too low!"; $(MAKE) --no-print-directory _guess SECRET=$(SECRET); \
	else \
		echo "Too high!"; $(MAKE) --no-print-directory _guess SECRET=$(SECRET); \
	fi

