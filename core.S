.syntax unified
.cpu cortex-m4
.fpu softvfp            /*  use software emulation for flaoting points  */
.thumb                  /*  Generate code in thumb for ISA  */

/*  Global Variable */    
.global vtable
.global reset_handler
.global default_interrupt_handler

.type reset_handler, %function
reset_handler:

    /*  Copying the data from FLASH to RAM */
    MOVS r0, #0         /*  copy 0 in r0 register and set the appro. flag in ASPR   */
    LDR r1, =_sidata     /*  Load the address from _sidata into r1   */
    LDR r2, =_sdata      /*  Init data section start addr    */
    LDR r3, =_edata      /*  Init data section end addr      */
    B copy_sidata_loop

    copy_sidata:
        LDR r4, [r1, r0]
        STR r4, [r2, r0]
        ADDS r0, r0, #4

    copy_sidata_loop:       /*  This works like an exit cond    */
        ADDS r4, r2, r0     /*  r4 = r2 + r0                    */
        CMP r4, r3          /*  compare r4 and r3               */
        BCC copy_sidata     /*  Branch if carry                 */

    /*  initialize the .bss section to zero and copy to the ram at adr@_sbss    */
    MOVS r0, #0
    LDR r1, =_sbss
    LDR r2, =_ebss
    B copy_sbss_loop

    copy_sbss:
        STR r0, [r1]
        ADDS r1, r1, #4

    copy_sbss_loop:
        CMP r1, r2
        BCC copy_sbss

        B main              /*   Thats it, finally we can branch to main */
.size reset_handler, .-reset_handler

