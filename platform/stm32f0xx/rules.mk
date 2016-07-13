LOCAL_DIR := $(GET_LOCAL_DIR)

MODULE := $(LOCAL_DIR)

# ROMBASE, MEMBASE, and MEMSIZE are required for the linker script
ROMBASE := 0x08000000
MEMBASE := 0x20000000
# can be overridden by target

ARCH := arm
ARM_CPU := cortex-m0

ifeq ($(STM32_CHIP),stm32f031x4)
# Note: CMSIS uses x6 define for both x4 and x6.
GLOBAL_DEFINES += \
        STM32F031x6
MEMSIZE ?= 4096
endif
ifeq ($(STM32_CHIP),stm32f072_x8)
GLOBAL_DEFINES += \
        STM32F072
MEMSIZE ?= 16384
endif
ifeq ($(STM32_CHIP),stm32f072_xB)
GLOBAL_DEFINES += \
        STM32F072
MEMSIZE ?= 16384
endif

GLOBAL_DEFINES += \
	USE_STDPERIPH_DRIVER \
	MEMSIZE=$(MEMSIZE)

# XXX: selectively compile.
#	$(LOCAL_DIR)/can.c
#	$(LOCAL_DIR)/usbc.c \

MODULE_SRCS += \
	$(LOCAL_DIR)/debug.c \
	$(LOCAL_DIR)/dma.c \
	$(LOCAL_DIR)/gpio.c \
	$(LOCAL_DIR)/init.c \
	$(LOCAL_DIR)/rcc.c \
	$(LOCAL_DIR)/spi.c \
	$(LOCAL_DIR)/timer.c \
	$(LOCAL_DIR)/uart.c \
	$(LOCAL_DIR)/vectab.c

# use a two segment memory layout, where all of the read-only sections 
# of the binary reside in rom, and the read/write are in memory. The 
# ROMBASE, MEMBASE, and MEMSIZE make variables are required to be set 
# for the linker script to be generated properly.
#
LINKER_SCRIPT += \
	$(BUILDDIR)/system-twosegment.ld

# XXX: shouldn't the first two reference external/platform?
#	dev/usb
MODULE_DEPS += \
	platform/stm32f0xx/CMSIS \
	platform/stm32f0xx/STM32F0xx_HAL_Driver \
	arch/arm/arm-m/systick \
	lib/cbuf

include make/module.mk
