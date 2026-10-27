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

sim-soc: sw/fw.hex tb/tb_soc.v $(RTL)
> verilator --binary --timing --trace -Wno-fatal $(RTL) tb/tb_soc.v --top-module tb_soc
> ./obj_dir/Vtb_soc | tee soc.log
> grep -q "^PASS" soc.log

sim-dma: rtl/dma_ctrl.v tb/tb_dma.v
> verilator --binary --timing --trace -Wno-fatal --Mdir obj_dma rtl/dma_ctrl.v tb/tb_dma.v --top-module tb_dma
> ./obj_dma/Vtb_dma | tee dma.log
> grep -q "^PASS" dma.log

test: sim-dma sim-soc
> @echo "== TAT CA TEST DAT =="

clean:
> rm -rf obj_dir obj_dma sw/fw.elf sw/fw.bin sw/fw.hex soc.vcd dump.vcd soc.log dma.log

.PHONY: all sim-soc sim-dma test clean
