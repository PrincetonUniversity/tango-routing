INTERPRETER=dpt
COMPILER=./dptc
IMAGE=jsonch/lucid:lucid
BUILD_DIR=target-route-updates
MAIN_FILE0=src/dpt/tango/TangoMeasurementUpdatesV4.dpt
MAIN_FILE1=src/dpt/tango/TangoMeasurementUpdatesV6.dpt
PORTS_CONFIG=ports.json
SOURCES=$(shell find src -type f -name "*.dpt")

all: lint test compile

.PHONY: clean clobber test

lint: $(SOURCES)
	@echo "linting $(MAIN_FILE0)..."
	@$(INTERPRETER) $(MAIN_FILE0)
	@echo "linting $(MAIN_FILE1)..."
	@$(INTERPRETER) $(MAIN_FILE1)

test: $(SOURCES)
	@-[[ ! -d ".venv" ]] && python3.11 -m venv .venv
	@. .venv/bin/activate
	@pip install -e .
	@pip install tox
	@tox -e py11

compile: $(SOURCES)
	@echo "compiling $(MAIN_FILE0) [build log: $(BUILD_DIR)-v4.compile.log]..."
	@$(shell $(COMPILER) $(MAIN_FILE0) -o $(BUILD_DIR)-v4 --ports $(PORTS_CONFIG) &> "$(BUILD_DIR)-v4.compile.log")
	@cat $(BUILD_DIR)-v4.compile.log | grep error &> /dev/null && echo "ERROR compiling v4!" || echo "SUCCESS compiling v4!"
	@echo ""
	@echo "compiling $(MAIN_FILE1) [build log: $(BUILD_DIR)-v6.compile.log]..."
	@$(shell $(COMPILER) $(MAIN_FILE0) -o $(BUILD_DIR)-v4 --ports $(PORTS_CONFIG) &> "$(BUILD_DIR)-v6.compile.log")
	@cat $(BUILD_DIR)-v6.compile.log | grep error &> /dev/null && echo "ERROR compiling v6!" || echo "SUCCESS compiling v6!"

clean:
	@rm -rf $(BUILD_DIR)

clobber: clean
	@rm -rf $(shell find src -type d -name "__pycache__")
	@rm -rf $(shell find src -type d -name "*.egg-info")
