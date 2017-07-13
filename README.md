# 基于 [theos-jailed](https://github.com/BishopFox/theos-jailed) 的非越狱环境Hook快速开发工作流

前端时间看到 [FishChat](https://github.com/yulingtianxia/FishChat) 这个项目，是在非越狱环境下进行Hook，项目本身用到了CaptainHook来进行开发。
了解过越狱环境开发的同学一定用过Logos来写Tweak，那么如果这个项目采用Logos来进行开发，项目代码可能更易读一些。 正好有 [theos-jailed](https://github.com/BishopFox/theos-jailed) 这个项目，可以将Tweak应用到非越狱环境下。 本项目从FishChat中选取一个小功能：`修改步数`，来做个示范，怎么来达到这个目的。

## 准备工作

1. 安装 (theos)[http://iphonedevwiki.net/index.php/Theos/Setup] 和 (theos-jailed)[https://github.com/BishopFox/theos-jailed]
   其中，前者用于越狱环境开发的工具；后者用于将前者代码打包部署到非越狱环境的工具。 

2. 使用 `theos 的 nic.pl` 创建 `iphone/tweak` 工程， 命名 `jailbrokentweak`

3. 使用 `theos-jailed 的 nic.pl` 创建 `iphone/tweak` 工程， 命名 `jailedtweak`



## 开始处理 jailbrokentweak

不熟悉Logos语法的同学可以先从 [此页面](http://iphonedevwiki.net/index.php/Logos) 了解一下。

通过阅读FishChat的源代码我们知道，需要实现修改步数的功能，要`Hook WCDeviceStepObject` 的 `- (unsigned int)m7StepCount` ，此外，参考FishChat的实现，还需要实现一个输入步数的功能即可。 具体实现参考代码。

需要注意的点： 
1. `jailbrokentweak` 的 `Makefile` 里 添加了 `THEOS_DEVICE_IP = 127.0.0.1 -p 2229`， 是使用 `usbmuxd` 讲设备端口映射了一下

2. `JailbrokenTweak_FILES = $(wildcard ./*.xm)` 来匹配当前目录下的所有xm文件

## 开始处理 jailedtweak

在上一步越狱环境下 `jailbrokentwea` 工程测试OK后，将 `*.h *.xm` 文件拷贝到 `jailedtwea`k 下，对应修改 `Makefile` 。 我的测试工程 `jailedtweak` 中删除了没有用到的文件。 

准备好文件后，make编译一下，如果遇到错误 `library not found for -ldylib1.o`，请下载 `xcode7`, 然后使用 `xcode-select`设置使用xcode7, 比如我的设置 `sudo xcode-select -s /Applications/Xcode731.app/Contents/Developer/`

编译成功后，找到 `obj/JailedTweak.dylib` 文件，让我们看看发生了什么变化，`otool -L obj/JailedTweak.dylib`，可以看到，它将 `CydiaSubstrate`的依赖自动加上了 `@executable_path/CydiaSubstrate`，所以我们在最终打包的时候也需要拷贝 `CydiaSubstrate`，那么它在哪？ 其实就在 `jailedtweak/PatchApp/` 中

## 打包签名

`jailedtweak` make 完成后，会调用其中的 `patchapp.sh`来自动尝试打包，不过不太好用，可以自己通过签名脚本实现，注意的是需要拷贝 `JailedTweak.dylib 和 CydiaSubstrate ` 两个文件到包中，然后使用 `yololib` 注入 `JailedTweak.dylib` (只需注入该文件即可)。

安装运行 :-)

