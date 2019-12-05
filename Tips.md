OpenCore一方面由于出来不久的原因，并且工具也还在完善中，所以中文教程少。但是对新硬件有更好的支持，模块化设计也解决了Clover的冗余问题。从亲身使用下来的情况看，从v0.5.1开始，OC稳定性已经非常好了，完全可以用于正式的生产环境!

以下是一些参考配置文章:

官方英文文档，任何情况下都以此为准
https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/Configuration.pdf

综合性教程，比较通用且全面
opencore-vanilla-desktop-guide
https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/

黑果小兵的教程，适合原生NVRAM的主板
https://blog.daliansky.net/OpenCore-BootLoader.html

xjn819的教程，适合无原生NVRAM的主板
https://blog.xjn819.com/?m=201910

测试是否带原生NVRAM，请在终端执行以下命令:
1、添加一个测试变量: sudo nvram TestVar=HelloWorld
2、然后重启运行: sudo nvram -p | grep 'TestVar'
3、检测是否成功后删除该测试变量（sudo nvram -d TestVar）

如果你已有Clover引导环境，我建议你参考你的Clover配置来进行。
虽然两者区别很大，但一些补丁实现方式差不多，这样可以让你的配置步骤更有条理。

OpenCore官方不建议使用更名补丁，除非必须使用的情况。因为新版Whatevergreen等驱动已经自带常用更名并注入一些必要设备，所以Clover下的一些常用二进制更名补丁(GFX0->IGPU，HDAS->HDEF，HECI->IMEI等)也不再需要。能使用SSDT注入的都优先考虑用SSDT注入(虽然某些功能在Clover下可以直接勾选很方便)，但制作一个兼容性好的SSDT补丁Clover和OpenCore都可以使用，一次制作，两处使用。

尽可能采用添加设备属性(DeviceProperties)对PCI设备打补丁。
例如通过Properties方法注入IMEI，PciRoot(0x0)/Pci(0x16,0x0):device-id, 3A1E0000， 当Properties方法不奏效时或者其他原因时，再采用对设备或者方法更名以及HOTpatch的SSDT文件对其实施定制补丁。

显卡大多数情况下使用Whatevergreen即可解决。
声卡配合AppleALC驱动方法有很多种(Clover,DSDT,设备属性)，如果采用DSDT注入的话，请禁用Clover相关选项(Devices-> Audio-> Inject = NO)，个人建议用设备属性这种方式来注入，并且这也是OpenCore推荐采用的方式。

SATA类型的SSD若要开启TRIM，建议使用终端命令"sudo trimforce enable"来启用，不建议使用CloverKext补丁(Enable TRIM for SSD)或OpenCore的相关项(ThirdPartyTrim)

USB相关，因为苹果原生EC控制器在DSDT中就叫EC，是否使用重命名补丁请先查看原机DSDT的EC控制器名字，可能叫H_EC或EC0，方法是搜索DSDT中"PNP0C09"的设备，如果该设备的"_STA"返回值为零(Zero)，直接添加SSDT-EC-USBX.aml文件(注入EC控制器和电源管理)，反之则应在SSDT中将EC禁用，USB电源问题使用iPAD测试比较方便。

强烈推荐使用我定制的USB端口补丁(15port版)，这样可以避免缓冲区溢出
注:未带15port的驱动为全部端口可用，需要配合USB端口限制补丁才能使用，info.plist中IOMatchName名为XHC

网卡，使用相应的kext网卡驱动即可


## Boot参数说明
`dartwake=0`可选项，支持睡眠一键唤醒
`dar=0`提供针对VT-d的额外保护

`debug=0x100`若重启时发生内核恐慌，启用此项来查看原因

`keepsyms=1`可选项，打印内核崩溃的日志信息

`-v`跑代码模式，全部配置无误后，可移出

### 其它待解决的问题
> `待解决:声卡内建输入输出名称更改问题`
> `查看ProximityWake=1的问题，深度休眠预留空间，此功能是若有相关移动设备靠近mac，则会唤醒电脑`