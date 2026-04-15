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

## Import: user-level → repo
import:
	@if [ -z "$(USER_INSTRUCTIONS_DIR)" ]; then \
		echo "No VS Code instructions directory found. Checked:"; \
		for d in $(VSCODE_DIRS); do echo "  $$d"; done; \
		exit 1; \
	fi
	@echo "User-level instructions found at: $(USER_INSTRUCTIONS_DIR)"
	@echo ""
	@FILES=$$(ls "$(USER_INSTRUCTIONS_DIR)"/*.instructions.md 2>/dev/null); \
	if [ -z "$$FILES" ]; then \
		echo "No .instructions.md files found in user directory."; \
		exit 0; \
	fi; \
	echo "Files available to import:"; \
	for f in $$FILES; do echo "  $$(basename $$f)"; done; \
	echo ""; \
	printf "Import all of these into the repo? [y/N] "; \
	read answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		cp $$FILES "$(REPO_INSTRUCTIONS_DIR)/"; \
		echo "Imported."; \
	else \
		echo "Aborted."; \
	fi
