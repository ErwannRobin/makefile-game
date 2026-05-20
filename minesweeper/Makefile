include ../common-help.mk

STATE_DIR := /tmp/minesweeper
BOARD_FILE := $(STATE_DIR)/board
VISIBLE_FILE := $(STATE_DIR)/visible
FLAGS_FILE := $(STATE_DIR)/flags

ROWS ?= 8
COLS ?= 8
MINES ?= 10

.PHONY: play clean

play: ## Play Minesweeper (ROWS=8 COLS=8 MINES=10)
	@mkdir -p $(STATE_DIR)
	@echo ""
	@echo "$(CYAN)$(BOLD)  ┌─────────────────────────────┐"
	@echo "  │    M i n e s w e e p e r    │"
	@echo "  └─────────────────────────────┘$(RESET)"
	@echo ""
	@echo "  $(DIM)Grid: $(ROWS)×$(COLS) | Mines: $(MINES)$(RESET)"
	@echo "  $(DIM)Commands: r,c to reveal | f,r,c to flag$(RESET)"
	@echo ""
	@$(MAKE) --no-print-directory _init
	@$(MAKE) --no-print-directory _loop

_init:
	@awk -v rows=$(ROWS) -v cols=$(COLS) -v mines=$(MINES) 'BEGIN { \
	  srand(); \
	  total = rows * cols; \
	  for (i = 0; i < total; i++) board[i] = 0; \
	  placed = 0; \
	  while (placed < mines) { \
	    pos = int(rand() * total); \
	    if (board[pos] != 9) { board[pos] = 9; placed++; } \
	  } \
	  for (r = 0; r < rows; r++) { \
	    for (c = 0; c < cols; c++) { \
	      idx = r * cols + c; \
	      if (board[idx] == 9) continue; \
	      count = 0; \
	      for (dr = -1; dr <= 1; dr++) { \
	        for (dc = -1; dc <= 1; dc++) { \
	          nr = r + dr; nc = c + dc; \
	          if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) { \
	            if (board[nr * cols + nc] == 9) count++; \
	          } \
	        } \
	      } \
	      board[idx] = count; \
	    } \
	  } \
	  for (i = 0; i < total; i++) printf "%d", board[i]; \
	}' /dev/null > $(BOARD_FILE)
	@awk -v total=$$(($(ROWS) * $(COLS))) 'BEGIN { for (i = 0; i < total; i++) printf "h"; }' /dev/null > $(VISIBLE_FILE)
	@printf '' > $(FLAGS_FILE)

_loop:
	@$(MAKE) --no-print-directory _render; \
	VISIBLE=$$(cat $(VISIBLE_FILE)); \
	BOARD=$$(cat $(BOARD_FILE)); \
	TOTAL=$$(($(ROWS) * $(COLS))); \
	HIDDEN=0; MINE_COUNT=0; \
	for i in $$(seq 0 $$((TOTAL - 1))); do \
	  V=$$(echo "$$VISIBLE" | cut -c$$((i + 1))); \
	  B=$$(echo "$$BOARD" | cut -c$$((i + 1))); \
	  if [ "$$V" = "h" ] || [ "$$V" = "f" ]; then HIDDEN=$$((HIDDEN + 1)); fi; \
	  if [ "$$B" = "9" ]; then MINE_COUNT=$$((MINE_COUNT + 1)); fi; \
	done; \
	if [ "$$HIDDEN" = "$$MINE_COUNT" ]; then \
	  echo "  $(GREEN)$(BOLD)🎉 You win! All mines cleared!$(RESET)"; echo ""; exit 0; \
	fi; \
	printf "  $(BOLD)Move (row,col) or (f,row,col):$(RESET) "; \
	read INPUT; \
	FLAG=0; ROW=0; COL=0; \
	case "$$INPUT" in \
	  f,*|F,*) \
	    FLAG=1; \
	    ROW=$$(echo "$$INPUT" | cut -d, -f2); \
	    COL=$$(echo "$$INPUT" | cut -d, -f3) ;; \
	  *,*) \
	    ROW=$$(echo "$$INPUT" | cut -d, -f1); \
	    COL=$$(echo "$$INPUT" | cut -d, -f2) ;; \
	  *) echo "  $(RED)Format: row,col or f,row,col$(RESET)"; \
	     $(MAKE) --no-print-directory _loop; exit 0 ;; \
	esac; \
	if [ -z "$$ROW" ] || [ -z "$$COL" ]; then \
	  echo "  $(RED)Format: row,col or f,row,col$(RESET)"; \
	  $(MAKE) --no-print-directory _loop; exit 0; \
	fi; \
	if [ "$$ROW" -lt 1 ] || [ "$$ROW" -gt $(ROWS) ] || [ "$$COL" -lt 1 ] || [ "$$COL" -gt $(COLS) ] 2>/dev/null; then \
	  echo "  $(RED)Out of bounds$(RESET)"; \
	  $(MAKE) --no-print-directory _loop; exit 0; \
	fi; \
	IDX=$$(( (ROW - 1) * $(COLS) + (COL - 1) )); \
	V=$$(echo "$$VISIBLE" | cut -c$$((IDX + 1))); \
	if [ "$$FLAG" = "1" ]; then \
	  if [ "$$V" = "h" ]; then \
	    VISIBLE=$$(printf '%s' "$$VISIBLE" | sed "s/./f/$$((IDX + 1))"); \
	  elif [ "$$V" = "f" ]; then \
	    VISIBLE=$$(printf '%s' "$$VISIBLE" | sed "s/./h/$$((IDX + 1))"); \
	  fi; \
	  printf '%s' "$$VISIBLE" > $(VISIBLE_FILE); \
	  $(MAKE) --no-print-directory _loop; exit 0; \
	fi; \
	if [ "$$V" = "r" ] || [ "$$V" = "f" ]; then \
	  $(MAKE) --no-print-directory _loop; exit 0; \
	fi; \
	CELL=$$(echo "$$BOARD" | cut -c$$((IDX + 1))); \
	if [ "$$CELL" = "9" ]; then \
	  awk -v total=$$(($(ROWS) * $(COLS))) 'BEGIN { for (i = 0; i < total; i++) printf "r"; }' /dev/null > $(VISIBLE_FILE); \
	  $(MAKE) --no-print-directory _render; \
	  echo "  $(RED)$(BOLD)💥 BOOM! You hit a mine!$(RESET)"; echo ""; exit 0; \
	fi; \
	$(MAKE) --no-print-directory _reveal POS=$$IDX; \
	$(MAKE) --no-print-directory _loop

