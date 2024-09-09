TARGET = main

# Target Processor
MCU = cortex-m4

# define your linker script here
LD_SCRIPT = STM32F446RE.ld

# misc
FLASH = 0x08000000
DEV = /dev/tty.usbmodem1102
TARGET_MONITOR = serial_monitor/bin/stm_monitor

# Toolchains
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy
OD = arm-none-eabi-objdump
SZ = arm-none-eabi-size

# directories
BUILD_DIR = build/
OBJ_DIR = $(BUILD_DIR)obj/
SRC_DIR = src/
ASM_DIR = $(SRC_DIR)
INCLUDE_DIR = include/
LIB_DIR = lib/
TESTS_DIR = tests/
CONFIG_DIR = config/


# Assembly directives
# Compile but do not link
# Enable warnings
# Name of the target MCU
# Use Thumb ISA for generating assembly instructions
# Do not optimize
ASFLAGS += -c
ASFLAGS += -Wall
ASFLAGS += -mcpu=$(MCU)
ASFLAGS += -mfloat-abi=hard
ASFLAGS += -mthumb
ASFLAGS += -O0

# Compilation directives
# Generate debugging information
CFLAGS += -c
CFLAGS += -mcpu=$(MCU)
CFLAGS += -mfloat-abi=hard
CFLAGS += -Wall
CFLAGS += -mthumb
CFLAGS += -g

# Linker directives
# Do no use any standard libraries
# provide custom linker script
#LFLAGS += ./$(LD_SCRIPT)
LFLAGS += -mcpu=$(MCU)
LFLAGS += -mthumb
LFLAGS += -mfloat-abi=hard
LFLAGS += -nostdlib
LFLAGS += -lgcc
LFLAGS += -T./$(SRC_DIR)$(LD_SCRIPT)

# There is another way to include all .c files by using wildcard
C_SRC = ./$(SRC_DIR)main.c ./$(SRC_DIR)uart_log.c
ASM = ./$(SRC_DIR)core.S

# ignore this for now!
SERIAL_MONITOR_DIR = serial_monitor/monitor

# Automatic substitution
# OBJS = $(C_SRC:$(SRC_DIR)%.c=$(OBJ_DIR)%.o)
# OBJS += $(ASM:$(SRC_DIR)%.S=$(OBJ_DIR)%.o)
C_OBJ = $(OBJ_DIR)main.o $(OBJ_DIR)uart_log.o
ASM_OBJ = $(OBJ_DIR)core.o
OBJS = $(C_OBJ) $(ASM_OBJ)


.PHONY: all
all: $(BUILD_DIR)$(TARGET).bin

$(OBJ_DIR)main.o:$(SRC_DIR)main.c
	$(CC) $(CFLAGS) $< -o $@

$(OBJ_DIR)uart_log.o:$(SRC_DIR)uart_log.c
	$(CC) $(CFLAGS) $< -o $@

$(OBJ_DIR)core.o:$(SRC_DIR)core.S
	$(CC) $(ASFLAGS) $< -o $@

$(BUILD_DIR)$(TARGET).elf:$(OBJS)
	$(CC) $(OBJS) $(LFLAGS) -o $@

# -S strips all the symbol and relocation information from the .elf file
# -O tells the objcopy to output the file in raw binary format.
$(BUILD_DIR)$(TARGET).bin:$(BUILD_DIR)$(TARGET).elf
	$(OC) -S -O binary $< $@	
	$(SZ) $<

# compiles the file for serial monitor
.PHONY: re_monitor
re_monitor: $(TARGET_MONITOR)

$(SERIAL_MONITOR_DIR).o:$(SERIAL_MONITOR_DIR).c
	cc -c $< -o $@

$(TARGET_MONITOR):$(SERIAL_MONITOR_DIR).o
	cc $< -o $@

# flashes the bin file and monitors for serial output
.PHONY: flash_mon
flash_mon:
	st-flash write $(BUILD_DIR)$(TARGET).bin $(FLASH)
	./$(TARGET_MONITOR) $(DEV)

.PHONY: monitor
monitor:
	./$(TARGET_MONITOR) $(DEV)

.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f $(BUILD_DIR)$(TARGET).elf