.RECIPEPREFIX = >
CC      = riscv64-unknown-elf-gcc
OBJCOPY = riscv64-unknown-elf-objcopy
CFLAGS  = -march=rv32i_zicsr -fno-tree-loop-distribute-patterns -mabi=ilp32 -Os -Wall -ffreestanding -nostdlib -nostartfiles -Ithird_party/picorv32/firmware
PICO    = third_party/picorv32/picorv32.v
RTL     = rtl/soc_top.v rtl/soc_core.v rtl/soc_periph.v rtl/dma_ctrl.v $(PICO)

all: sim-soc

sw/fw.elf: sw/start.S sw/main.c sw/link.ld
> $(CC) $(CFLAGS) -T sw/link.ld sw/start.S sw/main.c -o $@

sw/fw.hex: sw/fw.elf
> $(OBJCOPY) -O binary $< sw/fw.bin
> od -An -v -tx4 -w4 sw/fw.bin > $@
> od -An -v -tx1 -w4 sw/fw.bin | awk '{for(k=0;k<4;k++) print ($$(k+1)=="" ? "00" : $$(k+1)) > ("sw/fw" k ".hex")}'

sim-soc: sw/fw.hex tb/tb_soc.v $(RTL)
> verilator --binary --timing --trace -Wno-fatal $(RTL) tb/tb_soc.v --top-module tb_soc
> ./obj_dir/Vtb_soc | tee soc.log
> grep -q "^PASS" soc.log

sim-dma: rtl/dma_ctrl.v tb/tb_dma.v
> verilator --binary --timing --trace -Wno-fatal --Mdir obj_dma rtl/dma_ctrl.v tb/tb_dma.v --top-module tb_dma
> ./obj_dma/Vtb_dma | tee dma.log
> grep -q "^PASS" dma.log

test: lint sim-dma sim-soc
> @echo "== TAT CA TEST DAT =="

clean:
> rm -rf obj_dir obj_dma sw/fw.elf sw/fw.bin sw/fw.hex sw/fw?.hex soc.vcd dump.vcd soc.log dma.log fpga/*.json fpga/*.fs fpga/*.log

# ---------------- FPGA: Sipeed Tang Nano 20K (GW2AR-18) ----------------
OSS      ?= $(HOME)/tools/oss-cad-suite/bin
FPGA_RTL  = fpga/tangnano20k_top.v rtl/soc_top.v rtl/soc_core.v rtl/soc_periph.v rtl/dma_ctrl.v $(PICO)

fpga/soc.fs: sw/fw.hex fpga/tangnano20k.cst $(FPGA_RTL)
> $(OSS)/yosys -q -l fpga/synth.log -p "read_verilog -sv $(DEFS) $(FPGA_RTL); synth_gowin $(SYNTH_OPT) -top tangnano20k_top -family gw2a -json fpga/soc_synth.json"
> $(OSS)/nextpnr-himbaechel -l fpga/pnr.log --json fpga/soc_synth.json --write fpga/soc_pnr.json --device GW2AR-LV18QN88C8/I7 --vopt family=GW2A-18C --vopt cst=fpga/tangnano20k.cst --freq 27
> $(OSS)/gowin_pack -c -d GW2A-18C -o $@ fpga/soc_pnr.json

fpga: fpga/soc.fs
> @grep -A20 "Device utilisation" fpga/pnr.log | grep -E " (LUT4|DFF|BSRAM):"
> @grep "Max frequency" fpga/pnr.log | tail -n1

prog: fpga/soc.fs
> $(OSS)/openFPGALoader -b tangnano20k fpga/soc.fs

.PHONY: all sim-soc sim-dma test clean fpga prog


lint:
> verilator --lint-only -Wall --top-module soc_top lint.vlt $(RTL)
> @echo "== LINT SACH =="

.PHONY: lint
