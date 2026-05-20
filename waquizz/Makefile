include ../common-help.mk

DEBUG ?= 0
CURL_OPTS := $(if $(filter 1,$(DEBUG)),-v --stderr /tmp/waquizz/curl_debug.log,-sf)

##@ Options
## AMOUNT=N      Number of questions (default: 5)
## DIFFICULTY=X  easy | medium | hard
## CATEGORY=X    all | 9=General | 17=Science | 19=Math | 21=Sports | 23=History | 27=Animals
## DEBUG=1       Enable verbose curl logging

BASE_URL  := https://cievvxqsxqoadeiwojpd.supabase.co/functions/v1
STATE_DIR := /tmp/waquizz
GAME_FILE := $(STATE_DIR)/game.json

AMOUNT     ?= 5
CATEGORY   ?= all
DIFFICULTY ?= easy

.PHONY: play setup create join start clean

# ─────────────────────────────────────────────
#  ENTRY POINT
# ─────────────────────────────────────────────

play: _check_deps setup create join start _game_loop ## Start a trivia game

# ─────────────────────────────────────────────
#  DEPENDENCY CHECK
# ─────────────────────────────────────────────

_check_deps:
	@for cmd in curl jq uuidgen; do \
	  if ! command -v $$cmd >/dev/null 2>&1; then \
	    echo "$(RED)✗ Missing dependency: $$cmd$(RESET)"; \
	    echo "  Install with: brew install $$cmd  (macOS)"; \
	    echo "               apt install $$cmd  (Debian/Ubuntu)"; \
	    exit 1; \
	  fi; \
	done
	@echo "$(DIM)✓ Dependencies OK$(RESET)"

# ─────────────────────────────────────────────
#  SETUP — create state directory & fresh IDs
# ─────────────────────────────────────────────

setup:
	@mkdir -p $(STATE_DIR)
	@echo '{}' > $(GAME_FILE)
	@uuidgen > $(STATE_DIR)/session_id
	@echo ""
	@echo "$(CYAN)$(BOLD)  ┌─────────────────────────────┐"
	@echo "  │        W a Q u i z z        │"
	@echo "  │       Solo trivia game      │"
	@echo "  └─────────────────────────────┘$(RESET)"
	@echo ""
	@echo "  $(DIM)Questions : $(AMOUNT)$(RESET)"
	@echo "  $(DIM)Category  : $(CATEGORY)$(RESET)"
	@echo "  $(DIM)Difficulty: $(DIFFICULTY)$(RESET)"
	@echo ""

# ─────────────────────────────────────────────
#  1. CREATE GAME
# ─────────────────────────────────────────────

create:
	@echo "$(DIM)→ Creating game…$(RESET)"
	@RESP=$$(curl $(CURL_OPTS) -X POST "$(BASE_URL)/host-operations" \
	  -H "Content-Type: application/json" \
	  -d "{\"action\":\"create_solo_game\",\"amount\":$(AMOUNT),\"category\":\"$(CATEGORY)\",\"difficulty\":\"$(DIFFICULTY)\"}" \
	); \
	if [ -z "$$RESP" ]; then echo "$(RED)✗ No response from server$(RESET)"; exit 1; fi; \
	OK=$$(echo "$$RESP" | jq -r '.ok // false'); \
	if [ "$$OK" != "true" ]; then \
	  ERR=$$(echo "$$RESP" | jq -r '.error // "unknown error"'); \
	  echo "$(RED)✗ Failed to create game: $$ERR$(RESET)"; exit 1; \
	fi; \
	echo "$$RESP" | jq -r '.gameId'    > $(STATE_DIR)/game_id; \
	echo "$$RESP" | jq -r '.hostToken' > $(STATE_DIR)/host_token; \
	echo "$(DIM)✓ Game created (id: $$(cat $(STATE_DIR)/game_id))$(RESET)"

# ─────────────────────────────────────────────
#  2. JOIN GAME
# ─────────────────────────────────────────────

