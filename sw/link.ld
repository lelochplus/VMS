ENTRY(_start)
MEMORY { RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 8K }
SECTIONS {
    .text   : { *(.text.start) *(.text*) . = ALIGN(4); } > RAM
    .rodata : { *(.rodata*) *(.srodata*) . = ALIGN(4); } > RAM
    .data   : { *(.data*) *(.sdata*) . = ALIGN(4); } > RAM
    .bss (NOLOAD) : {
        _bss_start = .;
        *(.bss*) *(.sbss*) *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } > RAM
    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}
