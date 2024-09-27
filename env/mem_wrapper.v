module mem_wrapper#(
		parameter preloadfile = "mem.vmf",
		parameter MEM_ADDR_BITS = 8,
		parameter MEM_DATA_BITS = 16,
		parameter MEM_NUM_CHANNELS = 4
	)(
		input									clk,
		input									rst_n,
		
		input		[MEM_NUM_CHANNELS-1 : 0]	read_valid								,
		input		[MEM_ADDR_BITS-1    : 0]    read_address	[MEM_NUM_CHANNELS-1 : 0],
		output		[MEM_NUM_CHANNELS-1 : 0]    read_ready								,
		output  	[MEM_DATA_BITS-1    : 0]    read_data		[MEM_NUM_CHANNELS-1 : 0],

		input		[MEM_NUM_CHANNELS-1 : 0]	write_valid								,
		input		[MEM_ADDR_BITS-1    : 0]    write_address	[MEM_NUM_CHANNELS-1 : 0],
		output  	[MEM_NUM_CHANNELS-1 : 0]    write_ready								,
		input		[MEM_DATA_BITS-1    : 0]    write_data		[MEM_NUM_CHANNELS-1 : 0]
	);
	
	wire [MEM_NUM_CHANNELS-1 : 0] en,we							;
	wire [MEM_ADDR_BITS-1    : 0] addr [MEM_NUM_CHANNELS-1 : 0] ;
	
	localparam preloadfile [MEM_NUM_CHANNELS-1 : 0] ; 

	//generate signal en & we & addr
	genvar i;
	generate
	for(i=0,i<MEM_NUM_CHANNELS,i=i+1) begin
		assign en[i] =  read_valid[i] | write_valid[i];
		assign we[i] = !read_valid[i] & write_valid[i];
		
		assign addr[i] =  read_valid[i] ?  read_address[i] : 
					   ( write_valid[i] ? write_address[i] : 'd0 ); 

		ram #(
			.preloadfile    (preloadfile[i]		),
			.MEM_ADDR_BITS	(MEM_ADDR_BITS		),
			.MEM_DATA_BITS	(MEM_DATA_BITS		)
		) u_ram (
			.clk			(clk				),
			.rst_n			(rst_n				),
			.en				(en[i]				),
			.we				(we[i]				),
			.addr			(addr[i]			),
			.din			(write_data[i]		),
			.dout			(read_data[i]		)
		); 
			
	end
	endgenerate

endmodule
