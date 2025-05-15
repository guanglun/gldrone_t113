#!/bin/bash

# # 出错时立即退出（可选）
# set -e

# 执行命令并捕获输出
output=$(sudo xfel spinand)

# 判断是否检测到指定的 SPI NAND Flash
if echo "$output" | grep -q "Found spi nand flash"; then

    echo "$output"
    echo "[INFO] Found spinand, start flashing..."

    start_time=$(date +%s)
    echo "[START] $(date '+%Y-%m-%d %H:%M:%S')"

    # Get the size of the file before flashing
    awboot_size=$(stat --format=%s awboot-boot-spi.bin)
    dtb_size=$(stat --format=%s sun8i-gldz-t113.dtb)
    zimage_size=$(stat --format=%s zImage)
    rootfs_size=$(stat --format=%s rootfs.ubi)

    echo "[INFO] Erasing the first 128MB of flash..."
    sudo xfel spinand erase 0 0x8000000

    echo "[INFO] Writing awboot-boot-spi.bin (Size: $((awboot_size / 1024)) KB) to address 0x00000000..."
    sudo xfel spinand write 0 awboot-boot-spi.bin

    echo "[INFO] Writing sun8i-gldz-t113.dtb (Size: $((dtb_size / 1024)) KB) to address 0x00040000..."
    sudo xfel spinand write 0x40000 sun8i-gldz-t113.dtb

    echo "[INFO] Writing zImage (Size: $((zimage_size / 1024)) KB) to address 0x00080000..."
    sudo xfel spinand write 0x80000 zImage

    echo "[INFO] Erasing rootfs area (from 0x00800000 to 0x08000000)..."
    sudo xfel spinand erase 0x800000 0x7800000

    echo "[INFO] Writing rootfs.ubi (Size: $((rootfs_size / 1024 / 1024)) MB) to address 0x00800000..."
    sudo xfel spinand write 0x800000 rootfs.ubi

    end_time=$(date +%s)
    elapsed=$((end_time - start_time))

    echo "[END] $(date '+%Y-%m-%d %H:%M:%S')"
    echo "[SUCCESS] Flashing completed."
    echo "[INFO] Total time: ${elapsed} seconds"

else
    echo "[ERROR] Spinand not found, exiting."
    exit 1
fi
