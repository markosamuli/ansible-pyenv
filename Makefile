PRE_COMMIT_HOOKS = .git/hooks/pre-commit
PRE_PUSH_HOOKS = .git/hooks/pre-push
COMMIT_MSG_HOOKS = .git/hooks/commit-msg

.PHONY: all
all: install-git-hooks test-update lint test

.PHONY: test
test:
	@./tests/run-tests.sh

.PHONY: test-update
test-update:
	@./tests/update.sh

.PHONY: update
update:
	@./scripts/update-release.sh pyenv
	@./scripts/update-release.sh pyenv-virtualenv
	@./scripts/update-python.sh python2
	@./scripts/update-python.sh python3

.PHONY: lint
lint: install-git-hooks
	@pre-commit run -a -v

.PHONY: install-git-hooks
install-git-hooks: $(PRE_COMMIT_HOOKS) $(PRE_PUSH_HOOKS) $(COMMIT_MSG_HOOKS)

$(PRE_COMMIT_HOOKS):
	@pre-commit install --install-hooks

$(PRE_PUSH_HOOKS):
	@pre-commit install --install-hooks -t pre-push

$(COMMIT_MSG_HOOKS):
	@pre-commit install --install-hooks -t commit-msg
