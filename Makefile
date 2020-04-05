
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
test: update-test-images run-tests ## run tests

tests/%/Dockerfile:
	$(MAKE) update-test-images

.PHONY: test-xenial
test-xenial: tests/xenial/Dockerfile tests/xenial-with-homebrew/Dockerfile
	./tests/run-tests.sh xenial xenial-with-homebrew

.PHONY: test-bionic
test-bionic: tests/bionic/Dockerfile tests/bionic-with-homebrew/Dockerfile
	./tests/run-tests.sh bionic bionic-with-homebrew

.PHONY: test-stretch
test-stretch: tests/stretch/Dockerfile tests/stretch-with-homebrew/Dockerfile
	./tests/run-tests.sh stretch stretch-with-homebrew

.PHONY: test-buster
test-buster: tests/buster/Dockerfile tests/buster-with-homebrew/Dockerfile
	./tests/run-tests.sh buster buster-with-homebrew

.PHONY: update-test-images
update-test-images:
	./tests/update-test-images.sh

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