/*              VECTOR TABLE     
vtable (Vector Table) is an object, which should be placed in vtable section, with "a" 
allocation attribute and a flag of type progbits which tell us that it contains data/instruction    */
.type vtable, %object
.section .vtable,"a",%progbits
vtable:
    //15 Processor specific handlers
    .word _estack
    .word reset_handler
    .word NMI_handler
    .word hard_fault_handler
    .word mem_manage_handler
    .word bus_fault_handler
    .word usage_fault_handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word SVC_handler
    .word debug_mon_handler
    .word 0
    .word pendsv_handler
    .word systick_handler
    //Peripherals
    .word WWDG_IRQ_handler              /*  Window Watchdog Interrupt   */
    .word PVD_IRQ_handler               /*  PVD through EXTI line detection interrupt   */
    .word TAMPSTAMP_IRQ_handler         /*  Tamper and TimeStamp interrupts through the EXTI line   */
    .word RTCWKUP_IRQ_handler           /*  RTC Wakeup interrupt through the EXTI line  */
    .word FLASH_IRQ_handler             /*  Flash global interrupt  */
    .word RCC_IRQ_handler               /*  RCC global interrupt    */   
    .word EXTI0_IRQ_handler             /*  EXTI Line0 interrupt    */
    .word EXTI1_IRQ_handler             /*  EXTI Line1 interrupt    */
    .word EXTI2_IRQ_handler             /*  EXTI Line2 interrupt    */
    .word EXTI3_IRQ_handler             /*  EXTI Line3 interrupt    */
    .word EXTI4_IRQ_handler             /*  EXTI Line4 interrupt    */
    .word DMA1_stream0_IRQ_handler      /*  DMA1 Stream0 global interrupt   */
    .word DMA1_stream1_IRQ_handler      /*  DMA1 Stream1 global interrupt   */
    .word DMA1_stream2_IRQ_handler      /*  DMA1 Stream2 global interrupt   */
    .word DMA1_stream3_IRQ_handler      /*  DMA1 Stream3 global interrupt   */
    .word DMA1_stream4_IRQ_handler      /*  DMA1 Stream4 global interrupt   */
    .word DMA1_stream5_IRQ_handler      /*  DMA1 Stream5 global interrupt   */
    .word DMA1_stream6_IRQ_handler      /*  DMA1 Stream6 global interrupt   */
    .word ADC_IRQ_handler               /*  ADC1, ADC2 and ADC3 global interrupts   */
    .word CAN1_TX_IRQ_handler           /*  CAN1 TX interrupts  */
    .word CAN1_RX0_IRQ_handler          /**/
    .word CAN1_RX1_IRQ_handler
    .word CAN1_SCE_IRQ_handler
    .word EXTI9_5_IRQ_handler
    .word TIM1_BRK_TIM9_IRQ_handler
    .word TIM1_UP_TIM10_IRQ_handler 
    .word TIM1_TRG_COM_TIM11_handler
    .word TIM1_CC_IRQ_handler
    .word TIM2_IRQ_handler
    .word TIM3_IRQ_handler
    .word TIM4_IRQ_handler
    .word I2C1_EV_IRQ_handler   
    .word I2C1_ER_IRQ_handler
    .word I2C2_EV_IRQ_handler
    .word I2C2_ER_IRQ_handler
    .word SPI1_IRQ_handler
    .word SPI2_IRQ_handler
    .word USART1_IRQ_handler
    .word USART2_IRQ_handler
    .word USART3_IRQ_handler
    .word EXTI15_10_IRQ_handler
    .word RTC_Alarm_IRQ_handler
    .word OTG_FS_WKUP_IRQ_handler
    .word TIM8_BRK_TIM12_IRQ_handler
    .word TIM8_UP_TIM13_IRQ_handler
    .word TIM8_TRG_COM_TIM14_IRQ_handler
    .word TIM8_CC_IRQ_handler
    .word DMA1_Stream7_IRQ_handler
    .word FMC_IRQ_handler
    .word SDIO_IRQ_handler
    .word TIM5_IRQ_handler
    .word SPI3_IRQ_handler
    .word UART4_IRQ_handler
    .word UART5_IRQ_handler
    .word TIM6_DAC_IRQ_handler
    .word TIM7_IRQ_handler
    .word DMA2_Stream0_IRQ_handler
    .word DMA2_Stream1_IRQ_handler
    .word DMA2_Stream2_IRQ_handler
    .word DMA2_Stream3_IRQ_handler
    .word DMA2_Stream4_IRQ_handler
    .word 0
    .word 0
    .word CAN2_TX_IRQ_handler
    .word CAN2_RX0_IRQ_handler
    .word CAN2_RX1_IRQ_handler
    .word CAN2_SCE_IRQ_handler
    .word OTG_FS_IRQ_handler
    .word DMA2_Stream5_IRQ_handler
    .word DMA2_Stream6_IRQ_handler
    .word DMA2_Stream7_IRQ_handler
    .word USART6_IRQ_handler
    .word I2C3_EV_IRQ_handler
    .word I2C3_ER_IRQ_handler
    .word OTG_HS_EP1_OUT_IRQ_handler
    .word OTG_HS_EP1_IN_IRQ_handler
    .word OTG_HS_WKUP_IRQ_handler
    .word OTG_HS_IRQ_handler
    .word DCMI_IRQ_handler
    .word 0
    .word 0
    .word FPU_IRQ_handler
    .word 0
    .word 0
    .word SPI4_IRQ_handler
    .word 0
    .word 0
    .word SAI1_IRQ_handler
    .word SAI2_IRQ_handler
    .word QuadSPI_IRQ_handler
    .word HDMI_CEC_IRQ_handler
    .word SPDIF_Rx_IRQ_handler
    .word FMPI2C1_IRQ_handler
    .word FMPI2C1_error_IRQ_handler

/*  Setup Weak aliases for each exception handler   */
.weak NMI_handler
.thumb_set NMI_handler,default_interrupt_handler

.weak hard_fault_handler
.thumb_set hard_fault_handler,default_interrupt_handler

.weak mem_manage_handler
.thumb_set mem_manage_handler,default_interrupt_handler