join:
	@echo "$(DIM)→ Joining game…$(RESET)"
	@RESP=$$(curl $(CURL_OPTS) -X POST "$(BASE_URL)/web-player" \
	  -H "Content-Type: application/json" \
	  -d "{\"action\":\"join\",\"sessionId\":\"$$(cat $(STATE_DIR)/session_id)\",\"gameId\":\"$$(cat $(STATE_DIR)/game_id)\",\"alias\":\"You\"}" \
	); \
	if [ -z "$$RESP" ]; then echo "$(RED)✗ No response from server$(RESET)"; exit 1; fi; \
	echo "$$RESP" | jq -r '.playerId // empty' > $(STATE_DIR)/player_id
	@echo "$(DIM)✓ Joined as player $$(cat $(STATE_DIR)/player_id)$(RESET)"

# ─────────────────────────────────────────────
#  3. START GAME
# ─────────────────────────────────────────────

start:
	@echo "$(DIM)→ Starting game…$(RESET)"
	@RESP=$$(curl $(CURL_OPTS) -X POST "$(BASE_URL)/host-operations" \
	  -H "Content-Type: application/json" \
	  -d "{\"action\":\"update_game\",\"gameId\":\"$$(cat $(STATE_DIR)/game_id)\",\"hostToken\":\"$$(cat $(STATE_DIR)/host_token)\",\"updates\":{\"status\":\"question\",\"current_question_index\":0}}" \
	  2>$(STATE_DIR)/curl_start.log); \
	RC=$$?; \
	if [ $$RC -ne 0 ]; then \
	  echo "$(RED)✗ Failed to start game (curl exit $$RC)$(RESET)"; \
	  [ -f $(STATE_DIR)/curl_start.log ] && cat $(STATE_DIR)/curl_start.log; \
	  exit 1; \
	fi; \
	if [ "$(DEBUG)" = "1" ]; then echo "$(DIM)[DEBUG] Response: $$RESP$(RESET)"; fi
	@echo "$(DIM)✓ Game started$(RESET)"
	@echo ""
	@echo "  $(YELLOW)Get ready…$(RESET)"
	@sleep 1

# ─────────────────────────────────────────────
#  4. GAME LOOP — polls state and dispatches
# ─────────────────────────────────────────────

_game_loop:
	@echo "-1" > $(STATE_DIR)/last_index
	@$(MAKE) -s _poll_loop

_poll_loop:
	@RESP=$$(curl $(CURL_OPTS) -X POST "$(BASE_URL)/web-player" \
	  -H "Content-Type: application/json" \
	  -d "{\"action\":\"get_state\",\"sessionId\":\"$$(cat $(STATE_DIR)/session_id)\",\"gameId\":\"$$(cat $(STATE_DIR)/game_id)\"}" \
	); \
	if [ -z "$$RESP" ]; then echo "$(RED)✗ Lost connection$(RESET)"; exit 1; fi; \
	STATUS=$$(printf '%s' "$$RESP" | jq -r '.game.status // .status'); \
	case "$$STATUS" in \
	  question) \
	    IDX=$$(printf '%s' "$$RESP" | jq -r '.game.currentQuestionIndex // .currentQuestionIndex'); \
	    LAST=$$(cat $(STATE_DIR)/last_index); \
	    if [ "$$IDX" != "$$LAST" ]; then \
	      printf '%s' "$$RESP" > $(STATE_DIR)/current_state.json; \
	      echo "$$IDX" > $(STATE_DIR)/last_index; \
	      $(MAKE) -s _render_question; \
	      $(MAKE) -s _ask_answer; \
	    fi; \
	    sleep 2; $(MAKE) -s _poll_loop ;; \
	  results) \
	    printf '%s' "$$RESP" > $(STATE_DIR)/current_state.json; \
	    $(MAKE) -s _render_results; \
	    $(MAKE) -s _advance; \
	    sleep 2; $(MAKE) -s _poll_loop ;; \
	  scoreboard) \
	    printf '%s' "$$RESP" > $(STATE_DIR)/current_state.json; \
	    $(MAKE) -s _render_scoreboard; \
	    sleep 1; $(MAKE) -s _poll_loop ;; \
	  finished) \
	    printf '%s' "$$RESP" > $(STATE_DIR)/current_state.json; \
	    $(MAKE) -s _render_finished ;; \
	  *) \
	    if [ "$(DEBUG)" = "1" ]; then printf "$(DIM)[DEBUG] Polling… status=$$STATUS response=%s$(RESET)\n" "$$RESP"; fi; \
	    sleep 2; $(MAKE) -s _poll_loop ;; \
	esac

