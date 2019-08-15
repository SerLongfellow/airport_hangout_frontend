
all: init-dev

init-dev: git-hooks

git-hooks:
	cp .git-hooks/* .git/hooks/
