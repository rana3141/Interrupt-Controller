# Interrupt-Controller

Interrupt Controller

Two Interfaces
1. APB - towards Processor
2. Peripheral 

Ports of IC:

1. Common
	input clk, reset

2. APB - Between Processor & IC - To communicate with priority registers
a. input pwrite  - Write/read enable
b. input paddr   - Address to assign priority in priority registers
c. input pwdata  - Priority value
d. input penable - When enabled only then valid write/read transactions
e. output pready - Acknowledgement that transaction successful
f. output prdata - Not Needed as we are not reading anything

3. Peripherals to IC
	input interrupt_active - peripherals that want to raise an interrput

4. Processor & IC
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
