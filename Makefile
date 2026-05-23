.PHONY: test run clean lint

test:
	docker build --no-cache -t dotfiles-test .

run:
	docker run -it dotfiles-test

clean:
	docker rmi dotfiles-test 2>/dev/null || true

lint:
	shellcheck modules/*.sh setup.sh
