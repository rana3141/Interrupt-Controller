module interrupt_controller(
//APB ports
pclk,preset,paddr,pwdata,prdata,penable,pready,pwrite,
//IC
interrupt_active,interrupt_to_be_service,interrupt_serviced,interrupt_valid
);

parameter NO_OF_PERIPHERALS = 8;

//Address width of priority register depending on No of Peripherals
parameter WIDTH = $clog2(NO_OF_PERIPHERALS);

parameter S_NO_INTERRUPT 	 = 3'b001;
parameter S_ACTIVE_INTERRUPT = 3'b010;
parameter S_SERVICE_DONE	 = 3'b100;

//APB - Master/Processor to IC
input pclk,preset,penable,pwrite;	
input [WIDTH-1:0] paddr;		// Address of priority register
input [WIDTH-1:0] pwdata;		// Priority value
output reg [WIDTH-1:0] prdata;	// No need, only writing
output reg pready;

// Peripherals to IC
input [NO_OF_PERIPHERALS-1:0] interrupt_active;

//Processor to IC
input interrupt_serviced;
output reg [WIDTH-1:0] interrupt_to_be_service;
output reg interrupt_valid;

// Register for storing priority values of peripherals like (name & number) and it acts like a memory
reg [WIDTH-1:0] priority_reg [NO_OF_PERIPHERALS-1:0];

// Internal Registers
reg [2:0] state,next_state;
reg [WIDTH-1:0] highest_priority_value;
reg [WIDTH-1:0] highest_priority_peri;
reg flag;

// There are 3 processes in IC
// 1 - Modelling Priority Register
always @(posedge pclk) begin
	if (preset) begin
		prdata = 0;
		pready = 0;
		state = S_NO_INTERRUPT;
		next_state = S_NO_INTERRUPT;
		interrupt_to_be_service = 0;
		interrupt_valid = 0;
		flag = 0;
		highest_priority_peri = 0;
		highest_priority_value = 0;
		for (int i=0;i<NO_OF_PERIPHERALS;i++) priority_reg[i] = 0;
	end
	else begin
		if (penable==1) begin
			pready = 1;
			if (pwrite==1) begin
				priority_reg[paddr] = pwdata;
			end
			else begin
				prdata = priority_reg[paddr];
			end
		end
		else begin
			pready = 0;
		end
	end
end

// 2- Handling interrupts 
always @(posedge pclk) begin
	if (preset == 0) begin
		case (state)
			S_NO_INTERRUPT: begin
				if(interrupt_active != 0) begin
					next_state = S_ACTIVE_INTERRUPT;
					flag = 1;
				end
				else begin
					next_state = S_NO_INTERRUPT;
				end
			end
			S_ACTIVE_INTERRUPT: begin
				for (int i=0;i<NO_OF_PERIPHERALS;i++) begin
					if (interrupt_active[i] == 1) begin
						if (flag) begin
							highest_priority_value = priority_reg[i];
							highest_priority_peri = i;
							flag = 0;
						end
						else begin
							if (priority_reg[i] > highest_priority_value) begin
								highest_priority_value = priority_reg[i];
								highest_priority_peri = i;
							end
						end
					end
				end
				interrupt_valid = 1;
				interrupt_to_be_service = highest_priority_peri;
				next_state = S_SERVICE_DONE;
			end
			S_SERVICE_DONE : begin
				if (interrupt_serviced) begin
					interrupt_valid = 0;
					interrupt_to_be_service = 0;
					highest_priority_peri = 0;
					highest_priority_value = 0;
					if (interrupt_active != 0) begin
						next_state = S_ACTIVE_INTERRUPT;
						flag = 1;
					end
					else begin
						next_state = S_NO_INTERRUPT;
					end
				end
			end
		endcase
	end
end

always @(posedge pclk) begin
	state <= next_state;
end

endmodule