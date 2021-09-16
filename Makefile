.PHONY: build run clean-test test

TEST_CONTAINER_NAME = github-actions-test
TEST_CONTAINER_ID := $(shell docker ps -aq --filter "name=${TEST_CONTAINER_NAME}")

build:
	@echo "---> Build docker image"
	@docker build --target dependencies -t github-actions:dependencies .

run:
	@echo "---> Running github actions"
	@docker build --target lambda -t github-actions:latest .
	@docker run -p 8080:8080 github-actions:latest

clean-test:
	@echo "---> Cleaning up old docker artifacts..."
ifdef TEST_CONTAINER_ID
	@echo "---> Found container, stoping and removing..."
	@docker stop "${TEST_CONTAINER_NAME}" > /dev/null
	@docker rm -fv "${TEST_CONTAINER_NAME}" > /dev/null
else
	@echo "---> No artifacts found."
endif
	@rm -rf htmlcov
	@rm -f coverage.xml
	@echo "Done cleaning."

test: clean-test
	@echo "---> Running github actions tests"
	@docker build --target test -t github-actions:test .
	@docker run --name "${TEST_CONTAINER_NAME}" github-actions:test
	@docker cp "${TEST_CONTAINER_NAME}:/app/htmlcov" .
	@docker cp "${TEST_CONTAINER_NAME}:/app/coverage.xml" .