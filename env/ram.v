module ram #(
	parameter preloadfile   = "mem.vmf",
	parameter MEM_ADDR_BITS = 8,
	parameter MEM_DATA_BITS = 16
) (
	input										clk			,
	input										rst_n		,
	
	input										en			,
	input										we			,
	input		[MEM_ADDR_BITS-1 : 0]			addr		,
	input		[MEM_DATA_BITS-1 : 0]			din			,
	output	reg	[MEM_DATA_BITS-1 : 0]			dout	
);

	reg [MEM_DATA_BITS-1 : 0] mem [2**MEM_ADDR_BITS-1 : 0];

	initial begin
		$readmemh(preloadfile,mem);
	end

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)	begin
			dout	<=	'd0;
		end else if(en) begin
			if (we) begin
				mem[addr] <= din;
			end else begin
				dout	  <= mem[addr];
			end
		end
	end
	
endmodule 
