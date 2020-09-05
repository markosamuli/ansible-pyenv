
.PHONY: default
default: help

.PHONY: help
help:  ## print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: lint test ## run all linting and tests

.PHONY: clean
clean: clean-test-images ## clean generated files

.PHONY: test
test: update-test-images run-tests ## run all tests

tests/images/%/Dockerfile:
	./tests/update_test_images.py --dockerfile=$@

xenial_images = $(shell ./tests/update_test_images.py --list-only --release=xenial)

.PHONY: test-xenial
test-xenial: $(xenial_images)
	./tests/run-tests.sh $(xenial_images)

bionic_images = $(shell ./tests/update_test_images.py --list-only --release=bionic)

.PHONY: test-bionic
test-bionic: $(bionic_images)
	./tests/run-tests.sh $(bionic_images)

focal_images = $(shell ./tests/update_test_images.py --list-only --release=focal)

.PHONY: test-focal
test-focal: $(focal_images)
	./tests/run-tests.sh $(focal_images)

stretch_images = $(shell ./tests/update_test_images.py --list-only --release=stretch)

.PHONY: test-stretch
test-stretch: $(stretch_images)
	./tests/run-tests.sh $(stretch_images)

buster_images = $(shell ./tests/update_test_images.py --list-only --release=buster)

.PHONY: test-buster
test-buster: $(buster_images)
	./tests/run-tests.sh $(buster_images)

homebrew_images = $(shell ./tests/update_test_images.py --list-only --no-git)

.PHONY: test-homebrew
test-homebrew: $(homebrew_images)
	./tests/run-tests.sh $(homebrew_images)

.PHONY: update-test-images
update-test-images:
	./tests/update_test_images.py

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
lint: install-git-hooks  ## lint all files
	pre-commit run -a

.PHONY: install-git-hooks
install-git-hooks: $(PRE_COMMIT_HOOKS) $(PRE_PUSH_HOOKS) $(COMMIT_MSG_HOOKS)

$(PRE_COMMIT_HOOKS):
	pre-commit install --install-hooks

$(PRE_PUSH_HOOKS):
	pre-commit install --install-hooks -t pre-push

$(COMMIT_MSG_HOOKS):
	pre-commit install --install-hooks -t commit-msg
