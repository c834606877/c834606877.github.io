---
layout: post
title: MSP432 使用Timer_A输出PWM

categories:
- MSP432
- MCU

tags: [MCU, MSP432, Timer_A, PWM]

author:
  login: lanbing
  email: c834606877@163.com
---


## Timer_A 输出 PWM的问题

在官方例程中给出的是一种直接操作寄存器的方式启动的，这让我们这些刚刚接触MSP432这种嵌入式芯片的来说是很难看懂的，然而PWM的输出是可以重新映射到其它端口输出的，例程中又掺杂了PMAP GPIO端口的映射，这更使得学习无从下手。

### 通过寄存器操作的方式输出PWM波形

```
    TIMER_A0->CCR[0] = PWM_PERIOD;
    TIMER_A0->CCTL[1] = TIMER_A_CCTLN_OUTMOD_7;      // CCR1 Reset/set
    TIMER_A0->CCR[1] = PWM_PERIOD * (55 / 100.0);    // CCR1 PWM duty cycle
    TIMER_A0->CTL = TIMER_A_CTL_SSEL__SMCLK // 使用SMCLK时钟源
                  | TIMER_A_CTL_MC__UP   
                  | TIMER_A_CTL_CLR;  // SMCLK, up mode, clear TAR
```


引用`msp432p401r.h`头文件定义:
```c
#define TIMER_A_CTL_MC__UP    ((uint16_t)0x0010)    /*!< Up mode: Timer counts up to TAxCCR0 */
```
通过 动态修改 TIMER_A0->CCR[1] 内容可以改变PWM间隔时间


### 通过DriverLib操作的方式输出PWM波形
```c
/* Timer_A PWM Configuration Parameter */
Timer_A_PWMConfig pwmConfig =
{
    TIMER_A_CLOCKSOURCE_SMCLK,
    TIMER_A_CLOCKSOURCE_DIVIDER_1,
    32000,
    TIMER_A_CAPTURECOMPARE_REGISTER_1,
    TIMER_A_OUTPUTMODE_RESET_SET,
    3200
};
Timer_A_generatePWM(TIMER_A1_BASE, &pwmConfig);

Timer_A_setCompareValue(TIMER_A2_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_1, PWM_PERIOD * (50/100.0f)); //动态设置PWM 间隔时间
```

而timer_a.C文件中对`Timer_A_generatePWM`函数定义如下

```c
void Timer_A_generatePWM(uint32_t timer, const Timer_A_PWMConfig *config)
{
    //此处省略一部分，参数合法判断...

    privateTimer_AProcessClockSourceDivider(timer, config->clockSourceDivider);

    TIMER_A_CMSIS(timer)->CTL &=
            ~(TIMER_A_CLOCKSOURCE_INVERTED_EXTERNAL_TXCLK + TIMER_A_UPDOWN_MODE
                    + TIMER_A_DO_CLEAR + TIMER_A_TAIE_INTERRUPT_ENABLE);

    TIMER_A_CMSIS(timer)->CTL |= (config->clockSource + TIMER_A_UP_MODE
            + TIMER_A_DO_CLEAR);

    TIMER_A_CMSIS(timer)->CCR[0] = config->timerPeriod;

    TIMER_A_CMSIS(timer)->CCTL[0] &= ~(TIMER_A_CAPTURECOMPARE_INTERRUPT_ENABLE
            + TIMER_A_OUTPUTMODE_RESET_SET);

    uint8_t idx = (config->compareRegister>>1) - 1;
    TIMER_A_CMSIS(timer)->CCTL[idx] |= config->compareOutputMode;
    TIMER_A_CMSIS(timer)->CCR[idx] = config->dutyCycle;
}
```
可以看到相关操作与寄存器类似，但一次只能修改一路PWM输出。难怪官方例程中直接使用寄存器操作，多路输出更加容易控制。
