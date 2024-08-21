// Interrupt Controller Testbench
module tb;

parameter NO_OF_PERIPHERALS = 16;
parameter WIDTH = $clog2(NO_OF_PERIPHERALS);

//APB - Master/Processor to IC
reg pclk,preset,penable,pwrite;
reg [WIDTH-1:0] paddr;
reg [WIDTH-1:0] pwdata;
wire [WIDTH-1:0] prdata;	// No need of rdata
wire pready;

// Peripherals to IC
reg [NO_OF_PERIPHERALS-1:0] interrupt_active;

//Processor to IC
reg interrupt_serviced;
wire [WIDTH-1:0] interrupt_to_be_service;
wire interrupt_valid;

interrupt_controller #(.NO_OF_PERIPHERALS(NO_OF_PERIPHERALS), .WIDTH(WIDTH)) dut (
pclk,preset,paddr,pwdata,prdata,penable,pwrite,pready,pwrite,interrupt_active,interrupt_to_be_service,interrupt_serviced,interrupt_valid);

always #5 pclk = ~pclk;

initial begin
	pclk = 0;
	preset = 1;
	reset_signals();
	#30;
	preset = 0;
	for (int i=0;i<NO_OF_PERIPHERALS;i++) begin
		write(i,i);			// Every edge this task is called
	end
	interrupt_active = $random;
	#500;
	$finish();
end

// Processor Modelling
always @(posedge pclk) begin
	if (interrupt_to_be_service != 0) begin
		#20;
		interrupt_active[interrupt_to_be_service] = 0;
		interrupt_serviced = 1;
		#10;
		interrupt_serviced = 0;
	end	
end

// Reset
task reset_signals();
	penable = 0;
	pwrite = 0;
	paddr = 0;
	pwdata = 0;
	interrupt_active = 0;
	interrupt_serviced = 0;
endtask : reset_signals

// Write 
task write(input [WIDTH-1:0] addr, input [WIDTH-1:0] priority_data);
	@(posedge pclk)
	pwrite = 1;
	paddr = addr;
	pwdata = priority_data;
	penable = 1;
	wait(pready==1);

	@(posedge pclk);
	pwrite = 0;
	paddr = 0;
	pwdata = 0;
	penable = 0;
endtask : write
  
  initial begin
    $dumpfile("fifo.vcd");
   $dumpvars(0, tb);
 end


endmodule : tb