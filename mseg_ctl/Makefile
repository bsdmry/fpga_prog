############################################################
BOARD=tangnano20k
FAMILY=GW2A-18
DEVICE=GW2A-LV18QN88C8/I7

SRCS=$(wildcard *.vhd)
TOP=mseg_ctl
VHDLLIBDIR=/usr/lib/ghdl/mcode/vhdl/

# <target name>: <target dependencies>
# <tab> <target commands>

YOSYS_CMD=ghdl $(SRCS) -e $(TOP);
YOSYS_CMD+=synth_gowin -json synth.json

all: bitstream.fs
	@echo "Done..."
sim:
	ghdl -a $(SRCS); ghdl -e ${TOP}_tb; ghdl -r ${TOP}_tb --vcd=${TOP}.vcd

# Logic Synthesis
synth.json: $(SRCS)
	@echo "Starting the FPGA design flow..."
	export GHDL_PREFIX=$(VHDLLIBDIR); yosys -m ghdl -p '$(YOSYS_CMD)'

# Place & Route Step
pnr.json: synth.json
	nextpnr-himbaechel         --json synth.json         --write pnr.json         --device ${DEVICE} 	--vopt family=${FAMILY}         --vopt cst=${TOP}.cst         --freq 27

# Bitstream Generation
bitstream.fs: pnr.json
	gowin_pack -d ${FAMILY} -o bitstream.fs pnr.json

# Device Programming: upload bitstream to on-chip SRAM
upload_sram: bitstream.fs
	openFPGALoader -b ${BOARD} bitstream.fs

# Device Programming: upload bitstream to on-chip Flash
upload_flash: bitstream.fs
	openFPGALoader -b ${BOARD} bitstream.fs -f

clean:
	rm -f *.fs *.json *.cf *.o

# The following targets do not represent a file.
.PHONY: all clean upload_sram upload_flash sim

# The following files can be removed when finished.
.INTERMEDIATE: synth.json pnr.json


