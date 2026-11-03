/* Ban do bo nho cua chip ASIC (soc_chip): ma lenh trong ROM, du lieu trong SRAM */
ENTRY(_start)
MEMORY {
    ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 4K
    RAM (rwx) : ORIGIN = 0x00001000, LENGTH = 2K
}
SECTIONS {
    .text   : { *(.text.start) *(.text*) . = ALIGN(4); } > ROM
    .rodata : { *(.rodata*) *(.srodata*) . = ALIGN(4); } > ROM
    .data   : { *(.data*) *(.sdata*) . = ALIGN(4); } > RAM AT > ROM
    ASSERT(SIZEOF(.data) == 0, "Ban ASIC khong ho tro bien toan cuc co gia tri dau (.data)")
    .bss (NOLOAD) : {
        _bss_start = .;
        *(.bss*) *(.sbss*) *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } > RAM
    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}
