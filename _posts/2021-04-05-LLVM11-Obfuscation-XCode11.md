---
layout: post
title: XCode11下兼容arm64e的代码混淆编译器llvm11

categories:
- LLVM

tags: [LLVM-Obfuscation]

author:
  login: lanbing
  email: c834606877@163.com
---


对于ios程序，即使对binnary进行了加密，但启动之后加载到了memory中，还是存在一个解密的过程。
所以从源码以及编译器级别，对binary代码进行混淆是对抗安全攻击的最有效方法。

最新的apple处理器 a12 a13增加了arm64e架构，同时兼容arm64指令。

然而目前的最新的llvm-obfuscation 最高支持到llvm9，支持arm64e的llvm版本最低到llvm11。

去github上从apple的仓库中拉了llvm11的代码下来，给编译了一下，参考了现有的代码。重新实现了一个以支持arm64e。


<!--more-->

具体实现过程暂时搁置。
Repo：https://github.com/c834606877/llvm-project


