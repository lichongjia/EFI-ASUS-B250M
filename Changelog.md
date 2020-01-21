## OpenCore更新日志

#### 2020/01/21（0.5.4）

- OpenCore更新到0.5.4
- 添加Windows10引导项(默认隐藏)，开机按“Opiton/Alt”键(也可用Esc代替)即可显示所有引导项
- 所有驱动更新到当前最新版

#### 2019/12/03（0.5.3）

- OpenCore更新到0.5.3
- 推荐在OC上使用VirtualSMC
- 启动速度都差不多，我亲自测试过Clover和OC都在15s左右



## Clover更新日志

#### 2020/01/21（v3.1）

- Clover版本更新到5103
- 使用FwRuntimeServices.efi和OcQuirks.efi替换掉了AptioMemoryFix.efi
- 所有Kext驱动采用当前最新源代码编译

#### 2019/12/09（v3）

- Clover版本更新到5100

#### 2019/12/02（v3）

- Clover版本更新到5099
- 从VirtualSMC换回FackSMC，感觉Clover还是配FackSMC比较好，传感器更齐全
- 为了最大程度的完美，使用了较多的更名以达到与白苹果设备原生命名相同
- 添加了许多SSDT补丁，来仿冒一些缺少的白苹果下原生设备，同时解决了睡眠秒醒的问题
- USB电源也通过SSDT注入EC和USBX设备，配合我自定义的USB端口kext来完美解决