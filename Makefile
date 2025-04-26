# User & File Configuration
base=cpu
suff=_tb
lang=1
extra_src=
extra_h=
# For SystemVerilog / Verilog building
fpga=ice40#                        FPGA
device=8k#                         }
timedev=hx8k#                      } Model details
footprint=ct256#                   }
top=top_$(base)#                   Top module
pcf=pinmap.pcf#                    Pin constraint file
build_dir=./build-$(base)-$(fpga)# Directory to store build files
#######################

# Language Configuration - Extensions, Compilers, Flags
# SystemVerilog
ext=sv
ext_h=svh
cc=iverilog
cc_flags=-g2012
# SystemVerilog / Verilog Simulation Specific
ext_wv=vcd
cc_wv=gtkwave
cc_wv_flags=
cc_linter=verilator
cc_linter_flags=--lint-only -Werror-WIDTH -Werror-SELRANGE -Werror-COMBDLY -Werror-LATCH -Werror-MULTIDRIVEN
# SystemVerilog / Verilog Build Specific
rtl_synth=yosys#                        RTL Synthesis tool
router=nextpnr-$(fpga)#                 FPGA Routing & Placing tool
router_flags=--pcf-allow-unconstrained# --gui then pack place route for visual placement & routing
pack=icepack#                           Tool for bitstream file handling
prog=iceprog#                           Tool for flashing
#######################

# File Configuration
src=$(base).$(ext)#           base.ext
src_h=$(base).$(ext_h) #      base.ext_h
src_tb=$(base)$(suff).$(ext)# base_tb.ext
exec=$(base)$(suff)#          base_tb
exec_wv=$(exec).$(ext_wv)#    base_tb.ext_wv
topc=$(top).$(ext)#           top_base.ext
src_json=$(base).json#        base.json
src_asc=$(base).asc#          base.asc
src_bin=$(base).bin#          base.bin
src_uf2=$(base).uf2#          base.uf2
#######################

# Targets
# Executable file compilation
$(exec): $(src) $(extra_src) $(src_tb) $(src_h) $(extra_h)
ifeq ($(shell expr $(lang) \<= 2),1)# Lints source files with cc_linter for HDL
	$(cc_linter) $(src) $(extra_src) $(cc_linter_flags)
endif
	$(cc) -o $@ $(src) $(extra_src) $(src_tb) $(cc_flags)
# Waveform executable check
$(exec_wv): $(exec)
# Run the executable file
test: $(exec)
	./$<
# Run waveforms
sim: hdl_guard $(exec_wv) test
	$(cc_wv) $(exec_wv) $(cc_wv_flags)
# Synthesize code for FPGA
synth: hdl_guard $(src) $(extra_src) $(topc)
	mkdir -p $(build_dir)
	$(rtl_synth) -p "synth_$(fpga) -top $(top) -json $(build_dir)/$(src_json)" $(topc) $(src) $(extra_src)
# Place & Route for FPGA
route: synth $(pcf)
	$(router) --$(timedev) --package $(footprint) --json $(build_dir)/$(src_json) --pcf $(pcf) --asc $(build_dir)/$(src_asc) $(router_flags)
# Bitstream handling for FPGA
bits: route
	$(pack) $(build_dir)/$(src_asc) $(build_dir)/$(src_bin)
# Flashing to FPGA
flash: bits
	bin2uf2 -o $(build_dir)/$(src_uf2) $(build_dir)/$(src_bin)
#$(prog) -S $(build_dir)/$(src_bin)
# Guard for HDL specific commands
hdl_guard:
ifeq ($(shell expr $(lang) \> 2), 1)
	@echo "Error: Command not applicable for lang="$(lang); exit 2
endif
	@echo "Success: HDL Guard check"
# Clean all test files
clean-exec:
	rm -f $(exec) *.o *.$(ext_wv)
clean-gcov:
	rm -f $(exec_gcov) *.gcda *.gcno *.c.gcov *.gcov
clean-build:
	rm -f $(build_dir)/*.json $(build_dir)/*.asc $(build_dir)/*.bin $(build_dir)/*.uf2
	rm -d $(build_dir)
clean: clean-exec clean-gcov clean-build
#######################

# PHONY Commands
.PHONY: test sim synth route bits flash coverage hdl_guard clean-exec clean-gcov clean-build clean