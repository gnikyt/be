.PHONY: all
all: usage

.PHONY: build
build:
	@echo "Building finalize \"be\" file..."
	@echo "#!/bin/bash" > ./dist/be
	@tail -n +2 ./src/utils >> ./dist/be
	@tail -n +2 ./src/fns >> ./dist/be
	@tail -n +2 ./src/be >> ./dist/be
	@echo "Build complete."

.PHONY: dev
dev:
	@watch -n 1 "ls --all -l --full-time ./src | make build > /dev/null 2>&1 && echo 'Development mode running. Press Ctrl+C to stop.'"

.PHONY: usage
usage:
	@echo "Usage:"
	@echo "  make build - Build finalize `be` file"
	@echo "	 make dev   - Run for local development"
	@echo "  make usage - Display usage"
