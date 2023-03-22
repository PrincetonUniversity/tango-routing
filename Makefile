INTERPRETER=dpt
IMAGE=jsonch/lucid:lucid

SOURCES=$(shell find src -type f -name "*.dpt")

all: lint test compile

lint: $(SOURCES)
	@$(INTERPRETER) src/dpt/tango/Tango.dpt

test: $(SOURCES)
	@$(INTERPRETER) src/dpt/tango/Tango.dpt

compile: $(SOURCES)
	@-docker pull $(IMAGE)
	@docker run -it --rm -v `pwd`:/workspace $(IMAGE) sh -c "cd /workspace && /app/dptc src/dpt/tango/Tango.dpt -o target"
