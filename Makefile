# Detect user-level VS Code instructions directory (works for local and server)
VSCODE_DIRS := \
	$(HOME)/.vscode-server/data/User/prompts/instructions \
	$(HOME)/.config/Code/User/prompts/instructions \
	$(HOME)/Library/Application\ Support/Code/User/prompts/instructions

USER_INSTRUCTIONS_DIR := $(firstword $(foreach d,$(VSCODE_DIRS),$(wildcard $(d))))

REPO_INSTRUCTIONS_DIR := .github/instructions

.PHONY: help export import

help:
	@echo "Targets:"
	@echo "  export   Copy repo instructions to user-level VS Code instructions"
	@echo "  import   Copy user-level VS Code instructions back into this repo"

## Export: repo → user-level
export:
	@if [ -z "$(USER_INSTRUCTIONS_DIR)" ]; then \
		echo "No VS Code instructions directory found. Checked:"; \
		for d in $(VSCODE_DIRS); do echo "  $$d"; done; \
		exit 1; \
	fi
	@echo "Exporting to: $(USER_INSTRUCTIONS_DIR)"
	@mkdir -p "$(USER_INSTRUCTIONS_DIR)"
	@cp $(REPO_INSTRUCTIONS_DIR)/*.instructions.md "$(USER_INSTRUCTIONS_DIR)/"
	@echo "Done. Copied:"
	@ls $(REPO_INSTRUCTIONS_DIR)/*.instructions.md | xargs -I{} basename {}

## Import: user-level → repo (diff-aware, per-file)
import:
	@if [ -z "$(USER_INSTRUCTIONS_DIR)" ]; then \
		echo "No VS Code instructions directory found. Checked:"; \
		for d in $(VSCODE_DIRS); do echo "  $$d"; done; \
		exit 1; \
	fi
	@echo "Scanning: $(USER_INSTRUCTIONS_DIR)"
	@echo ""
	@FILES=$$(ls "$(USER_INSTRUCTIONS_DIR)"/*.instructions.md 2>/dev/null); \
	if [ -z "$$FILES" ]; then \
		echo "No .instructions.md files found in user directory."; \
		exit 0; \
	fi; \
	imported=0; skipped=0; \
	for src in $$FILES; do \
		name=$$(basename "$$src"); \
		dest="$(REPO_INSTRUCTIONS_DIR)/$$name"; \
		if [ -f "$$dest" ]; then \
			if diff -q "$$src" "$$dest" > /dev/null 2>&1; then \
				echo "  [identical]  $$name — skipping"; \
				skipped=$$((skipped+1)); \
			else \
				echo ""; \
				echo "  [differs]  $$name"; \
				diff --color=always -u "$$dest" "$$src" | head -40; \
				echo ""; \
				printf "  Import $$name into repo? [y/N] "; \
				read answer; \
				if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
					cp "$$src" "$$dest"; \
					echo "  Imported $$name."; \
					imported=$$((imported+1)); \
				else \
					echo "  Skipped $$name."; \
					skipped=$$((skipped+1)); \
				fi; \
			fi; \
		else \
			echo ""; \
			echo "  [new]  $$name (not in repo)"; \
			printf "  Import $$name into repo? [y/N] "; \
			read answer; \
			if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
				cp "$$src" "$$dest"; \
				echo "  Imported $$name."; \
				imported=$$((imported+1)); \
			else \
				echo "  Skipped $$name."; \
				skipped=$$((skipped+1)); \
			fi; \
		fi; \
	done; \
	echo ""; \
	echo "Done. Imported: $$imported  Skipped: $$skipped"
