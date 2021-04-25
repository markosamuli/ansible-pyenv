###
# Makefile configuration
###

.DEFAULT_GOAL := help

# We want our output silent by default, use VERBOSE=1 make <command> ...
# to get verbose output.
ifndef VERBOSE
.SILENT:
endif

###
# Define environment variables in the beginning of the file
###

VENV := venv

###
# Define local variables after environment variables
###

setup_deps = setup-dev-requirements
test_deps = setup-dev-requirements

xenial_images = $(shell $(VENV)/bin/python ./tests/update_test_images.py --list-only --release=xenial)
bionic_images = $(shell $(VENV)/bin/python ./tests/update_test_images.py --list-only --release=bionic)
focal_images = $(shell $(VENV)/bin/python ./tests/update_test_images.py --list-only --release=focal)
stretch_images = $(shell $(VENV)/bin/python ./tests/update_test_images.py --list-only --release=stretch)
buster_images = $(shell $(VENV)/bin/python ./tests/update_test_images.py --list-only --release=buster)
homebrew_images = $(shell $(VENV)/bin/python ./tests/update_test_images.py --list-only --no-git)

###
# This Makefile uses self-documenting help commands
###

.PHONY: help
help:  ## print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort -d | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: lint test ## run all linting and tests

.PHONY: clean
clean: clean-test-images ## clean generated files

.PHONY: test
test: update-test-images run-tests ## run all tests

.PHONY:
setup: $(setup_deps) ## install development dependencies

.PHONY: setup-dev-requirements
setup-dev-requirements: requirements.dev.txt | $(VENV)/bin/pip-sync
	$(VENV)/bin/pip-sync requirements.dev.txt

$(VENV)/bin/python:
	python -m venv $(VENV)

$(VENV)/bin/pip-sync $(VENV)/bin/pip-compile: | $(VENV)/bin/python
	$(VENV)/bin/pip install pip-tools

$(VENV)/bin/pylint: setup-dev-requirements

$(VENV)/bin/pre-commit: setup-dev-requirements

requirements.dev.txt: requirements.dev.in | $(VENV)/bin/pip-compile
	$(VENV)/bin/pip-compile requirements.dev.in --output-file requirements.dev.txt

tests/images/%/Dockerfile: | $(VENV)/bin/python
	$(VENV)/bin/python ./tests/update_test_images.py --dockerfile=$@

.PHONY: test-xenial
test-xenial: $(test_deps)
	$(MAKE) $(xenial_images)
	./tests/run-tests.sh $(xenial_images)

.PHONY: test-bionic
test-bionic: $(test_deps)
	$(MAKE) $(bionic_images)
	./tests/run-tests.sh $(bionic_images)

.PHONY: test-focal
test-focal: $(test_deps)
	$(MAKE) $(focal_images)
	./tests/run-tests.sh $(focal_images)

.PHONY: test-stretch
test-stretch: $(test_deps)
	$(MAKE) $(stretch_images)
	./tests/run-tests.sh $(stretch_images)

.PHONY: test-buster
test-buster: $(test_deps)
	$(MAKE) $(buster_images)
	./tests/run-tests.sh $(buster_images)

.PHONY: test-homebrew
test-homebrew: $(test_deps)
	$(MAKE) $(homebrew_images)
	./tests/run-tests.sh $(homebrew_images)

.PHONY: update-test-images
update-test-images: $(test_deps)
	$(VENV)/bin/python ./tests/update_test_images.py

.PHONY: run-tests
run-tests:
	./tests/run-tests.sh

.PHONY: clean-test-images
clean-test-images:
	cd tests && find . -not -path "./templates/*" -name "Dockerfile" -exec rm -f {} \;
	cd tests && find . -not -path "./templates/*" -name "install_homebrew.sh" -exec rm -f {} \;

.PHONY: update
update: ## update pyenv and Python versions
	./scripts/update-release.sh pyenv
	./scripts/update-release.sh pyenv-virtualenv
	./scripts/update-python.sh python37
	./scripts/update-python.sh python38

PRE_COMMIT_HOOKS = .git/hooks/pre-commit
PRE_PUSH_HOOKS = .git/hooks/pre-push
COMMIT_MSG_HOOKS = .git/hooks/commit-msg

.PHONY: lint
lint: install-git-hooks | $(VENV)/bin/pre-commit ## lint all files
	$(VENV)/bin/pre-commit run -a

.PHONY: install-git-hooks
install-git-hooks: $(PRE_COMMIT_HOOKS) $(PRE_PUSH_HOOKS) $(COMMIT_MSG_HOOKS)

$(PRE_COMMIT_HOOKS):
	$(VENV)/bin/pre-commit install --install-hooks

$(PRE_PUSH_HOOKS):
	$(VENV)/bin/pre-commit install --install-hooks -t pre-push

$(COMMIT_MSG_HOOKS):
	$(VENV)/bin/pre-commit install --install-hooks -t commit-msg
