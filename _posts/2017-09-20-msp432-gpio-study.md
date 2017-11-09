---
layout: post
title: MSP432中GPIO中断相关操作

categories:
- MSP432
- MCU

tags: [MCU，MSP432，GPIO]

author:
  login: lanbing
  email: c834606877@163.com
---



# GPIO 中断的用法

GPIO的P1,P2,PA支持中断

## MSP432 中的中断相关寄存器
PxIFG 中断标志寄存器
PxIV 中断向量寄存器


## Driverlib 所涉及到GPIO中断的函数


GPIO_registerInterrupt GPIO_unregisterInterrupt
//Registers/UnRegister s an interrupt handler for the port interrupt.
GPIO_disableInterrupt
GPIO_enableInterrupt
GPIO_getEnabledInterruptStatus
GPIO_interruptEdgeselect
GPIO_getInterruptStatus
GPIO_clearInterruptFlag 



![GPIO_IES寄存器][/post_res/GPIO_IES.png]

![GPIO_PxIFG寄存器][/post_res/GPIO_PxIFG.png]

![GPIO_PxIV寄存器][/post_res/GPIO_PxIV.png]

## 对中断的配置
```c
/* Confinguring P1.1 & P1.4 as an input and enabling interrupts */
MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P1, GPIO_PIN1 | GPIO_PIN4);
MAP_GPIO_clearInterruptFlag(GPIO_PORT_P1, GPIO_PIN1 | GPIO_PIN4);
MAP_GPIO_enableInterrupt(GPIO_PORT_P1, GPIO_PIN1 | GPIO_PIN4);
MAP_GPIO_interruptEdgeSelect(GPIO_PORT_P1, GPIO_PIN1 | GPIO_PIN4, GPIO_HIGH_TO_LOW_TRANSITION);
```
