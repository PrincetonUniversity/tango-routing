LUCID_SRC=./lucid
COMPILER=./lucid/lucid.sh

SOURCES=$(shell find src -type f -name "*.dpt")

all: setup lint compile

setup:
	@-[ ! -d "$(LUCID_SRC)" ] && git clone https://github.com/PrincetonUniversity/lucid/ ||:
	@$(COMPILER) pull ||:
 
lint: setup $(SOURCES)
	@docker run -it --rm -v `pwd`:/workspace jsonch/lucid:lucid sh -c "cd /workspace && /app/dpt src/Tango.dpt --symb build.symb"

compile: setup lint
	@echo "ERROR: compile target is *unimplemented*"

.PHONY: clean

clean:
	rm -rf $(LUCID_SRC)