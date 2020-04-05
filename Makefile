
.PHONY: default
default: help

.PHONY: help
help:  ## print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: install-git-hooks test-update lint test ## run all linting and tests

.PHONY: test
test: ## test the role in Linux
	@./tests/run-tests.sh

.PHONY: test-update
test-update: ## update test Docker images
	@./tests/update.sh

.PHONY: update
update: ## update pyenv and Python versions
	@./scripts/update-release.sh pyenv
	@./scripts/update-release.sh pyenv-virtualenv
	@./scripts/update-python.sh python37
	@./scripts/update-python.sh python38

PRE_COMMIT_HOOKS = .git/hooks/pre-commit
PRE_PUSH_HOOKS = .git/hooks/pre-push
COMMIT_MSG_HOOKS = .git/hooks/commit-msg

.PHONY: lint
lint: install-git-hooks  ## lint all files
	@pre-commit run -a

.PHONY: install-git-hooks
install-git-hooks: $(PRE_COMMIT_HOOKS) $(PRE_PUSH_HOOKS) $(COMMIT_MSG_HOOKS)

$(PRE_COMMIT_HOOKS):
	@pre-commit install --install-hooks

$(PRE_PUSH_HOOKS):
	@pre-commit install --install-hooks -t pre-push

$(COMMIT_MSG_HOOKS):
	@pre-commit install --install-hooks -t commit-msg
