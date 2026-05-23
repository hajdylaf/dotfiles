.PHONY: test test-curl test-local run clean lint

test: test-local test-curl

test-curl:
	docker build --no-cache --target curl-pipe -t dotfiles-curl .

test-local:
	docker build --no-cache --target local -t dotfiles-local .

run:
	docker run -it dotfiles-curl

clean:
	docker rmi dotfiles-curl dotfiles-local 2>/dev/null || true

lint:
	shellcheck modules/*.sh setup.sh
