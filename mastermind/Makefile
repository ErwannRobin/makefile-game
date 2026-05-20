include ../common-help.mk

## Usage: make play [PEGS=4] [COLORS=6] [ATTEMPTS=10]

STATE_DIR := /tmp/mastermind
SECRET_FILE := $(STATE_DIR)/secret
GUESSES_FILE := $(STATE_DIR)/guesses
PEGS ?= 4
COLORS ?= 6
MAX_ATTEMPTS ?= 10

# Color palette (1-8)
C1 := \033[1;31m●\033[0m
C2 := \033[1;32m●\033[0m
C3 := \033[1;34m●\033[0m
C4 := \033[1;33m●\033[0m
C5 := \033[1;35m●\033[0m
C6 := \033[1;36m●\033[0m
C7 := \033[1;37m●\033[0m
C8 := \033[1;91m●\033[0m

.PHONY: play clean

play: ## 🔮 Mastermind — crack the code
	@mkdir -p $(STATE_DIR)
	@awk -v pegs=$(PEGS) -v colors=$(COLORS) 'BEGIN { srand(); for (i=0;i<pegs;i++) printf "%d", int(rand()*colors)+1; }' /dev/null > $(SECRET_FILE)
	@: > $(GUESSES_FILE)
	@echo ""
	@echo "$(BOLD)$(CYAN)  ┌─────────────────────────────────┐"
	@echo "  │     M A S T E R M I N D         │"
	@echo "  │     Crack the secret code!       │"
	@echo "  └─────────────────────────────────┘$(RESET)"
	@echo ""
	@echo "  $(DIM)$(PEGS) pegs, $(COLORS) colors, $(MAX_ATTEMPTS) attempts$(RESET)"
	@echo ""
	@printf "  Colors: "
	@i=1; while [ $$i -le $(COLORS) ]; do \
	  case $$i in \
	    1) printf '  \033[1;31m●\033[0m=1';; \
	    2) printf '  \033[1;32m●\033[0m=2';; \
	    3) printf '  \033[1;34m●\033[0m=3';; \
	    4) printf '  \033[1;33m●\033[0m=4';; \
	    5) printf '  \033[1;35m●\033[0m=5';; \
	    6) printf '  \033[1;36m●\033[0m=6';; \
	    7) printf '  \033[1;37m●\033[0m=7';; \
	    8) printf '  \033[1;91m●\033[0m=8';; \
	  esac; \
	  i=$$((i + 1)); \
	done
	@echo ""
	@echo "  $(DIM)Feedback: $(BOLD)◆$(RESET)$(DIM) = right color & position  $(RESET)◇$(DIM) = right color, wrong position$(RESET)"
	@echo ""
	@$(MAKE) --no-print-directory _turn

_turn:
	@SECRET=$$(cat $(SECRET_FILE)); \
	ATTEMPTS=$$(wc -l < $(GUESSES_FILE) | tr -d ' '); \
	if [ "$$ATTEMPTS" -ge $(MAX_ATTEMPTS) ]; then \
	  echo ""; \
	  printf "  $(RED)$(BOLD)✗ Game Over! The code was: "; \
	  i=0; while [ $$i -lt $(PEGS) ]; do \
	    CH=$$(echo "$$SECRET" | cut -c$$((i+1))); \
	    case $$CH in \
	      1) printf '\033[1;31m●\033[0m ';; 2) printf '\033[1;32m●\033[0m ';; \
	      3) printf '\033[1;34m●\033[0m ';; 4) printf '\033[1;33m●\033[0m ';; \
	      5) printf '\033[1;35m●\033[0m ';; 6) printf '\033[1;36m●\033[0m ';; \
	      7) printf '\033[1;37m●\033[0m ';; 8) printf '\033[1;91m●\033[0m ';; \
	    esac; \
	    i=$$((i + 1)); \
	  done; \
	  echo "$(RESET)"; echo ""; \
	  exit 0; \
	fi; \
	echo "  $(DIM)Attempt $$((ATTEMPTS + 1)) / $(MAX_ATTEMPTS)$(RESET)"; \
	while true; do \
	  printf "  $(BOLD)Your guess ($(PEGS) digits, 1-$(COLORS)): $(RESET)"; \
	  read GUESS; \
	  LEN=$${#GUESS}; \
	  if [ "$$LEN" -ne $(PEGS) ]; then \
	    echo "  $(RED)Enter exactly $(PEGS) digits.$(RESET)"; \
	    continue; \
	  fi; \
	  VALID=1; \
	  i=0; while [ $$i -lt $(PEGS) ]; do \
	    CH=$$(echo "$$GUESS" | cut -c$$((i+1))); \
	    if [ "$$CH" -lt 1 ] 2>/dev/null || [ "$$CH" -gt $(COLORS) ] 2>/dev/null; then \
	      VALID=0; break; \
	    fi; \
	    if ! echo "$$CH" | grep -qE '^[0-9]$$'; then \
	      VALID=0; break; \
	    fi; \
	    i=$$((i + 1)); \
	  done; \
	  if [ "$$VALID" -ne 1 ]; then \
	    echo "  $(RED)Use only digits 1-$(COLORS).$(RESET)"; \
	    continue; \
	  fi; \
	  break; \
	done; \
	echo "$$GUESS" >> $(GUESSES_FILE); \
	$(MAKE) --no-print-directory _render; \
	if [ "$$GUESS" = "$$SECRET" ]; then \
	  ATTEMPTS=$$(wc -l < $(GUESSES_FILE) | tr -d ' '); \
	  echo "  $(GREEN)$(BOLD)✓ Cracked it in $$ATTEMPTS/$(MAX_ATTEMPTS) attempts!$(RESET)"; \
	  echo ""; \
	  exit 0; \
	fi; \
	$(MAKE) --no-print-directory _turn

_render:
	@SECRET=$$(cat $(SECRET_FILE)); \
	echo ""; \
	while IFS= read -r GUESS; do \
	  printf "  "; \
	  i=0; while [ $$i -lt $(PEGS) ]; do \
	    CH=$$(echo "$$GUESS" | cut -c$$((i+1))); \
	    case $$CH in \
	      1) printf '\033[1;31m● \033[0m';; 2) printf '\033[1;32m● \033[0m';; \
	      3) printf '\033[1;34m● \033[0m';; 4) printf '\033[1;33m● \033[0m';; \
	      5) printf '\033[1;35m● \033[0m';; 6) printf '\033[1;36m● \033[0m';; \
	      7) printf '\033[1;37m● \033[0m';; 8) printf '\033[1;91m● \033[0m';; \
	    esac; \
	    i=$$((i + 1)); \
	  done; \
	  printf " │ "; \
	  EXACT=0; PARTIAL=0; \
	  S_REMAINING=""; G_REMAINING=""; \
	  i=0; while [ $$i -lt $(PEGS) ]; do \
	    GC=$$(echo "$$GUESS" | cut -c$$((i+1))); \
	    SC=$$(echo "$$SECRET" | cut -c$$((i+1))); \
	    if [ "$$GC" = "$$SC" ]; then \
	      EXACT=$$((EXACT + 1)); \
	      S_REMAINING="$${S_REMAINING}_"; \
	      G_REMAINING="$${G_REMAINING}_"; \
	    else \
	      S_REMAINING="$${S_REMAINING}$$SC"; \
	      G_REMAINING="$${G_REMAINING}$$GC"; \
	    fi; \
	    i=$$((i + 1)); \
	  done; \
	  i=0; while [ $$i -lt $(PEGS) ]; do \
	    GC=$$(echo "$$G_REMAINING" | cut -c$$((i+1))); \
	    if [ "$$GC" != "_" ] && [ -n "$$GC" ]; then \
	      if echo "$$S_REMAINING" | grep -q "$$GC"; then \
	        PARTIAL=$$((PARTIAL + 1)); \
	        S_REMAINING=$$(echo "$$S_REMAINING" | sed "s/$$GC/_/"); \
	      fi; \
	    fi; \
	    i=$$((i + 1)); \
	  done; \
	  j=0; while [ $$j -lt $$EXACT ]; do printf '\033[1m◆\033[0m'; j=$$((j+1)); done; \
	  j=0; while [ $$j -lt $$PARTIAL ]; do printf '◇'; j=$$((j+1)); done; \
	  EMPTY=$$(($(PEGS) - EXACT - PARTIAL)); \
	  j=0; while [ $$j -lt $$EMPTY ]; do printf ' '; j=$$((j+1)); done; \
	  echo ""; \
	done < $(GUESSES_FILE); \
	echo ""

clean: ## Reset the game
	@rm -rf $(STATE_DIR)
	@echo "  $(DIM)Game reset.$(RESET)"
