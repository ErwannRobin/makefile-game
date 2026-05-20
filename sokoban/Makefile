include ../common-help.mk

## Usage: make play [LEVEL=1]

STATE_DIR := /tmp/sokoban
BOARD_FILE := $(STATE_DIR)/board
LEVEL_FILE := $(STATE_DIR)/level
MOVES_FILE := $(STATE_DIR)/moves
LEVEL ?= 1

# Board symbols:
# # = wall, . = target, $ = box, * = box on target
# @ = player, + = player on target, (space) = floor

.PHONY: play clean

play: ## Play Sokoban — push all boxes onto targets
	@mkdir -p $(STATE_DIR)
	@echo "$(LEVEL)" > $(LEVEL_FILE)
	@echo "0" > $(MOVES_FILE)
	@$(MAKE) --no-print-directory _load_level
	@echo ""
	@echo "$(BOLD)$(CYAN)  ┌─────────────────────────────────┐"
	@echo "  │       S O K O B A N             │"
	@echo "  │    Push boxes onto targets!      │"
	@echo "  └─────────────────────────────────┘$(RESET)"
	@echo ""
	@echo "  $(DIM)Controls: W/A/S/D = move, R = restart, Q = quit$(RESET)"
	@echo "  $(DIM)Legend: $(BOLD)$(YELLOW)◉$(RESET)$(DIM) = box  $(BOLD)$(GREEN)✦$(RESET)$(DIM) = target  $(BOLD)$(CYAN)◈$(RESET)$(DIM) = box on target$(RESET)"
	@echo ""
	@$(MAKE) --no-print-directory _turn

_load_level:
	@LVL=$$(cat $(LEVEL_FILE)); \
	case $$LVL in \
	  1) printf '#####\n#   #\n#@' > $(BOARD_FILE); printf '$$' >> $(BOARD_FILE); printf '.#\n#   #\n#####\n' >> $(BOARD_FILE);; \
	  2) printf '######\n#    #\n# @' > $(BOARD_FILE); printf '$$' >> $(BOARD_FILE); printf '. #\n#  ' >> $(BOARD_FILE); printf '$$' >> $(BOARD_FILE); printf '. #\n#    #\n######\n' >> $(BOARD_FILE);; \
	  3) printf '#######\n#     #\n# @' > $(BOARD_FILE); printf '$$' >> $(BOARD_FILE); printf '. #\n#  #  #\n#  ' >> $(BOARD_FILE); printf '$$' >> $(BOARD_FILE); printf '. #\n#     #\n#######\n' >> $(BOARD_FILE);; \
	  4) printf '########\n#  .   #\n#  ' > $(BOARD_FILE); printf '$$' >> $(BOARD_FILE); printf '   #\n#  @   #\n#  ' >> $(BOARD_FILE); printf '$$' >> $(BOARD_FILE); printf '   #\n#  .   #\n########\n' >> $(BOARD_FILE);; \
	  5) printf '########\n#  ..  #\n#  ' > $(BOARD_FILE); printf '$$$$' >> $(BOARD_FILE); printf '  #\n#   @  #\n#  ' >> $(BOARD_FILE); printf '$$$$' >> $(BOARD_FILE); printf '  #\n#  ..  #\n########\n' >> $(BOARD_FILE);; \
	  *) echo "  $(RED)Level $$LVL not found. Available: 1-5$(RESET)"; exit 1;; \
	esac

_turn:
	@$(MAKE) --no-print-directory _render; \
	if $(MAKE) --no-print-directory _check_win 2>/dev/null; then \
	  MOVES=$$(cat $(MOVES_FILE)); \
	  LVL=$$(cat $(LEVEL_FILE)); \
	  echo "  $(GREEN)$(BOLD)✓ Level $$LVL complete in $$MOVES moves!$(RESET)"; \
	  echo ""; \
	  if [ $$LVL -lt 5 ]; then \
	    echo "  $(DIM)Next level? (y/n)$(RESET)"; \
	    read ANS; \
	    if [ "$$ANS" = "y" ] || [ "$$ANS" = "Y" ]; then \
	      echo "$$((LVL + 1))" > $(LEVEL_FILE); \
	      echo "0" > $(MOVES_FILE); \
	      $(MAKE) --no-print-directory _load_level; \
	      $(MAKE) --no-print-directory _turn; \
	    fi; \
	  fi; \
	  exit 0; \
	fi; \
	printf "  $(BOLD)Move: $(RESET)"; \
	read -r INPUT; \
	INPUT=$$(echo "$$INPUT" | tr 'A-Z' 'a-z'); \
	case $$INPUT in \
	  w|a|s|d) $(MAKE) --no-print-directory _move DIR=$$INPUT;; \
	  r) $(MAKE) --no-print-directory _load_level; $(MAKE) --no-print-directory _turn; exit 0;; \
	  q) echo "  $(DIM)Bye!$(RESET)"; exit 0;; \
	  *) echo "  $(RED)Use W/A/S/D to move, R to restart, Q to quit$(RESET)";; \
	esac; \
	$(MAKE) --no-print-directory _turn