.weak bus_fault_handler
.thumb_set bus_fault_handler,default_interrupt_handler

.weak usage_fault_handler
.thumb_set usage_fault_handler,default_interrupt_handler

.weak SVC_handler
.thumb_set SVC_handler,default_interrupt_handler

.weak debug_mon_handler
.thumb_set debug_mon_handler,default_interrupt_handler

.weak pendsv_handler
.thumb_set pendsv_handler,default_interrupt_handler

.weak systick_handler
.thumb_set systick_handler,default_interrupt_handler
// Peripherals
.weak WWDG_IRQ_handler
.thumb_set WWDG_IRQ_handler,default_interrupt_handler

.weak PVD_IRQ_handler
.thumb_set PVD_IRQ_handler,default_interrupt_handler

.weak TAMPSTAMP_IRQ_handler
.thumb_set TAMPSTAMP_IRQ_handler,default_interrupt_handler

.weak RTCWKUP_IRQ_handler
.thumb_set RTCWKUP_IRQ_handler,default_interrupt_handler

.weak FLASH_IRQ_handler
.thumb_set FLASH_IRQ_handler,default_interrupt_handler

.weak RCC_IRQ_handler
.thumb_set RCC_IRQ_handler,default_interrupt_handler

.weak EXTI0_IRQ_handler
.thumb_set EXTI0_IRQ_handler,default_interrupt_handler

.weak EXTI1_IRQ_handler
.thumb_set EXTI1_IRQ_handler,default_interrupt_handler

.weak EXTI2_IRQ_handler
.thumb_set EXTI2_IRQ_handler,default_interrupt_handler

.weak EXTI3_IRQ_handler
.thumb_set EXTI3_IRQ_handler,default_interrupt_handler

.weak EXTI4_IRQ_handler
.thumb_set EXTI4_IRQ_handler,default_interrupt_handler

.weak DMA1_stream0_IRQ_handler
.thumb_set DMA1_stream0_IRQ_handler,default_interrupt_handler

.weak DMA1_stream1_IRQ_handler
.thumb_set DMA1_stream1_IRQ_handler,default_interrupt_handler

.weak DMA1_stream2_IRQ_handler
.thumb_set DMA1_stream2_IRQ_handler,default_interrupt_handler

.weak DMA1_stream3_IRQ_handler
.thumb_set DMA1_stream3_IRQ_handler,default_interrupt_handler

.weak DMA1_stream4_IRQ_handler
.thumb_set DMA1_stream4_IRQ_handler,default_interrupt_handler

.weak DMA1_stream5_IRQ_handler
.thumb_set DMA1_stream5_IRQ_handler,default_interrupt_handler

.weak DMA1_stream6_IRQ_handler
.thumb_set DMA1_stream6_IRQ_handler,default_interrupt_handler

.weak ADC_IRQ_handler
.thumb_set ADC_IRQ_handler,default_interrupt_handler

.weak CAN1_TX_IRQ_handler
.thumb_set CAN1_TX_IRQ_handler,default_interrupt_handler

.weak CAN1_RX0_IRQ_handler
.thumb_set CAN1_RX0_IRQ_handler,default_interrupt_handler

.weak CAN1_RX1_IRQ_handler
.thumb_set CAN1_RX1_IRQ_handler,default_interrupt_handler

.weak CAN1_SCE_IRQ_handler
.thumb_set CAN1_SCE_IRQ_handler,default_interrupt_handler

.weak EXTI9_5_IRQ_handler
.thumb_set EXTI9_5_IRQ_handler,default_interrupt_handler

.weak TIM1_BRK_TIM9_IRQ_handler
.thumb_set TIM1_BRK_TIM9_IRQ_handler,default_interrupt_handler

.weak TIM1_UP_TIM10_IRQ_handler
.thumb_set TIM1_UP_TIM10_IRQ_handler,default_interrupt_handler

