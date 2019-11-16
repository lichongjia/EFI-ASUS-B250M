# EFI-ASUS-B250M

## 硬件详情
- 主板: ASUS B250M-A
- CPU：Intel i5-7500
- 显卡：XFX HD7850 1G
- 内存：Kingston 8GBx3 DDR4 2400
- 声卡：Realtek ALC887（id=40）
- 有线网卡：RTL8111H
- 无线网卡：Broadcom BCM4331

**注：点击[此处](https://github.com/lichongjia/EFI-ASUS-B250M/releases)下载最新版**

## 更新日志

### 2019/11/16
为了让配置最优最简化，本版做了大量精简，并删除其他多余文件，强烈推荐使用此版本

    1、删除BIOS驱动文件，仅保留UEFI驱动
    2、删除DSDT文件，改为采用Clover热修补方式
    3、更改FackSMC为VirtualSMC
    4、大量精简config.plist配置文件
    
### 2019/11/15
初次发布的版本，稳定可长期使用，其中包括很多个人定制的专用驱动和主题

    1、Clover版本为v5098
    2、所有驱动都是当前最新版本
    3、稳定完善的config.plist配置文件
