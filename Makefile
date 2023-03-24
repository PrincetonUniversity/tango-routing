INTERPRETER=dpt
COMPILER=dptc
IMAGE=jsonch/lucid:lucid
BUILD_DIR=target
MAIN_FILE=src/dpt/tango/Tango.dpt
SOURCES=$(shell find src -type f -name "*.dpt")

all: lint test compile

.PHONY: clean clobber test

lint: $(SOURCES)
	@$(INTERPRETER) $(MAIN_FILE)

test: $(SOURCES)
	@-[[ ! -d ".venv" ]] && python3.11 -m venv .venv
	@. .venv/bin/activate
	@pip install -e .
	@pip install tox
	@tox -e py11

compile: $(SOURCES)
	@$(COMPILER) $(MAIN_FILE) -o $(BUILD_DIR)

clean:
	@rm -rf $(BUILD_DIR)

clobber: clean
	@rm -rf $(shell find src -type d -name "__pycache__")
	@rm -rf $(shell find src -type d -name "*.egg-info")