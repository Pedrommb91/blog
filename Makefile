.DEFAULT_GOAL := help

export LC_ALL=en_US.UTF-8

.PHONY: help
help: ## Help command
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: run
run: ## Run hugo site locally
	hugo server

.PHONY: build
build: ## Build hugo site into public folder
	hugo -t hugo-theme-stack

.PHONY: new-page
new-page: ## Create a new page
	@read -p "Enter the page title: " title; \
	hugo new --kind page "pages/$$title.md"
