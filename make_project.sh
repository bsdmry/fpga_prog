#!/bin/sh

prj_name=$1
tb_name="${prj_name}_tb"

mkdir ${prj_name}
touch ${prj_name}/${prj_name}.vhd
mainfile="library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ${prj_name} is
    Port ( clk : in  STD_LOGIC
	 );
end ${prj_name};

architecture ${prj_name}_arch of ${prj_name} is
begin
	process(clk) begin

	end process;
end ${prj_name}_arch;
"
echo "$mainfile" > ${prj_name}/${prj_name}.vhd

touch ${prj_name}/${tb_name}.vhd
tbfile="library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ${tb_name} is
end ${tb_name};

architecture ${tb_name}_arch of ${tb_name} is
component ${prj_name} is port (
	clk : in std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;

begin
--	UNIT UNDER TEST
uut: ${prj_name} port map (
	clk => clk
);
--	CLK GENERATOR
clk_process : process 
begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
	if sym_stop = '1' then
		wait;
	end if;
end process;

--	TEST SIGNALS
stim_process : process
begin
	wait for 30 ns;
	-- INSERT TEST CODE HERE ---
	report \"end of test\" severity note;
	sym_stop <= '1';
	wait;
end process;

end ${tb_name}_arch;
"
echo "$tbfile" > ${prj_name}/${tb_name}.vhd

touch ${prj_name}/Makefile
makefile="############################################################
BOARD=tangnano20k
FAMILY=GW2A-18
DEVICE=GW2A-LV18QN88C8/I7

SRCS=\$(wildcard *.vhd)
TOP=${prj_name}
VHDLLIBDIR=/usr/lib/ghdl/mcode/vhdl/

# <target name>: <target dependencies>
# <tab> <target commands>

YOSYS_CMD=ghdl \$(SRCS) -e \$(TOP);
YOSYS_CMD+=synth_gowin -json synth.json

all: bitstream.fs
	@echo \"Done...\"
sim:
	ghdl -a \$(SRCS); ghdl -e \${TOP}_tb; ghdl -r \${TOP}_tb --vcd=\${TOP}.vcd

# Logic Synthesis
synth.json: \$(SRCS)
	@echo \"Starting the FPGA design flow...\"
	export GHDL_PREFIX=\$(VHDLLIBDIR); yosys -m ghdl -p '\$(YOSYS_CMD)'

# Place & Route Step
pnr.json: synth.json
	nextpnr-himbaechel \
        --json synth.json \
        --write pnr.json \
        --device \${DEVICE} \
	--vopt family=\${FAMILY} \
        --vopt cst=\${TOP}.cst \
        --freq 27

# Bitstream Generation
bitstream.fs: pnr.json
	gowin_pack -d \${FAMILY} -o bitstream.fs pnr.json

# Device Programming: upload bitstream to on-chip SRAM
upload_sram: bitstream.fs
	openFPGALoader -b \${BOARD} bitstream.fs

# Device Programming: upload bitstream to on-chip Flash
upload_flash: bitstream.fs
	openFPGALoader -b \${BOARD} bitstream.fs -f

clean:
	rm -f *.fs *.json *.cf *.o

# The following targets do not represent a file.
.PHONY: all clean upload_sram upload_flash sim

# The following files can be removed when finished.
.INTERMEDIATE: synth.json pnr.json

"
echo "$makefile" > ${prj_name}/Makefile

touch ${prj_name}/${prj_name}.cst
pinmapping="IO_LOC \"clk\"     4;

IO_PORT \"clk\"     IO_TYPE=LVCMOS33;"
echo "$pinmapping" > ${prj_name}/${prj_name}.cst
