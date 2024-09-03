#include "log_init.h"

void uart_init(const unsigned int baudrate){
    RCC_AHB1 |= (1 << 0);           /*  Clock for GPIOA     */
    RCC_APB1 |= (1 << 17);          /*  Clock for USART2    */

    /*  Configure the Alternate Functionality for the GPIOA Peripheral  */
    GPIOA_MODR &= ~(3 << 4);
    GPIOA_MODR |= (2 << 4);         /*  PA2 in AF Mode  */
    GPIOA_MODR &= ~(3 << 6);
    GPIOA_MODR |= (2 << 6);         /*  PA3 in AF Mode  */

    GPIOA_AFRL &= ~(255 << 8);
    GPIOA_AFRL |= (7 << 8);         /*  PA2 as USART Tx */
    GPIOA_AFRL |= (7 << 12);        /*  PA3 as USART Rx */

    /*  Configure the setting for the USART2 Peripheral */
    float div;
    float def_clock = 16000000.0f;          /*  configure dynamically for whatever the clock might be   */
    unsigned int long mantissa, frac;
    unsigned short int usart_div = 0;

    USART2_CR1 |= (1 << 13);        /*  USART Enable    */

    /*  set the baudrate depending upon oversampling    */
    if(((USART2_CR1 >> 15) & 1) == 1){
        div = (def_clock / (16 * baudrate));    /*  Oversampling by 8   */
    }
    else{
        div = (def_clock / (16 * baudrate));    /*  Oversampling by 16  */
    }

    mantissa = (unsigned int)div;
    frac = (unsigned int)((div - mantissa) * 16);
    usart_div = (((mantissa & 0xFFF) << 4) | (frac & 0xF));

    USART2_BRR = usart_div;

    /*  Enable the USART Transmit bit   */
    USART2_CR1 |= (1 << 3);
}

void log_data(unsigned char *data){
    while(*data){
        USART_DR = *data++;
        while (((USART2_SR >> 7) & 1) == 0)             /*  Keep polling for until Transmit Data Register becomes 1 */
            ;
    }
    while(((USART2_SR >> 6) & 1) == 0)                  /*  When TC = 1, End of transmission */
        ;
}

