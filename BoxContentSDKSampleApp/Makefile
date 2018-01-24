CARTHAGE := $(shell command -v carthage 2> /dev/null)

.PHONY : help bootstrap update clean check_carthage

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

bootstrap: check_carthage ## Build the reference app dependency framework(s) to cartfile.resolved
	# Make sure submodules handled by Carthage are up to date (as saved in Cartfile.resolved)
	$(CARTHAGE) bootstrap --platform iOS

update: check_carthage ## Update the reference app dependency framework(s) from the Cartfile to latest compatible version
	# Update Carthage-managed dependencies to the most recent available versions
	$(CARTHAGE) update --platform iOS

clean: ## Clean Carthage build directory
	# Remove Carthage products
	rm -rf ./Carthage/Build/*

check_carthage: ## Validate Carthage is installed
ifndef CARTHAGE
	@echo "Carthage not found. Install with 'brew install carthage'"
	@exit 1
endif
