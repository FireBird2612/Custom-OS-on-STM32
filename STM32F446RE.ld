/*
 * LS for STM32F446RE
 * RAM = 128KB (112KB + 16KB)
 * FLASH = 512KB 
 *
 */

ENTRY(reset_handler)

/*  End of the SRAM/Start of the stack(downgrowing stack)   */
_estack = ORIGIN(SRAM) + LENGTH(SRAM); 

/*  You may want to change these value depending upon your application  */
_min_heap_size = 0x400;     /*  1KB will be reserved for heap section   */
_min_stack_size = 0x800;    /*  2KB will be reserved for stack secton   */
_min_leftover_RAM = _min_heap_size + _min_stack_size;


MEMORY
{
    FLASH   (rx)    :ORIGIN = 0x08000000, LENGTH = 512K
    SRAM    (rxw)   :ORIGIN = 0x20000000, LENGTH = 128K   
}

/*  Refer to 3.6, Pg.69 of GNU-ld */
SECTIONS
{
    /*  Located at the start of the flash   */
    .vtable :
    {
        . = ALIGN(4);       /*  Alignment should be done at the multiple of 4   */
        KEEP (*(.vtable))   /*  do not optimize and include all vtable sections */
        . = ALIGN(4);       /*  realigns the . after placing the vtable         */
    } >FLASH                /*  Place the vtable section in FLASH mem           */

    /*  Contians main program code, will be stored in FLASH */
    /*  include all section which has the substring "text" in the name string   */
    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text*)
        . = ALIGN(4);
    } >FLASH

    /*  Contains read only data, will be stored in FLASH    */
    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
    } >FLASH

    /*  contains initialised global and static data, will be stored FLASH and copied into RAM at bootup */
    /*  _sidata will hold the LMA of the data sect. */
    _sidata = .;
    .data : AT(_sidata)
    {
        . = ALIGN(4);
        _sdata = .;         /*  _sdata will hold the start of the data section in VMA  */
        *(.data)
        *(.data*)
        _edata = .;         /*  _edata will hold the end of the data section in VMA   */
        . = ALIGN(4);
    } >SRAM

    /*  "base started by zero" is initialized to zero at the start of the program   */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)           /*  COMMON section contains uninitialized global and static data    */
        . = ALIGN(4);
        _ebss = .;
    } >SRAM

    /*  Section for dynamic allocation in heap  */
    .dynamic :
    {
        . = ALIGN(4);
        _sheap = .;
        . = . + _min_leftover_RAM;
        . = ALIGN(4);
        _eheap = .;
    } >SRAM
}