_reveal:
	@BOARD=$$(cat $(BOARD_FILE)); \
	VISIBLE=$$(cat $(VISIBLE_FILE)); \
	QUEUE="$(POS)"; \
	while [ -n "$$QUEUE" ]; do \
	  CUR=$$(echo "$$QUEUE" | cut -d' ' -f1); \
	  QUEUE=$$(echo "$$QUEUE" | cut -d' ' -f2-); \
	  [ "$$QUEUE" = "$$CUR" ] && QUEUE=""; \
	  V=$$(echo "$$VISIBLE" | cut -c$$((CUR + 1))); \
	  [ "$$V" = "r" ] && continue; \
	  VISIBLE=$$(printf '%s' "$$VISIBLE" | sed "s/./r/$$((CUR + 1))"); \
	  CELL=$$(echo "$$BOARD" | cut -c$$((CUR + 1))); \
	  if [ "$$CELL" = "0" ]; then \
	    R=$$((CUR / $(COLS))); \
	    C=$$((CUR % $(COLS))); \
	    for DR in -1 0 1; do \
	      for DC in -1 0 1; do \
	        NR=$$((R + DR)); NC=$$((C + DC)); \
	        if [ $$NR -ge 0 ] && [ $$NR -lt $(ROWS) ] && [ $$NC -ge 0 ] && [ $$NC -lt $(COLS) ]; then \
	          NIDX=$$((NR * $(COLS) + NC)); \
	          NV=$$(echo "$$VISIBLE" | cut -c$$((NIDX + 1))); \
	          [ "$$NV" != "r" ] && QUEUE="$$QUEUE $$NIDX"; \
	        fi; \
	      done; \
	    done; \
	  fi; \
	done; \
	printf '%s' "$$VISIBLE" > $(VISIBLE_FILE)

_render:
	@BOARD=$$(cat $(BOARD_FILE)); \
	VISIBLE=$$(cat $(VISIBLE_FILE)); \
	echo ""; \
	printf "  $(DIM)  "; \
	for c in $$(seq 1 $(COLS)); do printf " %d" $$c; done; \
	printf "$(RESET)\n"; \
	for r in $$(seq 0 $$(($(ROWS) - 1))); do \
	  printf "  $(DIM)%d$(RESET) " $$((r + 1)); \
	  for c in $$(seq 0 $$(($(COLS) - 1))); do \
	    IDX=$$((r * $(COLS) + c)); \
	    V=$$(echo "$$VISIBLE" | cut -c$$((IDX + 1))); \
	    B=$$(echo "$$BOARD" | cut -c$$((IDX + 1))); \
	    if [ "$$V" = "f" ]; then \
	      printf "$(YELLOW) ⚑$(RESET)"; \
	    elif [ "$$V" = "h" ]; then \
	      printf "$(DIM) ·$(RESET)"; \
	    elif [ "$$B" = "9" ]; then \
	      printf "$(RED) ✹$(RESET)"; \
	    elif [ "$$B" = "0" ]; then \
	      printf "  "; \
	    else \
	      case "$$B" in \
	        1) printf "$(CYAN) $$B$(RESET)" ;; \
	        2) printf "$(GREEN) $$B$(RESET)" ;; \
	        3) printf "$(RED) $$B$(RESET)" ;; \
	        *) printf "$(YELLOW) $$B$(RESET)" ;; \
	      esac; \
	    fi; \
	  done; \
	  echo ""; \
	done; \
	echo ""

clean: ## Remove game state
	@rm -rf $(STATE_DIR)
	@echo "$(DIM)State cleared$(RESET)"
