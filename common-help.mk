# This is a minimal set of ANSI/VT100 color codes
_END=$'\x1b[0m
_BOLD=$'\x1b[1m
_DIM=$'\x1b[2m
_UNDER=$'\x1b[4m
_REV=$'\x1b[7m

# Colors
_GREY=$'\x1b[30m
_RED=$'\x1b[31m
_GREEN=$'\x1b[32m
_YELLOW=$'\x1b[33m
_BLUE=$'\x1b[34m
_PURPLE=$'\x1b[35m
_CYAN=$'\x1b[36m
_WHITE=$'\x1b[37m

# Printable escape codes (for use in recipe echo/printf)
BOLD  := \033[1m
DIM   := \033[2m
RESET := \033[0m
RED   := \033[31m
GREEN := \033[32m
YELLOW:= \033[33m
CYAN  := \033[36m

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make ${_CYAN}${_END}\n"} /^[$$()% a-zA-Z0-9_-]+:.*?##/ { printf "  ${_CYAN}%-15s${_END} %s\n", $$1, $$2 } /^##@/ { printf "\n${_BOLD}%s${_END}\n", substr($$0, 5) } /^## [^@]/ { printf "  ${_DIM}%s${_END}\n", substr($$0, 4) } ' $(MAKEFILE_LIST)
