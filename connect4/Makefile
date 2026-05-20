include ../common-help.mk

STATE_DIR := /tmp/connect4
BOARD_FILE := $(STATE_DIR)/board
TURN_FILE := $(STATE_DIR)/turn

ROWS := 6
COLS := 7

.PHONY: play clean

play: ## Play Connect 4 against the computer
	@mkdir -p $(STATE_DIR)
	@awk -v total=$$(($(ROWS) * $(COLS))) 'BEGIN { for (i = 0; i < total; i++) printf "."; }' /dev/null > $(BOARD_FILE)
	@printf 'X' > $(TURN_FILE)
	@echo ""
	@echo "$(CYAN)$(BOLD)  ┌─────────────────────────────┐"
	@echo "  │     C o n n e c t   4       │"
	@echo "  │      You = X, CPU = O       │"
	@echo "  └─────────────────────────────┘$(RESET)"
	@echo ""
	@$(MAKE) --no-print-directory _turn

_turn:
	@$(MAKE) --no-print-directory _render; \
	TURN=$$(cat $(TURN_FILE)); \
	if [ "$$TURN" = "X" ]; then \
	  while true; do \
	    printf "  $(BOLD)Drop in column (1-$(COLS)):$(RESET) "; \
	    read COL; \
	    case "$$COL" in \
	      [1-7]) ;; \
	      *) echo "  $(RED)Enter 1-$(COLS)$(RESET)"; continue ;; \
	    esac; \
	    COL=$$((COL - 1)); \
	    ROW=$$($(MAKE) --no-print-directory _find_row COL=$$COL); \
	    if [ "$$ROW" = "-1" ]; then \
	      echo "  $(RED)Column full!$(RESET)"; continue; \
	    fi; \
	    break; \
	  done; \
	  $(MAKE) --no-print-directory _place ROW=$$ROW COL=$$COL MARK=X; \
	  if $(MAKE) --no-print-directory _check_win MARK=X 2>/dev/null; then \
	    $(MAKE) --no-print-directory _render; \
	    echo "  $(GREEN)$(BOLD)🎉 You win!$(RESET)"; echo ""; exit 0; \
	  fi; \
	  if $(MAKE) --no-print-directory _check_draw 2>/dev/null; then \
	    $(MAKE) --no-print-directory _render; \
	    echo "  $(YELLOW)$(BOLD)It's a draw!$(RESET)"; echo ""; exit 0; \
	  fi; \
	  printf 'O' > $(TURN_FILE); \
	else \
	  $(MAKE) --no-print-directory _cpu_move; \
	  if $(MAKE) --no-print-directory _check_win MARK=O 2>/dev/null; then \
	    $(MAKE) --no-print-directory _render; \
	    echo "  $(RED)$(BOLD)💻 Computer wins!$(RESET)"; echo ""; exit 0; \
	  fi; \
	  if $(MAKE) --no-print-directory _check_draw 2>/dev/null; then \
	    $(MAKE) --no-print-directory _render; \
	    echo "  $(YELLOW)$(BOLD)It's a draw!$(RESET)"; echo ""; exit 0; \
	  fi; \
	  printf 'X' > $(TURN_FILE); \
	fi; \
	$(MAKE) --no-print-directory _turn

_find_row:
	@B=$$(cat $(BOARD_FILE)); \
	FOUND=-1; \
	for r in $$(seq $$(($(ROWS) - 1)) -1 0); do \
	  IDX=$$((r * $(COLS) + $(COL))); \
	  CELL=$$(echo "$$B" | cut -c$$((IDX + 1))); \
	  if [ "$$CELL" = "." ]; then FOUND=$$r; break; fi; \
	done; \
	echo "$$FOUND"

_place:
	@B=$$(cat $(BOARD_FILE)); \
	IDX=$$(($(ROW) * $(COLS) + $(COL))); \
	B=$$(printf '%s' "$$B" | sed "s/./$(MARK)/$$((IDX + 1))"); \
	printf '%s' "$$B" > $(BOARD_FILE)