.weak TIM1_TRG_COM_TIM11_handler
.thumb_set TIM1_TRG_COM_TIM11_handler,default_interrupt_handler

.weak TIM1_CC_IRQ_handler
.thumb_set TIM1_CC_IRQ_handler,default_interrupt_handler

.weak TIM2_IRQ_handler
.thumb_set TIM2_IRQ_handler,default_interrupt_handler

.weak TIM3_IRQ_handler
.thumb_set TIM3_IRQ_handler,default_interrupt_handler

.weak TIM4_IRQ_handler
.thumb_set TIM4_IRQ_handler,default_interrupt_handler

.weak I2C1_EV_IRQ_handler
.thumb_set I2C1_ER_IRQ_handler,default_interrupt_handler

.weak I2C2_EV_IRQ_handler
.thumb_set I2C2_EV_IRQ_handler,default_interrupt_handler

.weak I2C2_ER_IRQ_handler
.thumb_set I2C2_ER_IRQ_handler,default_interrupt_handler

.weak SPI1_IRQ_handler
.thumb_set SPI1_IRQ_handler,default_interrupt_handler

.weak SPI2_IRQ_handler
.thumb_set SPI2_IRQ_handler,default_interrupt_handler

.weak USART1_IRQ_handler
.thumb_set USART1_IRQ_handler,default_interrupt_handler

.weak USART2_IRQ_handler
.thumb_set USART2_IRQ_handler,default_interrupt_handler

.weak USART3_IRQ_handler
.thumb_set USART3_IRQ_handler,default_interrupt_handler

.weak EXTI15_10_IRQ_handler
.thumb_set EXTI15_10_IRQ_handler,default_interrupt_handler

.weak RTC_Alarm_IRQ_handler
.thumb_set RTC_Alarm_IRQ_handler,default_interrupt_handler

.weak OTG_FS_WKUP_IRQ_handler
.thumb_set OTG_FS_WKUP_IRQ_handler,default_interrupt_handler

.weak TIM8_BRK_TIM12_IRQ_handler
.thumb_set TIM8_BRK_TIM12_IRQ_handler,default_interrupt_handler

.weak TIM8_UP_TIM13_IRQ_handler
.thumb_set TIM8_UP_TIM13_IRQ_handler,default_interrupt_handler

.weak TIM8_TRG_COM_TIM14_IRQ_handler
.thumb_set TIM8_TRG_COM_TIM14_IRQ_handler,default_interrupt_handler

.weak TIM8_CC_IRQ_handler
.thumb_set TIM8_CC_IRQ_handler,default_interrupt_handler

.weak DMA1_Stream7_IRQ_handler
.thumb_set DMA1_Stream7_IRQ_handler,default_interrupt_handler

.weak FMC_IRQ_handler
.thumb_set FMC_IRQ_handler,default_interrupt_handler

.weak SDIO_IRQ_handler
.thumb_set SDIO_IRQ_handler,default_interrupt_handler

.weak TIM5_IRQ_handler
.thumb_set TIM5_IRQ_handler,default_interrupt_handler

.weak SPI3_IRQ_handler
.thumb_set SPI3_IRQ_handler,default_interrupt_handler

.weak UART4_IRQ_handler
.thumb_set UART4_IRQ_handler,default_interrupt_handler

.weak UART5_IRQ_handler
.thumb_set UART5_IRQ_handler,default_interrupt_handler

.weak TIM6_DAC_IRQ_handler
.thumb_set TIM6_DAC_IRQ_handler,default_interrupt_handler

.weak TIM7_IRQ_handler
.thumb_set TIM7_IRQ_handler,default_interrupt_handler

.weak DMA2_Stream0_IRQ_handler
.thumb_set DMA2_Stream0_IRQ_handler,default_interrupt_handler

.weak DMA2_Stream1_IRQ_handler
.thumb_set DMA2_Stream1_IRQ_handler,default_interrupt_handler

