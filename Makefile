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

update_test_images := ./tests/update_test_images.py

archlinux_template = tests/templates/Dockerfile.archlinux.jinja2
archlinux_images := tests/images/archlinux/Dockerfile

debian_template = tests/templates/Dockerfile.debian.jinja2
ubuntu_images = $(shell $(VENV)/bin/python $(update_test_images) --list-only --distrib=ubuntu $(TEST_IMAGE_OPTS))
debian_images = $(shell $(VENV)/bin/python $(update_test_images) --list-only --distrib=debian $(TEST_IMAGE_OPTS))
focal_images = $(shell $(VENV)/bin/python $(update_test_images) --list-only --release=focal $(TEST_IMAGE_OPTS))
jammy_images = $(shell $(VENV)/bin/python $(update_test_images) --list-only --release=jammy --no-homebrew $(TEST_IMAGE_OPTS))
bullseye_images = $(shell $(VENV)/bin/python $(update_test_images) --list-only --release=bullseye $(TEST_IMAGE_OPTS))

homebrew_images = $(shell $(VENV)/bin/python $(update_test_images) --list-only --no-git)

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

$(archlinux_images): $(archlinux_template) $(update_test_images) | $(VENV)/bin/python
	$(VENV)/bin/python $(update_test_images) --dockerfile=$@

tests/images/%/Dockerfile: $(debian_template) $(update_test_images) | $(VENV)/bin/python
	$(VENV)/bin/python $(update_test_images) --dockerfile=$@

.PHONY: test-ubuntu
test-ubuntu: $(test_deps)
	$(MAKE) $(ubuntu_images)
	./tests/run-tests.sh $(ubuntu_images) $(TEST_RUN_OPTS)

.PHONY: test-focal
test-focal: $(test_deps)
	$(MAKE) $(focal_images)
	./tests/run-tests.sh $(focal_images) $(TEST_RUN_OPTS)

.PHONY: test-jammy
test-jammy: $(test_deps)
	$(MAKE) $(jammy_images)
	./tests/run-tests.sh $(jammy_images) $(TEST_RUN_OPTS)

.PHONY: test-debian
test-debian: $(test_deps)
	$(MAKE) $(debian_images)
	./tests/run-tests.sh $(debian_images) $(TEST_RUN_OPTS)

.PHONY: test-bullseye
test-bullseye: $(test_deps)
	$(MAKE) $(bullseye_images)
	./tests/run-tests.sh $(bullseye_images) $(TEST_RUN_OPTS)

.PHONY: test-archlinux
test-archlinux: $(test_deps)
	$(MAKE) $(archlinux_images)
	./tests/run-tests.sh $(archlinux_images) $(TEST_RUN_OPTS)

.PHONY: test-homebrew
test-homebrew: $(test_deps)
	$(MAKE) $(homebrew_images)
	./tests/run-tests.sh $(homebrew_images)

.PHONY: update-test-images
update-test-images: $(test_deps)
	$(VENV)/bin/python ./tests/update_test_images.py $(TEST_IMAGE_OPTS)

.PHONY: run-tests
run-tests:
	./tests/run-tests.sh $(TEST_RUN_OPTS)

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
	./scripts/update-python.sh python39
	./scripts/update-python.sh python310

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