# ─────────────────────────────────────────────
#  ADVANCE — Move to next question or finish
# ─────────────────────────────────────────────

_advance:
	@S=$(STATE_DIR)/current_state.json; \
	IDX=$$(jq -r '.game.currentQuestionIndex' $$S); \
	TOTAL=$$(jq -r '.totalQuestions' $$S); \
	NEXT=$$((IDX + 1)); \
	if [ $$NEXT -ge $$TOTAL ]; then \
	  STATUS="finished"; \
	else \
	  STATUS="question"; \
	fi; \
	curl $(CURL_OPTS) -X POST "$(BASE_URL)/host-operations" \
	  -H "Content-Type: application/json" \
	  -d "{\"action\":\"update_game\",\"gameId\":\"$$(cat $(STATE_DIR)/game_id)\",\"hostToken\":\"$$(cat $(STATE_DIR)/host_token)\",\"updates\":{\"status\":\"$$STATUS\",\"current_question_index\":$$NEXT}}" \
	  > /dev/null 2>&1

# ─────────────────────────────────────────────
#  RENDER — Question
# ─────────────────────────────────────────────

_render_question:
	@decode() { echo "$$1" | sed \
	  -e 's/&amp;/\&/g' \
	  -e 's/&lt;/</g' \
	  -e 's/&gt;/>/g' \
	  -e 's/&quot;/"/g' \
	  -e 's/&#039;/'"'"'/g' \
	  -e 's/&apos;/'"'"'/g' \
	  -e 's/&Delta;/Δ/g' \
	  -e 's/&delta;/δ/g' \
	  -e 's/&pi;/π/g' \
	  -e 's/&theta;/θ/g' \
	  -e 's/&alpha;/α/g' \
	  -e 's/&beta;/β/g' \
	  -e 's/&gamma;/γ/g' \
	  -e 's/&omega;/ω/g' \
	  -e 's/&mu;/μ/g' \
	  -e 's/&sigma;/σ/g' \
	  -e 's/&lambda;/λ/g' \
	  -e 's/&eacute;/é/g' \
	  -e 's/&egrave;/è/g' \
	  -e 's/&ecirc;/ê/g' \
	  -e 's/&agrave;/à/g' \
	  -e 's/&ccedil;/ç/g' \
	  -e 's/&ouml;/ö/g' \
	  -e 's/&uuml;/ü/g' \
	  -e 's/&auml;/ä/g' \
	  -e 's/&ntilde;/ñ/g' \
	  -e 's/&deg;/°/g' \
	  -e 's/&copy;/©/g' \
	  -e 's/&reg;/®/g' \
	  -e 's/&trade;/™/g' \
	  -e 's/&hellip;/…/g' \
	  -e 's/&ndash;/–/g' \
	  -e 's/&mdash;/—/g' \
	  -e 's/&lsquo;/'/g' \
	  -e 's/&rsquo;/'/g' \
	  -e 's/&ldquo;/"/g' \
	  -e 's/&rdquo;/"/g' \
	  -e 's/&#[0-9]\{1,\};//g' ; }; \
	S=$(STATE_DIR)/current_state.json; \
	IDX=$$(jq -r '.game.currentQuestionIndex // .currentQuestionIndex' $$S); \
	TOTAL=$(AMOUNT); \
	NUM=$$((IDX + 1)); \
	TEXT=$$(decode "$$(jq -r '.currentQuestion.text // .question.text' $$S)"); \
	A=$$(decode "$$(jq -r '.currentQuestion.choices.A // .question.choices.A // ""' $$S)"); \
	B=$$(decode "$$(jq -r '.currentQuestion.choices.B // .question.choices.B // ""' $$S)"); \
	C=$$(decode "$$(jq -r '.currentQuestion.choices.C // .question.choices.C // ""' $$S)"); \
	D=$$(decode "$$(jq -r '.currentQuestion.choices.D // .question.choices.D // ""' $$S)"); \
	echo ""; \
	printf "$(CYAN)$(BOLD)  Question $$NUM / $$TOTAL$(RESET)\n"; \
	echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
	echo ""; \
	printf "  $(BOLD)%s$(RESET)\n" "$$TEXT"; \
	echo ""; \
	[ -n "$$A" ] && printf "  $(YELLOW)[A]$(RESET) %s\n" "$$A"; \
	[ -n "$$B" ] && printf "  $(YELLOW)[B]$(RESET) %s\n" "$$B"; \
	[ -n "$$C" ] && printf "  $(YELLOW)[C]$(RESET) %s\n" "$$C"; \
	[ -n "$$D" ] && printf "  $(YELLOW)[D]$(RESET) %s\n" "$$D"; \
	echo ""

