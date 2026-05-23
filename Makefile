.PHONY: test run clean lint

test:
	docker build --no-cache -t dotfiles-test .

run:
	docker run -it dotfiles-test

clean:
	docker rmi dotfiles-test

lint:
	shellcheck modules/*.sh setup.sh
