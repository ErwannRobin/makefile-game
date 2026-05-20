include ../common-help.mk

## Usage: make play [CITY=Paris] [DAYS=3] [WLANG=fr]

CITY ?= Paris
DAYS ?= 3
WLANG ?= en

.PHONY: play forecast current clean

play: ## 🌤️  Show weather forecast
	@echo ""
	@echo "$(BOLD)$(CYAN)  ┌─────────────────────────────────┐"
	@echo "  │      ☁️  M E T E O  ☀️          │"
	@echo "  │      Weather Forecast           │"
	@echo "  └─────────────────────────────────┘$(RESET)"
	@echo ""
	@echo "  $(DIM)Fetching weather for $(BOLD)$(CITY)$(RESET)$(DIM)…$(RESET)"
	@echo ""
	@curl -sf "wttr.in/$(CITY)?$(DAYS)&lang=$(WLANG)" 2>/dev/null || \
	  (echo "  $(RED)✗ Could not fetch weather data. Check your connection or city name.$(RESET)" && exit 1)

current: ## Show current conditions only
	@echo ""
	@echo "  $(DIM)Current weather in $(BOLD)$(CITY)$(RESET)"
	@echo ""
	@curl -sf "wttr.in/$(CITY)?format=3&lang=$(WLANG)" 2>/dev/null || \
	  (echo "  $(RED)✗ Could not fetch weather data.$(RESET)" && exit 1)
	@echo ""

compact: ## Show compact one-line forecast
	@curl -sf "wttr.in/$(CITY)?format=4&lang=$(WLANG)" 2>/dev/null || \
	  (echo "  $(RED)✗ Could not fetch weather data.$(RESET)" && exit 1)
	@echo ""

week: ## Show 7-day forecast (extended)
	@echo ""
	@echo "  $(DIM)7-day forecast for $(BOLD)$(CITY)$(RESET)"
	@echo ""
	@curl -sf "wttr.in/$(CITY)?7&lang=$(WLANG)" 2>/dev/null || \
	  (echo "  $(RED)✗ Could not fetch weather data.$(RESET)" && exit 1)

moon: ## Show current moon phase
	@echo ""
	@curl -sf "wttr.in/Moon" 2>/dev/null || \
	  (echo "  $(RED)✗ Could not fetch moon data.$(RESET)" && exit 1)