_render:
	@echo "  $(DIM)────────────────────$(RESET)"
	@MOVES=$$(cat $(MOVES_FILE)); \
	LVL=$$(cat $(LEVEL_FILE)); \
	echo "  $(DIM)Level: $$LVL  Moves: $$MOVES$(RESET)"; \
	echo ""; \
	while IFS= read -r LINE; do \
	  printf "  "; \
	  i=1; LEN=$${#LINE}; \
	  while [ $$i -le $$LEN ]; do \
	    CH=$$(printf '%s' "$$LINE" | cut -c$$i); \
	    case "$$CH" in \
	      '#') printf '\033[90m██\033[0m';; \
	      '@') printf '\033[1;37;44m😀\033[0m';; \
	      '+') printf '\033[1;37;42m😀\033[0m';; \
	      '$$') printf '\033[1;33m◉ \033[0m';; \
	      '.') printf '\033[1;32m✦ \033[0m';; \
	      '*') printf '\033[1;36m◈ \033[0m';; \
	      ' ') printf '  ';; \
	      *) printf '  ';; \
	    esac; \
	    i=$$((i + 1)); \
	  done; \
	  echo ""; \
	done < $(BOARD_FILE); \
	echo ""

_move:
	@awk -v dir=$(DIR) ' \
	BEGIN { rows = 0 } \
	{ lines[rows] = $$0; rows++ } \
	END { \
	  maxcol = 0; \
	  for (r = 0; r < rows; r++) { \
	    if (length(lines[r]) > maxcol) maxcol = length(lines[r]); \
	  } \
	  pr = -1; pc = -1; \
	  for (r = 0; r < rows; r++) { \
	    for (c = 1; c <= length(lines[r]); c++) { \
	      ch = substr(lines[r], c, 1); \
	      if (ch == "@" || ch == "+") { pr = r; pc = c; break } \
	    } \
	    if (pr >= 0) break; \
	  } \
	  if (pr < 0) { for (r = 0; r < rows; r++) print lines[r]; exit } \
	  dr = 0; dc = 0; \
	  if (dir == "w") dr = -1; \
	  else if (dir == "s") dr = 1; \
	  else if (dir == "a") dc = -1; \
	  else if (dir == "d") dc = 1; \
	  nr = pr + dr; nc = pc + dc; \
	  if (nr < 0 || nr >= rows) { for (r = 0; r < rows; r++) print lines[r]; exit } \
	  next_ch = substr(lines[nr], nc, 1); \
	  if (next_ch == "#") { for (r = 0; r < rows; r++) print lines[r]; exit } \
	  moved = 0; \
	  if (next_ch == "$$" || next_ch == "*") { \
	    br = nr + dr; bc = nc + dc; \
	    if (br < 0 || br >= rows) { for (r = 0; r < rows; r++) print lines[r]; exit } \
	    box_next = substr(lines[br], bc, 1); \
	    if (box_next == " " || box_next == ".") { \
	      new_box = (box_next == ".") ? "*" : "$$"; \
	      lines[br] = substr(lines[br], 1, bc-1) new_box substr(lines[br], bc+1); \
	      new_next = (next_ch == "*") ? "+" : "@"; \
	      lines[nr] = substr(lines[nr], 1, nc-1) new_next substr(lines[nr], nc+1); \
	      cur_ch = substr(lines[pr], pc, 1); \
	      new_cur = (cur_ch == "+") ? "." : " "; \
	      lines[pr] = substr(lines[pr], 1, pc-1) new_cur substr(lines[pr], pc+1); \
	      moved = 1; \
	    } \
	  } else if (next_ch == " " || next_ch == ".") { \
	    new_next = (next_ch == ".") ? "+" : "@"; \
	    lines[nr] = substr(lines[nr], 1, nc-1) new_next substr(lines[nr], nc+1); \
	    cur_ch = substr(lines[pr], pc, 1); \
	    new_cur = (cur_ch == "+") ? "." : " "; \
	    lines[pr] = substr(lines[pr], 1, pc-1) new_cur substr(lines[pr], pc+1); \
	    moved = 1; \
	  } \
	  for (r = 0; r < rows; r++) print lines[r]; \
	  if (moved) print "MOVED" > "/dev/stderr"; \
	}' $(BOARD_FILE) > $(STATE_DIR)/tmp_board 2>$(STATE_DIR)/moved_flag && \
	mv $(STATE_DIR)/tmp_board $(BOARD_FILE); \
	if grep -q MOVED $(STATE_DIR)/moved_flag 2>/dev/null; then \
	  MOVES=$$(cat $(MOVES_FILE)); \
	  echo $$((MOVES + 1)) > $(MOVES_FILE); \
	fi

_check_win:
	@! grep -q '\$$' $(BOARD_FILE)

clean: ## Reset the game
	@rm -rf $(STATE_DIR)
	@echo "  $(DIM)Game reset.$(RESET)"
