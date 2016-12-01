/*
*
* main.c: starting point for exercise 4A in INF3430/INF4431
*
*/

/* Include files */
#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xgpio.h"
#include "xstatus.h"
#include "xil_printf.h"

/* Definitions */
#define GPIO_DEVICE_ID XPAR_AXI_GPIO_0_DEVICE_ID
#define LED_DELAY 100000000
#define BTN_CHANNEL 2
#define printf xil_printf

XGpio Gpio;

int SwitchLedExample(void)
{
    volatile int Delay;
    int Status;

    /* GPIO driver initialization */
    Status = XGpio_Initialize(&Gpio, GPIO_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    /* Set port direction */
    XGpio_SetDataDirection(&Gpio, BTN_CHANNEL, 0xff);

    /* Loop forever */
    while (1) {
        u32 buttonRead =  XGpio_DiscreteRead(&Gpio, BTN_CHANNEL);
        xil_printf("Read: %x\r\n",  buttonRead);

        for (Delay = 0; Delay < 10000000; Delay++); // Add a delay for readability
    }

    return XST_SUCCESS; /* Ideally unreachable */
}

int main(){

    init_platform();

    int Status;

    /* Execute the example code. */
    Status = SwitchLedExample();

    /* Check function return and report over UART. */
    if (Status != XST_SUCCESS) {
        xil_printf("The example code failed!\r\n");
    }

    cleanup_platform();
    return 0;
}