define AI_SCRIPT
function get_row(board, col,    r, idx) {
  for (r = rows - 1; r >= 0; r--) {
    idx = r * cols + col + 1;
    if (substr(board, idx, 1) == ".") return r;
  }
  return -1;
}
function place(board, r, col, ch,    idx) {
  idx = r * cols + col + 1;
  return substr(board, 1, idx-1) ch substr(board, idx+1);
}
function eval_window(b, pos1, pos2, pos3, pos4,    mc, oc, w) {
  mc = 0; oc = 0;
  w = substr(b, pos1, 1); if (w == mark) mc++; else if (w == opp) oc++;
  w = substr(b, pos2, 1); if (w == mark) mc++; else if (w == opp) oc++;
  w = substr(b, pos3, 1); if (w == mark) mc++; else if (w == opp) oc++;
  w = substr(b, pos4, 1); if (w == mark) mc++; else if (w == opp) oc++;
  if (mc == 4) return 100000;
  if (oc == 4) return -100000;
  if (oc == 0) { if (mc == 3) return 100; if (mc == 2) return 10; if (mc == 1) return 1; }
  if (mc == 0) { if (oc == 3) return -80; if (oc == 2) return -8; }
  return 0;
}
function evaluate(b,    score, r, c, base) {
  score = 0;
  for (r = 0; r < rows; r++) if (substr(b, r * cols + int(cols/2) + 1, 1) == mark) score += 6;
  for (r = 0; r < rows; r++) {
    for (c = 0; c < cols; c++) {
      base = r * cols + c + 1;
      if (c <= cols - 4) score += eval_window(b, base, base+1, base+2, base+3);
      if (r <= rows - 4) score += eval_window(b, base, base+cols, base+2*cols, base+3*cols);
      if (c <= cols - 4 && r <= rows - 4) score += eval_window(b, base, base+cols+1, base+2*(cols+1), base+3*(cols+1));
      if (c >= 3 && r <= rows - 4) score += eval_window(b, base, base+cols-1, base+2*(cols-1), base+3*(cols-1));
    }
  }
  return score;
}
function has_win(b, ch,    r, c, i, count) {
  for (r = 0; r < rows; r++) { for (c = 0; c <= cols - 4; c++) { count = 0; for (i = 0; i < 4; i++) if (substr(b, r*cols+c+i+1, 1) == ch) count++; if (count == 4) return 1; } }
  for (r = 0; r <= rows - 4; r++) { for (c = 0; c < cols; c++) { count = 0; for (i = 0; i < 4; i++) if (substr(b, (r+i)*cols+c+1, 1) == ch) count++; if (count == 4) return 1; } }
  for (r = 0; r <= rows - 4; r++) { for (c = 0; c <= cols - 4; c++) { count = 0; for (i = 0; i < 4; i++) if (substr(b, (r+i)*cols+(c+i)+1, 1) == ch) count++; if (count == 4) return 1; } }
  for (r = 0; r <= rows - 4; r++) { for (c = 3; c < cols; c++) { count = 0; for (i = 0; i < 4; i++) if (substr(b, (r+i)*cols+(c-i)+1, 1) == ch) count++; if (count == 4) return 1; } }
  return 0;
}
function minimax(b, depth, is_max, alpha, beta,    best, c, r, nb, s, order) {
  if (has_win(b, mark)) return 50000 + depth;
  if (has_win(b, opp)) return -50000 - depth;
  if (depth == 0) return evaluate(b);
  split("3 2 4 1 5 0 6", order);
  if (is_max) {
    best = -999999;
    for (c = 1; c <= 7; c++) { r = get_row(b, order[c]+0); if (r < 0) continue; nb = place(b, r, order[c]+0, mark); s = minimax(nb, depth-1, 0, alpha, beta); if (s > best) best = s; if (best > alpha) alpha = best; if (alpha >= beta) break; }
    return best;
  } else {
    best = 999999;
    for (c = 1; c <= 7; c++) { r = get_row(b, order[c]+0); if (r < 0) continue; nb = place(b, r, order[c]+0, opp); s = minimax(nb, depth-1, 1, alpha, beta); if (s < best) best = s; if (best < beta) beta = best; if (alpha >= beta) break; }
    return best;
  }
}
{ b = $$0; best_score = -999999; best_col = 3; split("3 2 4 1 5 0 6", order); for (c = 1; c <= 7; c++) { col = order[c] + 0; r = get_row(b, col); if (r < 0) continue; nb = place(b, r, col, mark); s = minimax(nb, 3, 0, -999999, 999999); if (s > best_score) { best_score = s; best_col = col } } print best_col }
endef
export AI_SCRIPT

