.PHONY: all
all: echotest

VERILATOR=verilator
VERILATOR_ROOT ?= $(shell bash -c 'verilator -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')
VINC := $(VERILATOR_ROOT)/include

# Ideally, we'd want -GWIDTH=12
# This requires a newer version of Verilator than I have with my distro
# Hence we have the `ifdef inside echotest.v
obj_dir/Vechotest.cpp: echotest.v
	$(VERILATOR) --trace -Wall -cc echotest.v

obj_dir/Vechotest__ALL.a: obj_dir/Vechotest.cpp
	make --no-print-directory -C obj_dir -f Vechotest.mk

echotest: echotest.cpp obj_dir/Vechotest__ALL.a
	g++ -I$(VINC) -I obj_dir            \
		$(VINC)/verilated.cpp       \
		$(VINC)/verilated_vcd_c.cpp \
		echotest.cpp obj_dir/Vechotest__ALL.a                \
		-o echotest

.PHONY: clean
clean:
	rm -rf obj_dir/ echotest echotesttrace.vcd
