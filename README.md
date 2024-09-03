
# Building your own custom-OS-on-STM32 from scratch

### Steps required until you get to main.c:

1. Download the toolchain, arm-none-eabi-gcc here https://developer.arm.com/downloads/-/gnu-rm 
2. You will need a linker script for STM32F446RE
3. A startup file for the STM32F446RE mcu
4. To compile the code, `arm-none-eabi-gcc -c -O0 -mcpu=cortex-m4 -mthumb -Wall core.S -o core.o` , this will give you object file.
5. Now time to link the object file with our custom linker script that we created, `arm-none-eabi-gcc core.o -mcpu=cortex-m4 -mthumb -Wall -lgcc -T./STM32F446RE.ld -o main.elf` , this will give us an executable file with an extension executable and linkable format(.elf)
After this, you can write your main.c file and compile the code by following steps similar to 4 and 5

### Debugging code on the TARGET MCU
1. Once you have your target hardware plugged in you can run, `arm-none-eabi-gdb main.elf`
2. Open another terminal and run the command `st-util`
3. To connect to the remote debugger you need to open the 4242 port, by running the following at (gdb)`target extended-remote :4242`
4. Run the `load` command to load the various sections for debugging.
5. From this point onwards you can use your general gdb commands.

### Creating a logging functionality using a UART peripheral
1. By default lots of ST dev board support USART2 interface connected to ST-LINK MCU supporting virtual COM port so will be configuring USART2 as our logging interface.
2. Configure the USART2 peripheral 
3. before calling main from core.S call uart initialization function.
4. Setup a script on CLI which establishes the communication between the UART peripheral.
