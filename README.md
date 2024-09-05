# Interrupt-Controller

Interrupt Controller

Two Interfaces
1. APB - towards Processor
3. Peripheral 

Ports of IC:

1. Common

![image](https://github.com/user-attachments/assets/49f89a08-df78-4163-8d79-0a0f0da5b485)

2. APB - Between Processor & IC - To communicate with priority registers

![image](https://github.com/user-attachments/assets/61cb5dfd-02a2-4f33-8da1-cc31f54d99e1)

4. Peripherals to IC
	input interrupt_active - peripherals that want to raise an interrput

5. Processor & IC
	input interrupt_serviced - acknowledgement from processor that interrupt has been serviced
	output interrupt_to_be_service - highest priority interrupt is provided to processor
	input interrupt_valid

Operation:
1. Processor assigns priority to interrupts in Priority registers - APB interface
2. Interrupt is raised by the peripherals - interrupt_active
3. According to the highest priority, peripheral number is given to the processor - interrupt_to_be_service & interrupt_valid
4. After servicing the interrupt the processor sends an acknowledgement to the IC - interrupt_serviced

Two Always block in RTL:
1. Modelling priority register
2. Interrupt handling towards peripherals - state machine 