_cpu_move:
	@B=$$(cat $(BOARD_FILE)); \
	BEST_COL=$$(echo "$$B" | awk -v cols=$(COLS) -v rows=$(ROWS) -v mark=O -v opp=X "$$AI_SCRIPT"); \
	ROW=$$($(MAKE) --no-print-directory _find_row COL=$$BEST_COL); \
	$(MAKE) --no-print-directory _place ROW=$$ROW COL=$$BEST_COL MARK=O

_check_win:
	@$(MAKE) --no-print-directory _check_win_board MARK=$(MARK) BFILE=$(BOARD_FILE)

_check_win_board:
	@B=$$(cat $(BFILE)); \
	WIN=0; \
	for r in $$(seq 0 $$(($(ROWS) - 1))); do \
	  for c in $$(seq 0 $$(($(COLS) - 1))); do \
	    IDX=$$((r * $(COLS) + c)); \
	    CELL=$$(echo "$$B" | cut -c$$((IDX + 1))); \
	    [ "$$CELL" != "$(MARK)" ] && continue; \
	    if [ $$c -le $$(($(COLS) - 4)) ]; then \
	      OK=1; for i in 1 2 3; do \
	        NI=$$((IDX + i)); NC=$$(echo "$$B" | cut -c$$((NI + 1))); \
	        [ "$$NC" != "$(MARK)" ] && OK=0 && break; \
	      done; [ "$$OK" = "1" ] && WIN=1; \
	    fi; \
	    if [ $$r -le $$(($(ROWS) - 4)) ]; then \
	      OK=1; for i in 1 2 3; do \
	        NI=$$((IDX + i * $(COLS))); NC=$$(echo "$$B" | cut -c$$((NI + 1))); \
	        [ "$$NC" != "$(MARK)" ] && OK=0 && break; \
	      done; [ "$$OK" = "1" ] && WIN=1; \
	    fi; \
	    if [ $$c -le $$(($(COLS) - 4)) ] && [ $$r -le $$(($(ROWS) - 4)) ]; then \
	      OK=1; for i in 1 2 3; do \
	        NI=$$((IDX + i * $(COLS) + i)); NC=$$(echo "$$B" | cut -c$$((NI + 1))); \
	        [ "$$NC" != "$(MARK)" ] && OK=0 && break; \
	      done; [ "$$OK" = "1" ] && WIN=1; \
	    fi; \
	    if [ $$c -ge 3 ] && [ $$r -le $$(($(ROWS) - 4)) ]; then \
	      OK=1; for i in 1 2 3; do \
	        NI=$$((IDX + i * $(COLS) - i)); NC=$$(echo "$$B" | cut -c$$((NI + 1))); \
	        [ "$$NC" != "$(MARK)" ] && OK=0 && break; \
	      done; [ "$$OK" = "1" ] && WIN=1; \
	    fi; \
	    [ "$$WIN" = "1" ] && break; \
	  done; \
	  [ "$$WIN" = "1" ] && break; \
	done; \
	if [ "$$WIN" = "1" ]; then exit 0; else exit 1; fi

_check_draw:
	@B=$$(cat $(BOARD_FILE)); \
	if echo "$$B" | grep -q '\.'; then exit 1; else exit 0; fi

_render:
	@B=$$(cat $(BOARD_FILE)); \
	echo ""; \
	printf "  "; \
	for c in $$(seq 1 $(COLS)); do printf " %d" $$c; done; \
	echo ""; \
	echo "  ───────────────"; \
	for r in $$(seq 0 $$(($(ROWS) - 1))); do \
	  printf "  |"; \
	  for c in $$(seq 0 $$(($(COLS) - 1))); do \
	    IDX=$$((r * $(COLS) + c)); \
	    CELL=$$(echo "$$B" | cut -c$$((IDX + 1))); \
	    case "$$CELL" in \
	      X) printf "\033[1;33mX\033[0m|" ;; \
	      O) printf "\033[1;36mO\033[0m|" ;; \
	      *) printf " |" ;; \
	    esac; \
	  done; \
	  echo ""; \
	done; \
	echo "  ───────────────"; \
	echo ""

clean: ## Remove game state
	@rm -rf $(STATE_DIR)
	@echo "$(DIM)State cleared$(RESET)"
