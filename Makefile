include common-help.mk

# Auto-discover games (subfolders with a Makefile containing a play target)
GAMES := $(sort $(patsubst %/Makefile,%,$(wildcard */Makefile)))

.PHONY: menu clean $(GAMES)

.DEFAULT_GOAL := menu

##@ Games

menu: ## 🎮 Interactive game menu
	@echo ""
	@echo "$(BOLD)$(CYAN)  ┌─────────────────────────────────────┐"
	@echo "  │        🎮  G A M E   M E N U        │"
	@echo "  └─────────────────────────────────────┘$(RESET)"
	@echo ""
	@echo "  $(BOLD) #  Game$(RESET)"
	@echo "  $(DIM)───────────────────────────────────$(RESET)"
	@i=1; for game in $(GAMES); do \
	  DESC=$$(grep '^play:.*##' $$game/Makefile 2>/dev/null | sed 's/^play:.*## *//'); \
	  [ -z "$$DESC" ] && DESC="$$game"; \
	  printf "  %2d) %s\n" $$i "$$DESC"; \
	  i=$$((i + 1)); \
	done
	@echo "  $(DIM)───────────────────────────────────$(RESET)"
	@echo "   0) 🚪  Quit"
	@echo ""
	@printf "  $(BOLD)Choose a game (0-$$(echo $(GAMES) | wc -w | tr -d ' ')): $(RESET)"; \
	read CHOICE; \
	if [ "$$CHOICE" = "0" ]; then \
	  echo "  $(DIM)Bye! 👋$(RESET)"; exit 0; \
	fi; \
	i=1; FOUND=""; \
	for game in $(GAMES); do \
	  if [ $$i -eq $$CHOICE ] 2>/dev/null; then \
	    FOUND=$$game; break; \
	  fi; \
	  i=$$((i + 1)); \
	done; \
	if [ -z "$$FOUND" ]; then \
	  echo "  $(RED)Invalid choice.$(RESET)"; \
	  $(MAKE) --no-print-directory menu; \
	else \
	  $(MAKE) --no-print-directory $$FOUND; \
	fi

# Generic rule: any game folder becomes a target
$(GAMES):
	@$(MAKE) -C $@ --no-print-directory play

##@ Utilities

clean: ## 🧹 Clean all game state
	@for game in $(GAMES); do \
	  $(MAKE) -C $$game --no-print-directory clean 2>/dev/null || true; \
	done
	@echo "  All clean!"
