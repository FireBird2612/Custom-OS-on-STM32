#ifndef _LOG_INIT_H_
#define _LOG_INIT_H_

/* define the RCC(clock) address for the GPIO and USART2 Peripheral. */
#define RCC_BASE    0x40023800U            /*  RCC Peripheral Address */
#define RCC_AHB1    (*(volatile unsigned int *)(RCC_BASE + 0x30))        /*  RCC AHB1 register offset    */
#define RCC_APB1    (*(volatile unsigned int *)(RCC_BASE + 0x40))

#define GPIOA_BASE  0x40020000U            /*   GPIOA Base register addr    */
#define GPIOA_MODR  (*(volatile unsigned int *)(GPIOA_BASE))            /*  GPIOA_MODER register offset */
#define GPIOA_AFRL  (*(volatile unsigned int *)(GPIOA_BASE + 0x20))     /*  GPIOA_AFRL  register offset */

#define USART2_BASE 0x40004400U
#define USART2_SR   (*(volatile unsigned int *)(USART2_BASE))
#define USART2_CR1  (*(volatile unsigned int *)(USART2_BASE + 0x0C))        /*  Control Register 1*/
#define USART2_BRR  (*(volatile unsigned int *)(USART2_BASE + 0x08))        /*  Baud rate register */
#define USART_DR    (*(volatile unsigned int *)(USART2_BASE + 0x04))        /*  Data register   */  

/*  Function Prototypes */
void uart2_init(const unsigned int baudrate);
void log_data(unsigned char *data);

#endif