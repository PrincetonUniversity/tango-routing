COMPILER=dpt

SOURCES=$(shell find src -type f -name "*.dpt")

all: lint compile

lint: $(SOURCES)
	@$(COMPILER) src/dpt/tango/Tango.dpt

compile: setup lint
	@echo "ERROR: compile target is *unimplemented*"
