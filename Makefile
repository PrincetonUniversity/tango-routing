LUCID_SRC=./lucid
COMPILER=./lucid/lucid.sh

SOURCES=$(shell find src -type f -name "*.dpt")

all: setup interpret compile

setup:
	@-[ ! -d "$(LUCID_SRC)" ] && git clone https://github.com/PrincetonUniversity/lucid/ ||:
	@$(COMPILER) pull ||:
 
interpret: setup $(SOURCES)
	@echo "ERROR: interpret target is *unimplemented*"

compile: setup interpret
	@echo "ERROR: compile target is *unimplemented*"

.PHONY: clean

clean:
	rm -rf $(LUCID_SRC)