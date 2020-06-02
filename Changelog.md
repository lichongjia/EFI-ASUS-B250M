## OpenCore更新日志

***注意：在已经稳定完善的情况下，我可能不会那么及时地更新版本号！！！***

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
