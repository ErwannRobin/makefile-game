include ../common-help.mk

STATE_DIR := /tmp/wordle
WORD_FILE := $(STATE_DIR)/word
GUESSES_FILE := $(STATE_DIR)/guesses
MAX_ATTEMPTS := 6

WORDS := crane slate audio adieu stare roate arise alone about above \
         after again alert alien align alive allow along alter among \
         angel anger angle apart apple apply arena argue aside asset \
         avoid awake badge baker baron basic batch beach began begin \
         being below bench birth black blade blame blank blast blaze \
         bleed blend bless blind block blood bloom blown board boost \
         bound brain brand brave bread break breed brick brief bring \
         broad broke brown brush build burst buyer cabin cable carry \
         catch cause chain chair charm chase cheap check chess chief \
         child china chose civic claim class clean clear climb clock \
         close cloud coach coast color comes comic coral could count \
         court cover craft crash crazy cream crime cross crowd crown \
         cruel curve cycle daily dance death debug decay depth dirty \
         doubt draft drain drama drawn dream dress drift drink drive \
         eager early earth eight elder elite empty enemy enjoy enter \
         equal error event every exact exist extra faint faith false \
         fault feast fever fiber field fifth fifty fight final first \
         flame flash flesh float flood floor flour fluid focus force \
         forge found frame frank fraud fresh front frost fruit fully \
         giant given glass globe gloom glory glove going grace grade \
         grain grand grant grass grave great green greet grief grill \
         grind gross group grove grown guard guess guide happy harsh \
         heart heavy hence horse hotel house human humor ideal image \
         imply index inner input issue ivory joint judge juice known \
         label large later laugh layer learn least legal level light \
         limit linen local loose lover lower loyal lucky lunar lunch \
         magic major maker march match mayor meant media mercy metal \
         might minor minus model money month moral motor mount mouth \
         movie music naive nerve never night noble noise north novel \
         nurse occur ocean offer often opera order other outer owner \
         paint panel paper party patch peace phase phone photo piano \
         piece pilot pitch place plain plane plant plate plaza plead \
         point pound power press price pride prime print prior prize \
         proof proud prove psalm queen quick quiet quite quota radar \
         radio raise range rapid ratio reach react ready realm rebel \
         refer reign relax reply right rival river robot roman rouge \
         round route royal ruler rural saint salad scale scene scope \
         score sense serve seven shade shake shall shame shape share \
         sharp sheep sheer shelf shell shift shine shirt shock shore \
         short shout sight since sixth sixty skill slash sleep slice \
         slide small smart smell smile smoke snack solar solid solve \
         sorry sound south space spare speak speed spend spike spine \
         split spoke spoon sport squad staff stage stake stall stamp \
         stand stare start state steak steal steam steel steep steer \
         stern stick still stock stone stood store storm story stove \
         strip stuck study stuff style sugar suite super surge sweet \
         sweep swift swing sword taste teach tempo tense thank theft \
         theme thick thing think third those three throw tight timer \
         tired title today topic total touch tough tower trace track \
         trade trail train trait treat trend trial tribe trick troop \
         truck truly trunk trust truth tumor twice twist ultra uncle \
         under union unite unity until upper upset urban usage usual \
         valid value video vigor virus visit vital vivid vocal voice \
         waste watch water weigh weird wheat where which while white \
         whole whose woman world worry worse worst worth would wound \
         write wrong yield young youth

.PHONY: play clean

play: ## 🟩 Wordle — guess the 5-letter word
	@mkdir -p $(STATE_DIR)
	@WORD=$$(echo $(WORDS) | tr ' ' '\n' | awk 'BEGIN{srand()} {w[NR]=$$1} END{print w[int(rand()*NR)+1]}'); \
	echo "$$WORD" > $(WORD_FILE)
	@: > $(GUESSES_FILE)
	@echo ""
	@echo "$(BOLD)$(GREEN)  ┌─────────────────────────────┐"
	@echo "  │       W O R D L E           │"
	@echo "  │    Guess the 5-letter word   │"
	@echo "  └─────────────────────────────┘$(RESET)"
	@echo ""
	@echo "  $(DIM)You have $(MAX_ATTEMPTS) attempts.$(RESET)"
	@echo "  $(GREEN)█$(RESET) = correct spot  $(YELLOW)█$(RESET) = wrong spot  $(DIM)█$(RESET) = not in word"
	@echo ""
	@$(MAKE) --no-print-directory _turn

