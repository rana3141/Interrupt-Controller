# Interrupt-Controller RTL

An Interrupt Controller is a hardware component that manages and prioritizes interrupt requests (IRQs) from different peripheral devices or internal components in a computer or embedded system. Its primary function is to allow the CPU to handle interrupts efficiently, ensuring that higher-priority interrupts are processed first while lower-priority interrupts are delayed.

Block Diagram:

![Interrupt_controller_block_diag drawio](https://github.com/user-attachments/assets/325d625c-ebe3-4234-a59b-af3a07c47b48)


Two Interfaces:
1. APB Interface - towards Processor
3. Peripheral Interface


Ports of Interrupt Controller:

1. Common

![image](https://github.com/user-attachments/assets/d511645c-4fdd-4335-a41f-02535ff88f07)

2. APB - Between Processor & IC - To communicate with priority registers

![image](https://github.com/user-attachments/assets/61cb5dfd-02a2-4f33-8da1-cc31f54d99e1)

3. Peripherals to IC

![image](https://github.com/user-attachments/assets/e82c75cd-2dba-4632-8d71-3a53be3fd4cf)

4. Processor & IC

![image](https://github.com/user-attachments/assets/512cd644-d509-4131-a937-10231081f5de)


Operation steps:
1. Processor assigns priority to interrupts in Priority registers - APB interface
2. Interrupt is raised by the peripherals - interrupt_active
3. According to the highest priority, peripheral number is given to the processor - interrupt_to_be_service & interrupt_valid
4. After servicing the interrupt the processor sends an acknowledgement to the IC - interrupt_serviced


Two Always block in RTL:
1. Modelling priority register
2. Interrupt handling towards peripherals - state machine 
