TARGET = main

# Target Processor
MCU = cortex-m4

# define your linker script here
LD_SCRIPT = STM32F446RE.ld

# Toolchains
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy
OD = arm-none-eabi-objdump
SZ = arm-none-eabi-size

# Assembly directives
# Compile but do not link
# Enable warnings
# Name of the target MCU
# Use Thumb ISA for generating assembly instructions
# Do not optimize
ASFLAGS += -c
ASFLAGS += -Wall
ASFLAGS += -mcpu=$(MCU)
ASFLAGS += -mthumb
ASFLAGS += -O0

# Compilation directives
# Generate debugging information
CFLAGS += -mcpu=$(MCU)
CFLAGS += -Wall
CFLAGS += -mthumb
CFLAGS += -g

# Linker directives
# Do no use any standard libraries
# provide custom linker script
#LFLAGS += ./$(LD_SCRIPT)
LFLAGS += -mcpu=$(MCU)
LFLAGS += -mthumb
LFLAGS += -nostdlib
LFLAGS += -lgcc
LFLAGS += -T./$(LD_SCRIPT)

C_SRC = ./main.c
ASM = ./core.S

# Automatic substitution
OBJS = $(C_SRC:.c=.o)
OBJS += $(ASM:.S=.o)

.PHONY: all
all: $(TARGET).bin

%.o:%.S
	$(CC) $(ASFLAGS) $< -o $@

%.o:%.c
	$(CC) -c $(CFLAGS) $< -o $@

$(TARGET).elf:$(OBJS)
	$(CC) $^ $(LFLAGS) -o $@

# -S strips all the symbol and relocation information from the .elf file
# -O tells the objcopy to output the file in raw binary format.
$(TARGET).bin:$(TARGET).elf
	$(OC) -S -O binary $< $@	
	$(SZ) $<

.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf