include ../common-help.mk

STATE_DIR := /tmp/hangman
WORD_FILE := $(STATE_DIR)/word
GUESSED_FILE := $(STATE_DIR)/guessed
LIVES_FILE := $(STATE_DIR)/lives

WORDS := planet guitar bridge rocket castle monkey forest puzzle knight dragon \
         oxygen spiral thunder camera marble island hammer velvet powder \
         anchor breeze candle fabric garden helmet jungle ladder mirror

.PHONY: play clean

play: ## 🪢 Hangman — guess the word
	@mkdir -p $(STATE_DIR)
	@WORD=$$(echo $(WORDS) | tr ' ' '\n' | awk 'BEGIN{srand()}{a[NR]=$$0}END{print a[int(rand()*NR)+1]}'); \
	printf '%s' "$$WORD" > $(WORD_FILE)
	@printf '' > $(GUESSED_FILE)
	@printf '6' > $(LIVES_FILE)
	@echo ""
	@echo "$(CYAN)$(BOLD)  ┌─────────────────────────────┐"
	@echo "  │       H a n g m a n         │"
	@echo "  │     Guess the word!          │"
	@echo "  └─────────────────────────────┘$(RESET)"
	@echo ""
	@$(MAKE) --no-print-directory _turn

_turn:
	@$(MAKE) --no-print-directory _render; \
	WORD=$$(cat $(WORD_FILE)); \
	GUESSED=$$(cat $(GUESSED_FILE)); \
	LIVES=$$(cat $(LIVES_FILE)); \
	SOLVED=1; \
	for i in $$(seq 1 $${#WORD}); do \
	  CH=$$(echo "$$WORD" | cut -c$$i); \
	  if ! echo "$$GUESSED" | grep -qi "$$CH"; then SOLVED=0; break; fi; \
	done; \
	if [ "$$SOLVED" = "1" ]; then \
	  echo "  $(GREEN)$(BOLD)🎉 You won! The word was: $$WORD$(RESET)"; echo ""; exit 0; \
	fi; \
	if [ "$$LIVES" = "0" ]; then \
	  echo "  $(RED)$(BOLD)💀 Game over! The word was: $$WORD$(RESET)"; echo ""; exit 0; \
	fi; \
	while true; do \
	  printf "  $(BOLD)Guess a letter:$(RESET) "; \
	  read LETTER; \
	  LETTER=$$(echo "$$LETTER" | tr '[:upper:]' '[:lower:]' | tr -d ' '); \
	  case "$$LETTER" in \
	    [a-z]) ;; \
	    *) echo "  $(RED)Enter a single letter$(RESET)"; continue ;; \
	  esac; \
	  if echo "$$GUESSED" | grep -qi "$$LETTER"; then \
	    echo "  $(YELLOW)Already guessed!$(RESET)"; continue; \
	  fi; \
	  break; \
	done; \
	printf '%s' "$${GUESSED}$$LETTER" > $(GUESSED_FILE); \
	if echo "$$WORD" | grep -qi "$$LETTER"; then \
	  echo "  $(GREEN)✓ Correct!$(RESET)"; \
	else \
	  LIVES=$$((LIVES - 1)); \
	  printf '%s' "$$LIVES" > $(LIVES_FILE); \
	  echo "  $(RED)✗ Wrong!$(RESET)"; \
	fi; \
	echo ""; \
	$(MAKE) --no-print-directory _turn

_render:
	@WORD=$$(cat $(WORD_FILE)); \
	GUESSED=$$(cat $(GUESSED_FILE)); \
	LIVES=$$(cat $(LIVES_FILE)); \
	echo ""; \
	case "$$LIVES" in \
	  6) \
	    echo "  $(DIM)  ┌───┐$(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)"; \
	    echo "  $(DIM)  │$(RESET)"; \
	    echo "  $(DIM)══╧══$(RESET)" ;; \
	  5) \
	    echo "  $(DIM)  ┌───┐$(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)$(BOLD)O$(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)"; \
	    echo "  $(DIM)  │$(RESET)"; \
	    echo "  $(DIM)══╧══$(RESET)" ;; \
	  4) \
	    echo "  $(DIM)  ┌───┐$(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)$(BOLD)O$(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)$(BOLD)|$(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)"; \
	    echo "  $(DIM)  │$(RESET)"; \
	    echo "  $(DIM)══╧══$(RESET)" ;; \
	  3) \
	    echo "  $(DIM)  ┌───┐$(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)$(BOLD)O$(RESET)"; \
	    echo "  $(DIM)  │  $(RESET)$(BOLD)/|$(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)"; \
	    echo "  $(DIM)  │$(RESET)"; \
	    echo "  $(DIM)══╧══$(RESET)" ;; \
	  2) \
	    echo "  $(DIM)  ┌───┐$(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)$(BOLD)O$(RESET)"; \
	    echo "  $(DIM)  │  $(RESET)$(BOLD)/|\\\\$(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)"; \
	    echo "  $(DIM)  │$(RESET)"; \
	    echo "  $(DIM)══╧══$(RESET)" ;; \
	  1) \
	    echo "  $(DIM)  ┌───┐$(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)$(BOLD)O$(RESET)"; \
	    echo "  $(DIM)  │  $(RESET)$(BOLD)/|\\\\$(RESET)"; \
	    echo "  $(DIM)  │  $(RESET)$(BOLD)/$(RESET)"; \
	    echo "  $(DIM)  │$(RESET)"; \
	    echo "  $(DIM)══╧══$(RESET)" ;; \
	  0) \
	    echo "  $(DIM)  ┌───┐$(RESET)"; \
	    echo "  $(DIM)  │   $(RESET)$(RED)$(BOLD)O$(RESET)"; \
	    echo "  $(DIM)  │  $(RESET)$(RED)$(BOLD)/|\\\\$(RESET)"; \
	    echo "  $(DIM)  │  $(RESET)$(RED)$(BOLD)/ \\\\$(RESET)"; \
	    echo "  $(DIM)  │$(RESET)"; \
	    echo "  $(DIM)══╧══$(RESET)" ;; \
	esac; \
	echo ""; \
	printf "  $(BOLD)Word:$(RESET) "; \
	for i in $$(seq 1 $${#WORD}); do \
	  CH=$$(echo "$$WORD" | cut -c$$i); \
	  if echo "$$GUESSED" | grep -qi "$$CH"; then \
	    printf "$(GREEN)$$CH$(RESET) "; \
	  else \
	    printf "_ "; \
	  fi; \
	done; \
	echo ""; \
	printf "  $(DIM)Guessed: $$GUESSED$(RESET)\n"; \
	printf "  $(DIM)Lives: $$LIVES$(RESET)\n"; \
	echo ""

clean: ## Remove game state
	@rm -rf $(STATE_DIR)
	@echo "$(DIM)State cleared$(RESET)"