.weak DMA2_Stream2_IRQ_handler
.thumb_set DMA2_Stream2_IRQ_handler,default_interrupt_handler

.weak DMA2_Stream3_IRQ_handler
.thumb_set DMA2_Stream3_IRQ_handler,default_interrupt_handler

.weak DMA2_Stream4_IRQ_handler
.thumb_set DMA2_Stream4_IRQ_handler,default_interrupt_handler

.weak CAN2_TX_IRQ_handler
.thumb_set CAN2_TX_IRQ_handler,default_interrupt_handler

.weak CAN2_RX0_IRQ_handler
.thumb_set CAN2_RX0_IRQ_handler,default_interrupt_handler

.weak CAN2_RX1_IRQ_handler
.thumb_set CAN2_RX1_IRQ_handler,default_interrupt_handler

.weak CAN2_SCE_IRQ_handler
.thumb_set CAN2_SCE_IRQ_handler,default_interrupt_handler

.weak OTG_FS_IRQ_handler
.thumb_set OTG_FS_IRQ_handler,default_interrupt_handler

.weak DMA2_Stream5_IRQ_handler
.thumb_set DMA2_Stream5_IRQ_handler,default_interrupt_handler

.weak DMA2_Stream6_IRQ_handler
.thumb_set DMA2_Stream6_IRQ_handler,default_interrupt_handler

.weak DMA2_Stream7_IRQ_handler
.thumb_set DMA2_Stream7_IRQ_handler,default_interrupt_handler

.weak USART6_IRQ_handler
.thumb_set USART6_IRQ_handler,default_interrupt_handler

.weak I2C3_EV_IRQ_handler
.thumb_set I2C3_EV_IRQ_handler,default_interrupt_handler

.weak I2C3_ER_IRQ_handler
.thumb_set I2C3_ER_IRQ_handler,default_interrupt_handler

.weak OTG_HS_EP1_OUT_IRQ_handler
.thumb_set OTG_HS_EP1_OUT_IRQ_handler,default_interrupt_handler

.weak OTG_HS_EP1_IN_IRQ_handler
.thumb_set OTG_HS_EP1_IN_IRQ_handler,default_interrupt_handler

.weak OTG_HS_WKUP_IRQ_handler
.thumb_set OTG_HS_WKUP_IRQ_handler,default_interrupt_handler

.weak OTG_HS_IRQ_handler
.thumb_set OTG_HS_IRQ_handler,default_interrupt_handler

.weak DCMI_IRQ_handler
.thumb_set DCMI_IRQ_handler,default_interrupt_handler

.weak FPU_IRQ_handler
.thumb_set FPU_IRQ_handler,default_interrupt_handler

.weak SPI4_IRQ_handler
.thumb_set SPI4_IRQ_handler,default_interrupt_handler

.weak SAI1_IRQ_handler
.thumb_set SAI1_IRQ_handler,default_interrupt_handler

.weak SAI2_IRQ_handler
.thumb_set SAI2_IRQ_handler,default_interrupt_handler

.weak QuadSPI_IRQ_handler
.thumb_set QuadSPI_IRQ_handler,default_interrupt_handler

.weak HDMI_CEC_IRQ_handler
.thumb_set HDMI_CEC_IRQ_handler,default_interrupt_handler

.weak SPDIF_Rx_IRQ_handler
.thumb_set SPDIF_Rx_IRQ_handler,default_interrupt_handler

.weak FMPI2C1_IRQ_handler
.thumb_set FMPI2C1_IRQ_handler,default_interrupt_handler

.weak FMPI2C1_error_IRQ_handler
.thumb_set FMPI2C1_error_IRQ_handler,default_interrupt_handler
.size vtable, .-vtable

.section .text.default_interrupt_handler,"ax",%progbits
default_interrupt_handler:
    default_interrupt_loop:
        B default_interrupt_loop
.size default_interrupt_handler, .-default_interrupt_handler
