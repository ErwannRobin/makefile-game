include ../common-help.mk

STATE_DIR := /tmp/tictactoe
BOARD_FILE := $(STATE_DIR)/board

.PHONY: play clean

play: ## ❌ Tic-Tac-Toe vs computer
	@mkdir -p $(STATE_DIR)
	@printf '.........' > $(BOARD_FILE)
	@echo ""
	@echo "$(CYAN)$(BOLD)  ┌─────────────────────────────┐"
	@echo "  │      T i c - T a c - T o e  │"
	@echo "  │        You = X, CPU = O      │"
	@echo "  └─────────────────────────────┘$(RESET)"
	@echo ""
	@echo "  Enter a position (1-9):"
	@echo ""
	@echo "  $(DIM) 1 │ 2 │ 3 $(RESET)"
	@echo "  $(DIM)───┼───┼───$(RESET)"
	@echo "  $(DIM) 4 │ 5 │ 6 $(RESET)"
	@echo "  $(DIM)───┼───┼───$(RESET)"
	@echo "  $(DIM) 7 │ 8 │ 9 $(RESET)"
	@echo ""
	@$(MAKE) --no-print-directory _turn

_turn:
	@B=$$(cat $(BOARD_FILE)); \
	$(MAKE) --no-print-directory _render_board; \
	EMPTY=$$(echo "$$B" | grep -o '\.' | wc -l | tr -d ' '); \
	if [ "$$EMPTY" = "0" ]; then \
	  echo "  $(YELLOW)$(BOLD)It's a draw!$(RESET)"; echo ""; exit 0; \
	fi; \
	while true; do \
	  printf "  $(BOLD)Your move (1-9):$(RESET) "; \
	  read POS; \
	  case "$$POS" in \
	    [1-9]) ;; \
	    *) echo "  $(RED)Enter a number 1-9$(RESET)"; continue ;; \
	  esac; \
	  IDX=$$((POS - 1)); \
	  CELL=$$(echo "$$B" | cut -c$$((IDX + 1))); \
	  if [ "$$CELL" != "." ]; then \
	    echo "  $(RED)Position taken!$(RESET)"; continue; \
	  fi; \
	  break; \
	done; \
	B=$$(echo "$$B" | sed "s/./$$(printf 'X')/$$((IDX + 1))"); \
	printf '%s' "$$B" > $(BOARD_FILE); \
	if $(MAKE) --no-print-directory _check_win MARK=X 2>/dev/null; then \
	  $(MAKE) --no-print-directory _render_board; \
	  echo "  $(GREEN)$(BOLD)🎉 You win!$(RESET)"; echo ""; exit 0; \
	fi; \
	EMPTY=$$(echo "$$B" | grep -o '\.' | wc -l | tr -d ' '); \
	if [ "$$EMPTY" = "0" ]; then \
	  $(MAKE) --no-print-directory _render_board; \
	  echo "  $(YELLOW)$(BOLD)It's a draw!$(RESET)"; echo ""; exit 0; \
	fi; \
	$(MAKE) --no-print-directory _cpu_move; \
	B=$$(cat $(BOARD_FILE)); \
	if $(MAKE) --no-print-directory _check_win MARK=O 2>/dev/null; then \
	  $(MAKE) --no-print-directory _render_board; \
	  echo "  $(RED)$(BOLD)💻 Computer wins!$(RESET)"; echo ""; exit 0; \
	fi; \
	$(MAKE) --no-print-directory _turn

_render_board:
	@B=$$(cat $(BOARD_FILE)); \
	render_cell() { \
	  case "$$1" in \
	    X) printf '\033[1mX\033[0m' ;; \
	    O) printf '\033[36mO\033[0m' ;; \
	    *) printf ' ' ;; \
	  esac; \
	}; \
	echo ""; \
	printf "   "; render_cell "$$(echo "$$B" | cut -c1)"; \
	printf " │ "; render_cell "$$(echo "$$B" | cut -c2)"; \
	printf " │ "; render_cell "$$(echo "$$B" | cut -c3)"; echo ""; \
	echo "  ───┼───┼───"; \
	printf "   "; render_cell "$$(echo "$$B" | cut -c4)"; \
	printf " │ "; render_cell "$$(echo "$$B" | cut -c5)"; \
	printf " │ "; render_cell "$$(echo "$$B" | cut -c6)"; echo ""; \
	echo "  ───┼───┼───"; \
	printf "   "; render_cell "$$(echo "$$B" | cut -c7)"; \
	printf " │ "; render_cell "$$(echo "$$B" | cut -c8)"; \
	printf " │ "; render_cell "$$(echo "$$B" | cut -c9)"; echo ""; \
	echo ""