# ─────────────────────────────────────────────
#  INPUT — Ask for answer
# ─────────────────────────────────────────────

_ask_answer:
	@while true; do \
	  printf "  $(BOLD)Your answer (A/B/C/D):$(RESET) "; \
	  read ANSWER; \
	  ANSWER=$$(echo "$$ANSWER" | tr '[:lower:]' '[:upper:]' | tr -d ' '); \
	  case "$$ANSWER" in \
	    A|B|C|D) break ;; \
	    *) echo "  $(RED)Please enter A, B, C, or D$(RESET)" ;; \
	  esac; \
	done; \
	echo "$$ANSWER" > $(STATE_DIR)/pending_answer; \
	RESP=$$(curl $(CURL_OPTS) -X POST "$(BASE_URL)/web-player" \
	  -H "Content-Type: application/json" \
	  -d "{\"action\":\"answer\",\"sessionId\":\"$$(cat $(STATE_DIR)/session_id)\",\"gameId\":\"$$(cat $(STATE_DIR)/game_id)\",\"answer\":\"$$ANSWER\"}" \
	); \
	echo "$(DIM)  → Answer submitted, waiting for results…$(RESET)"

# ─────────────────────────────────────────────
#  RENDER — Results
# ─────────────────────────────────────────────

_render_results:
	@S=$(STATE_DIR)/current_state.json; \
	CORRECT_ANS=$$(jq -r '.currentQuestion.correct_answer // "?"' $$S); \
	MY_ANS=$$(jq -r '.myAnswer // "?"' $$S); \
	SCORE=$$(jq -r '.player.score // 0' $$S); \
	echo ""; \
	if [ "$$MY_ANS" = "$$CORRECT_ANS" ]; then \
	  printf "  $(GREEN)$(BOLD)✓ Correct! (Score: $$SCORE)$(RESET)\n"; \
	else \
	  printf "  $(RED)$(BOLD)✗ Wrong!$(RESET) The answer was $(GREEN)$$CORRECT_ANS$(RESET)\n"; \
	fi; \
	echo ""

# ─────────────────────────────────────────────
#  RENDER — Scoreboard
# ─────────────────────────────────────────────

_render_scoreboard:
	@S=$(STATE_DIR)/current_state.json; \
	SCORE=$$(jq -r '.player.score // 0' $$S); \
	printf "  $(DIM)Score so far: $(BOLD)$$SCORE pts$(RESET)\n"

# ─────────────────────────────────────────────
#  RENDER — Finished
# ─────────────────────────────────────────────

_render_finished:
	@S=$(STATE_DIR)/current_state.json; \
	SCORE=$$(jq -r '.player.score // 0' $$S); \
	MAX=$$(($(AMOUNT) * 1500)); \
	echo ""; \
	echo "  $(CYAN)$(BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"; \
	echo "  $(CYAN)$(BOLD)  Game Over!$(RESET)"; \
	echo "  $(CYAN)$(BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"; \
	echo ""; \
	printf "  Final score: $(BOLD)$$SCORE / $$MAX$(RESET)\n"; \
	echo ""; \
	PCT=$$((SCORE * 100 / MAX)); \
	if [ $$PCT -ge 70 ]; then \
	  echo "  $(GREEN)$(BOLD)🏆 Excellent performance!$(RESET)"; \
	elif [ $$PCT -ge 40 ]; then \
	  echo "  $(YELLOW)$(BOLD)👍 Good effort!$(RESET)"; \
	else \
	  echo "  $(DIM)📚 Keep practicing!$(RESET)"; \
	fi; \
	echo ""; \
	echo "  Run $(BOLD)make play$(RESET) to play again."
	@echo ""

# ─────────────────────────────────────────────
#  CLEAN — Remove state files
# ─────────────────────────────────────────────

clean: ## Remove game state files
	@rm -rf $(STATE_DIR)
	@echo "$(DIM)State cleared$(RESET)"