_turn:
	@WORD=$$(cat $(WORD_FILE)); \
	ATTEMPTS=$$(wc -l < $(GUESSES_FILE) | tr -d ' '); \
	if [ "$$ATTEMPTS" -ge $(MAX_ATTEMPTS) ]; then \
	  echo ""; \
	  echo "  $(RED)$(BOLD)✗ Game Over! The word was: $$WORD$(RESET)"; \
	  echo ""; \
	  exit 0; \
	fi; \
	echo "  $(DIM)Attempt $$((ATTEMPTS + 1)) / $(MAX_ATTEMPTS)$(RESET)"; \
	while true; do \
	  printf "  $(BOLD)Enter guess: $(RESET)"; \
	  read GUESS; \
	  GUESS=$$(echo "$$GUESS" | tr 'A-Z' 'a-z'); \
	  LEN=$${#GUESS}; \
	  if [ "$$LEN" -ne 5 ]; then \
	    echo "  $(RED)Must be exactly 5 letters.$(RESET)"; \
	    continue; \
	  fi; \
	  if echo "$$GUESS" | grep -q '[^a-z]'; then \
	    echo "  $(RED)Letters only.$(RESET)"; \
	    continue; \
	  fi; \
	  break; \
	done; \
	echo "$$GUESS" >> $(GUESSES_FILE); \
	$(MAKE) --no-print-directory _render; \
	if [ "$$GUESS" = "$$WORD" ]; then \
	  ATTEMPTS=$$(wc -l < $(GUESSES_FILE) | tr -d ' '); \
	  echo "  $(GREEN)$(BOLD)✓ Brilliant! You got it in $$ATTEMPTS/$(MAX_ATTEMPTS)!$(RESET)"; \
	  echo ""; \
	  exit 0; \
	fi; \
	$(MAKE) --no-print-directory _turn

_render:
	@WORD=$$(cat $(WORD_FILE)); \
	echo ""; \
	while IFS= read -r GUESS; do \
	  printf "  "; \
	  i=0; \
	  while [ $$i -lt 5 ]; do \
	    GL=$$(echo "$$GUESS" | cut -c$$((i+1))); \
	    WL=$$(echo "$$WORD" | cut -c$$((i+1))); \
	    if [ "$$GL" = "$$WL" ]; then \
	      printf '\033[1;37;42m %s \033[0m' "$$GL"; \
	    elif echo "$$WORD" | grep -q "$$GL"; then \
	      printf '\033[1;37;43m %s \033[0m' "$$GL"; \
	    else \
	      printf '\033[1;37;100m %s \033[0m' "$$GL"; \
	    fi; \
	    i=$$((i + 1)); \
	  done; \
	  echo ""; \
	done < $(GUESSES_FILE); \
	ATTEMPTS=$$(wc -l < $(GUESSES_FILE) | tr -d ' '); \
	REMAINING=$$(($(MAX_ATTEMPTS) - ATTEMPTS)); \
	i=0; \
	while [ $$i -lt $$REMAINING ]; do \
	  printf "  "; \
	  j=0; \
	  while [ $$j -lt 5 ]; do \
	    printf '\033[0;90m _ \033[0m'; \
	    j=$$((j + 1)); \
	  done; \
	  echo ""; \
	  i=$$((i + 1)); \
	done; \
	echo ""

clean: ## Reset the game
	@rm -rf $(STATE_DIR)
	@echo "  $(DIM)Game reset.$(RESET)"
