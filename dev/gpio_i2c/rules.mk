LOCAL_DIR := $(GET_LOCAL_DIR)

MODULE := $(LOCAL_DIR)

MODULE_SRCS := \
	$(LOCAL_DIR)/gpio_i2c.c

ifneq ($(GPIO_I2C_BUS_COUNT),)
MODULE_DEFINES += \
	GPIO_I2C_BUS_COUNT=$(GPIO_I2C_BUS_COUNT)
endif

include make/module.mk
