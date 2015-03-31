LOCAL_PATH := $(call my-dir)

# Uncompress ramdisk.img to avoid double compression
uncompressed_ramdisk := $(PRODUCT_OUT)/ramdisk.cpio
$(uncompressed_ramdisk): $(INSTALLED_RAMDISK_TARGET)
	$(MINIGZIP) -d < $(INSTALLED_RAMDISK_TARGET) > $@

# Add ramdisk dependencies to kernel
TARGET_KERNEL_BINARIES: $(recovery_ramdisk) $(uncompressed_ramdisk) $(LOCAL_PATH)/utilities/flash_image $(LOCAL_PATH)/utilities/busybox $(LOCAL_PATH)/utilities/make_ext4fs $(LOCAL_PATH)/utilities/erase_image $(LOCAL_PATH)/utilities/modem.bin

INSTALLED_BOOTIMAGE_TARGET := $(PRODUCT_OUT)/boot.img
$(INSTALLED_BOOTIMAGE_TARGET): $(INSTALLED_KERNEL_TARGET)
	$(call pretty,"Boot image: $@")
	$(hide) $(ACP) $(INSTALLED_KERNEL_TARGET) $@

$(INSTALLED_RECOVERYIMAGE_TARGET): $(INSTALLED_BOOTIMAGE_TARGET)
	$(ACP) $(INSTALLED_BOOTIMAGE_TARGET) $@
