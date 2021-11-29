.PHONY: all
all: helloworld

VERILATOR=verilator
VERILATOR_ROOT ?= $(shell bash -c 'verilator -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')
VINC := $(VERILATOR_ROOT)/include

# Ideally, we'd want -GWIDTH=12
# This requires a newer version of Verilator than I have with my distro
# Hence we have the `ifdef inside helloworld.v
obj_dir/Vhelloworld.cpp: helloworld.v
	$(VERILATOR) --trace -Wall -cc helloworld.v

obj_dir/Vhelloworld__ALL.a: obj_dir/Vhelloworld.cpp
	make --no-print-directory -C obj_dir -f Vhelloworld.mk

helloworld: helloworld.cpp obj_dir/Vhelloworld__ALL.a
	g++ -I$(VINC) -I obj_dir            \
		$(VINC)/verilated.cpp       \
		$(VINC)/verilated_vcd_c.cpp \
		helloworld.cpp obj_dir/Vhelloworld__ALL.a                \
		-o helloworld

.PHONY: clean
clean:
	rm -rf obj_dir/ helloworld helloworldtrace.vcd
