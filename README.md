EFI-ASUS-B250M
========

[![GitHub All Releases](https://img.shields.io/github/downloads/lichongjia/EFI-ASUS-B250M/total.svg?color=brightgreen&label=%E4%B8%8B%E8%BD%BD%E6%AC%A1%E6%95%B0)](https://github.com/lichongjia/EFI-ASUS-B250M/releases) [![GitHub release (latest by date)](https://img.shields.io/github/v/release/lichongjia/EFI-ASUS-B250M.svg?label=%E6%9C%80%E6%96%B0%E7%89%88%E6%9C%AC)](https://github.com/lichongjia/EFI-ASUS-B250M/releases) [![GitHub last commit](https://img.shields.io/github/last-commit/lichongjia/EFI-ASUS-B250M.svg?color=red&label=%E6%9C%80%E8%BF%91%E6%8F%90%E4%BA%A4)](https://github.com/lichongjia/EFI-ASUS-B250M/commits/master) [![Twitter URL](https://img.shields.io/twitter/url.svg?color=red&label=Twitter&style=social&url=https%3A%2F%2Ftwitter.com%2Flichongjia)](https://twitter.com/lichongjia)

中文 | [English](README_en.md)

此EFI配置在我自己的台式机上完美使用，不敢说百分百完美，但完成度非常之高! 如果你的配置恰好和我一样或类似，你可以根据自己的需要来选用。理论上来说，只要你是100系或以上主板，都可以使用我的EFI作为模板来配置。

**请从[此处](https://github.com/lichongjia/EFI-ASUS-B250M/releases)下载最新版。**

附加教程：[制作多功能多启动多合一引导U盘](Others/bootUSB.md)



## 硬件详情

| 配置     | 产品型号                               |
| :------- | :------------------------------------- |
| 主板     | ASUS Prime B250M-A                     |
| 处理器   | Intel Core i7-7500 @ 3.40GHz           |
| 内存     | Kingston 8GBx3 DDR4 2400MHz            |
| 硬盘     | WD Blue SN500 NVMe SSD 500G            |
| 核显     | Intel HD Graphics 630（id=0x59120003） |
| 独显     | AMD Readon HD7850                      |
| 声卡     | Realtek ALC887（id=52）                |
| 有线网卡 | Realtek RTL8111H                       |
| 无线网卡 | Broadcom BCM4331（WiFi+Bluetooth）     |
| 显示器   | Lenove ThinkVison P24Q                 |



## 多系统引导

[![GitHub All Releases](https://img.shields.io/badge/%E6%95%99%E7%A8%8B%E9%93%BE%E6%8E%A5-%E8%BF%9C%E6%99%AF%E8%AE%BA%E5%9D%9B-9cf.svg)](http://bbs.pcbeta.com/viewthread-1835917-1-1.html)

多系统引导界面，使用rEFInd管理OpenCore引导。(macOS(OpenCore), Windows10, Ubuntu)

<img title="BootMenu" src="Docs/img/BootMenu.png" alt="BootMenu" data-align="center">



## 更新说明

* 已转OpenCore！后续更新会将主要精力放在OpenCore上。
* Clover版本已经非常完美了，后续可能不会有大的改动，仅更新版本号和驱动。
* 详细更新日志请查看[Changelog](Changelog.md)。



## 关于

如果这个项目对你有帮助，你可以捐赠或者关注一下我的公众号。

如果你在安装或使用过程中有任何疑问，可以通过主页的联系方式私信我。也许我可以给你提供一些帮助!

<img title="QRcode" src="Docs/img/QRcode.png" alt="QRcode" data-align="center">

