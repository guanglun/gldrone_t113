# GLDrone文档地址：
[https://guanglun.github.io/gldrone/gldrone-t113](https://guanglun.github.io/gldrone/gldrone-t113)  

包含如下文件：
* 机架设计文件
* 飞控原理图
* 可直接烧写到飞控的固件


```
sudo xfel spinand erase 0 0x8000000
sudo xfel spinand write 0 awboot-boot-spi.bin
sudo xfel spinand write 0x40000 sun8i-gldz-t113.dtb
sudo xfel spinand write 0x80000 zImage
sudo xfel spinand erase 0x800000 0x7800000
sudo xfel spinand write 0x800000 rootfs.ubi
```
