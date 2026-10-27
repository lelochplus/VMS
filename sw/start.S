#include "custom_ops.S"

    .section .text.start
    .globl _start
_start:
    j    reset                   // 0x00: vector reset

    .org 0x10                    // 0x10: vector ngắt của PicoRV32 (PROGADDR_IRQ)
irq_vec:
    addi sp, sp, -64             // lưu các thanh ghi mà hàm C có thể làm hỏng
    sw   ra,  0(sp)
    sw   t0,  4(sp)
    sw   t1,  8(sp)
    sw   t2, 12(sp)
    sw   a0, 16(sp)
    sw   a1, 20(sp)
    sw   a2, 24(sp)
    sw   a3, 28(sp)
    sw   a4, 32(sp)
    sw   a5, 36(sp)
    sw   a6, 40(sp)
    sw   a7, 44(sp)
    sw   t3, 48(sp)
    sw   t4, 52(sp)
    sw   t5, 56(sp)
    sw   t6, 60(sp)

    picorv32_getq_insn(a0, q1)   // a0 = bitmask các ngắt đang chờ
    call irq_handler

    lw   ra,  0(sp)
    lw   t0,  4(sp)
    lw   t1,  8(sp)
    lw   t2, 12(sp)
    lw   a0, 16(sp)
    lw   a1, 20(sp)
    lw   a2, 24(sp)
    lw   a3, 28(sp)
    lw   a4, 32(sp)
    lw   a5, 36(sp)
    lw   a6, 40(sp)
    lw   a7, 44(sp)
    lw   t3, 48(sp)
    lw   t4, 52(sp)
    lw   t5, 56(sp)
    lw   t6, 60(sp)
    addi sp, sp, 64
    picorv32_retirq_insn()       // quay về chương trình bị ngắt, mở lại ngắt

reset:
    la   sp, _stack_top
    la   t0, _bss_start
    la   t1, _bss_end
1:  bgeu t0, t1, 2f
    sw   zero, 0(t0)
    addi t0, t0, 4
    j    1b
2:  picorv32_maskirq_insn(zero, zero)   // mở mọi ngắt (sau reset chúng bị che)
    call main
3:  j    3b
