INTERPRETER=../lucid/dpt
COMPILER=../lucid/./dptc
IMAGE=jsonch/lucid:lucid
BUILD_DIR=target-route-updates
MAIN_FILE=src/dpt/tango/TangoMeasurementUpdates
PORTS_CONFIG=ports.json
SOURCES=$(shell find src -type f -name "*.dpt")

all: lint test compile

.PHONY: clean clobber test

lint: $(SOURCES)
	@echo "linting $(MAIN_FILE)V6ICMP.dpt..."
	@$(INTERPRETER) $(MAIN_FILE)V6ICMP.dpt

test: $(SOURCES)
	@-[[ ! -d ".venv" ]] && python3.11 -m venv .venv
	@. .venv/bin/activate
	@pip install -e .
	@pip install tox
	@tox -e py11

compile: $(SOURCES)
	@echo "compiling $(MAIN_FILE)V6ICMP.dpt [build log: $(BUILD_DIR)-v6ICMP.compile.log]..."
	@$(COMPILER) $(MAIN_FILE)V6ICMP.dpt -o $(BUILD_DIR)-v6ICMP --ports $(PORTS_CONFIG) > "$(BUILD_DIR)-v6ICMP.compile.log"
	@cat $(BUILD_DIR)-v6ICMP.compile.log | grep error > /dev/null && echo "-- ERROR compiling v6 ICMP!" || echo "-- SUCCESS compiling v6 ICMP!"

clean:
	@rm -rf $(BUILD_DIR)

clobber: clean
	@rm -rf $(shell find src -type d -name "__pycache__")
	@rm -rf $(shell find src -type d -name "*.egg-info")
