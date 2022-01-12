## OpenCore更新日志

***注意：在已经稳定的情况下，我可能不会那么及时地更新版本号！！！***

#### 2022/01/12（0.7.7）

- OpenCore更新到0.7.7

- 所有驱动更新到当前最新，替换RTL8111驱动到另一个分支，项目地址: [RTL8168_8111](https://github.com/wy414012/RTL8168_8111)

- 许久未更新了！更新日志太多，懒得写了。自己看官方的 [Changelog.md](https://github.com/acidanthera/OpenCorePkg/blob/master/Changelog.md)

- 配置中需要注意的就是，UIScale已经从NVRAM–Add移到UEFI–Output下

- 新版OC默认情况下，仅从BigSur和更高版本加载APFS驱动，如果你使用HighSierra/Mojave/Catalina或之前的版本，需要设置支持的MinVersion和MinDate（10.12及更早的版本使用HFS文件系统,而非APFS）, 否则引导菜单中将无法显示macOS分区。

- MinVersion和MinDate需要同时设置

  | macOS Version              | Min Version        | Min Date   |
  | :------------------------- | :----------------- | :--------- |
  | HighSierra (`10.13.6`)     | `748077008000000`  | `20180621` |
  | Mojave (`10.14.6`)         | `945275007000000`  | `20190820` |
  | Catalina (`10.15.4`)       | `1412101001000000` | `20200306` |
  | 允许任何版本加载APFS       | `-1`               | `-1`       |
  | 如果系统一直在跟随官方更新 | 0                  | 0          |

#### 2021/06/18（0.7.0）

- OpenCore更新到0.7.0
- 所有驱动更新到当前最新
- OC 0.7.0主要是主题方面的更新，加强了OpenCanopy的功能，添加了Flavour属性来使用自定义命名的图标。另外在引导菜单项还添加了一个ToggleSip项(类似Apple csrutil)，可用来开关SIP状态。Tool文件夹里面同样还添加了一个CsrUtil.efi工具也是用来设置SIP的，ToggleSip和CsrUtil.efi可以共存，后者功能更强大。
- 好长时间没有更新版本了！这次索性把主题图标也一起更新了。添加了更多的图标来适配0.7.0
- 因为我基本上是不用主题的，所以我的config.plist都是不包括主题的配置
- 如果你要用我的主题图标的话，请按照以下参数设置config.plist可达到比较好的效果：
`Misc -> Boot -> PickerMode: External`
`Misc -> Boot -> PickerAttributes: 130`（如果想要在引导界面中使用鼠标可改为146）
`Misc -> Boot -> PickerVariant: Acidanthera\Jianfengzhi`
`UEFI -> Drivers: 添加OpenCanopy.efi`
- 关于Entries和Tool自定义项的Flavour属性，config中我已经设置好了

#### 2021/01/12（0.6.5）

- OpenCore更新到0.6.5
- 所有驱动更新到当前最新
- OC当前已经足够稳定，更新幅度较小。从官方每月一更的进度来看，本月一些内置功能模块已经基本维持不变，且一些驱动也没有新的发行版。

#### 2020/12/09（0.6.4）

- OpenCore更新到0.6.4
- 所有驱动更新到当前最新

#### 2020/11/03（0.6.3）

- OpenCore更新到0.6.3
- 将config.plist中禁用SIP值从e7030000(用于10.13)改为ff070000(用于10.14和10.15)
- 所有驱动更新到当前最新

#### 2020/10/14（0.6.2）

- OpenCore更新到0.6.2
- 所有驱动更新到当前最新

#### 2020/09/12（0.6.1）

- OpenCore更新到0.6.1
- 所有驱动更新到当前最新(注意：RTL8111有线网卡驱动由于v2.3.0版需要在偏好设置下将网卡硬件设置为手动配置模式及相关参数才能连联网，稍嫌麻烦，故暂时保留在v2.2.2版)。

#### 2020/08/05（0.6.0）

- OpenCore更新到0.6.0

- 所有驱动更新到当前最新

#### 2020/06/02（0.5.9）

- OpenCore更新到0.5.9

- 推荐使用config-install.plist文件来安装系统，正式引导请用config.plist

- OC官方在Utilities文件夹下新增了几个实用程序，方便在配置时合理使用，使用方法自己搜索

  > ConfigValidity：用来检测你的config.plist是否有错误信息
  >
  > macrecovery：可下载Recovery镜像，无需刻盘直接用网络安装系统

- 所有驱动更新到当前最新

#### 2020/05/22（0.5.8）

- OpenCore更新到0.5.8
- 从0.5.8开始，ApfsDriverLoader.efi驱动已内置，并通过config.plist -> UEFI -> APFS来配置
- 新增的Bootstrap是为了解决某些Windows下系统更新后会覆盖BOOTx64.efi文件的问题，默认不使用
- 新增的ResetSystem.efi是给启动菜单添加重启或关机项用的
- 将所有SSDT补丁合并写入到SSDT-ASUS-B250M.dsl单个文件中
- 去除蓝牙修补驱动BT4LEContinuityFixup.kext
- 重新定制USB端口并修正了Type-C接口
- Tools文件夹下添加了两个工具modGRUBShell.efi和RU.efi，用来修改某些主板的CFG锁开关
- 进入启动菜单后，按空格键可显示更多选项
- 默认不使用0D/6D补丁，改为可使用键盘鼠标来唤醒机器
- 进一步优化配置文件，剔除了一些不必要的参数
- 所有驱动更新到当前最新

#### 2020/01/21（0.5.4）

- OpenCore更新到0.5.4
- 添加Windows10引导项(默认隐藏)，开机按`Option`或`ESC`键即可显示所有引导项
- 所有驱动更新到当前最新

#### 2019/12/03（0.5.3）

- OpenCore更新到0.5.3
- 推荐在OC上使用VirtualSMC
- 启动速度都差不多，我亲自测试过Clover和OC都在15s左右



## Clover更新日志

#### 2020/09/12（v3.3.1）

本次更新改动较少，仅保留采用OcQuirks特性的版本

- Clover更新到5122
- 所有驱动更新到当前最新（RTL8111驱动为v2.2.2）

#### 2020/08/04（v3.3）

本次更新发布两个版本：一个传统版(采用OsxAptioFix3Drv.efi)，另一个为采用OcQuirks特性的版本

- Clover更新到5120
- 添加自制的Clover华硕矢量主题，详情请查看我的CloverVectorTheme项目
- 所有驱动更新到当前最新

#### 2020/05/22（v3.2）
- Clover更新到5118
- 将所有SSDT补丁合并写入到SSDT-ASUS-B250M.dsl单个文件中
- 替换OcQuirks.efi为OsxAptioFix3Drv.efi，并跟随Clover官方更新。如果你仍想用OcQuirks请将OcQuirks.plist中的参数设置成与OpenCore配置文件的Quirks一致。
- 去除蓝牙修补驱动BT4LEContinuityFixup.kext
- 重新定制USB端口并修正了Type-C接口
- 默认不使用0D/6D补丁，改为可使用键盘鼠标来唤醒机器
- 进一步优化配置文件，剔除了一些不必要的参数
- 添加自制ASUS主题
- 所有驱动更新到当前最新

#### 2020/01/21（v3.1）
- Clover更新到5103
- 使用FwRuntimeServices.efi和OcQuirks.efi替换掉了AptioMemoryFix.efi
- 所有Kext驱动采用当前最新源代码编译

#### 2019/12/09（v3）
- Clover更新到5100

#### 2019/12/02（v3）
- Clover更新到5099
- 从VirtualSMC换回FackSMC，感觉Clover还是配FackSMC比较好，传感器更齐全
- 为了最大程度的完美，使用了较多的更名以达到与白苹果设备原生命名相同
- 添加了许多SSDT补丁，来仿冒一些缺少的白苹果下原生设备，同时解决了睡眠秒醒的问题
- USB电源也通过SSDT注入EC和USBX设备，配合我自定义的USB端口kext来完美解决