_cpu_move:
	@B=$$(cat $(BOARD_FILE)); \
	BEST=""; \
	for LINE in "0 1 2" "3 4 5" "6 7 8" "0 3 6" "1 4 7" "2 5 8" "0 4 8" "2 4 6"; do \
	  set -- $$LINE; \
	  A=$$(echo "$$B" | cut -c$$(( $$1 + 1 ))); \
	  BB=$$(echo "$$B" | cut -c$$(( $$2 + 1 ))); \
	  C=$$(echo "$$B" | cut -c$$(( $$3 + 1 ))); \
	  if [ "$$A" = "O" ] && [ "$$BB" = "O" ] && [ "$$C" = "." ]; then BEST=$$3; break; fi; \
	  if [ "$$A" = "O" ] && [ "$$C" = "O" ] && [ "$$BB" = "." ]; then BEST=$$2; break; fi; \
	  if [ "$$BB" = "O" ] && [ "$$C" = "O" ] && [ "$$A" = "." ]; then BEST=$$1; break; fi; \
	done; \
	if [ -z "$$BEST" ]; then \
	  for LINE in "0 1 2" "3 4 5" "6 7 8" "0 3 6" "1 4 7" "2 5 8" "0 4 8" "2 4 6"; do \
	    set -- $$LINE; \
	    A=$$(echo "$$B" | cut -c$$(( $$1 + 1 ))); \
	    BB=$$(echo "$$B" | cut -c$$(( $$2 + 1 ))); \
	    C=$$(echo "$$B" | cut -c$$(( $$3 + 1 ))); \
	    if [ "$$A" = "X" ] && [ "$$BB" = "X" ] && [ "$$C" = "." ]; then BEST=$$3; break; fi; \
	    if [ "$$A" = "X" ] && [ "$$C" = "X" ] && [ "$$BB" = "." ]; then BEST=$$2; break; fi; \
	    if [ "$$BB" = "X" ] && [ "$$C" = "X" ] && [ "$$A" = "." ]; then BEST=$$1; break; fi; \
	  done; \
	fi; \
	if [ -z "$$BEST" ]; then \
	  C5=$$(echo "$$B" | cut -c5); \
	  if [ "$$C5" = "." ]; then BEST=4; \
	  else \
	    for i in 0 2 6 8 1 3 5 7; do \
	      CELL=$$(echo "$$B" | cut -c$$((i + 1))); \
	      if [ "$$CELL" = "." ]; then BEST=$$i; break; fi; \
	    done; \
	  fi; \
	fi; \
	B=$$(echo "$$B" | sed "s/./$$(printf 'O')/$$((BEST + 1))"); \
	printf '%s' "$$B" > $(BOARD_FILE)

_check_win:
	@B=$$(cat $(BOARD_FILE)); \
	WIN=0; \
	for LINE in "0 1 2" "3 4 5" "6 7 8" "0 3 6" "1 4 7" "2 5 8" "0 4 8" "2 4 6"; do \
	  set -- $$LINE; \
	  A=$$(echo "$$B" | cut -c$$(( $$1 + 1 ))); \
	  BB=$$(echo "$$B" | cut -c$$(( $$2 + 1 ))); \
	  C=$$(echo "$$B" | cut -c$$(( $$3 + 1 ))); \
	  if [ "$$A" = "$(MARK)" ] && [ "$$BB" = "$(MARK)" ] && [ "$$C" = "$(MARK)" ]; then WIN=1; break; fi; \
	done; \
	if [ "$$WIN" = "1" ]; then exit 0; else exit 1; fi

clean: ## Remove game state
	@rm -rf $(STATE_DIR)
	@echo "$(DIM)State cleared$(RESET)"
