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
	
	wire [MEM_NUM_CHANNELS-1 : 0] en,we	;
	wire [MEM_ADDR_BITS-1    : 0] addr  ;
	
	localparam preloadfile [MEM_NUM_CHANNELS-1 : 0] ; 

	wire [MEM_NUM_CHANNELS-1 : 0] request,grant,pre_grant;
	reg  [MEM_NUM_CHANNELS-1 : 0] pre_state;

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			pre_state <= `MEM_NUM_CHANNELS'd1;
		end else begin
			pre_state <= {pre_grant[MEM_NUM_CHANNELS-2:0],pre_grant[MEM_NUM_CHANNELS-1]};
		end
	end

	assign pre_grant = {1'b1,request} & ~({1'b1,request} - 1'b1);
	
	assign grant = {1'b1,request} & ~({1'b1,request} - pre_state);


	//generate signal en & we & addr
	genvar i;
	generate
	for(i=0,i<MEM_NUM_CHANNELS,i=i+1) begin
		assign en	 =  grant[i];
		assign we	 = !read_valid[i] & write_valid[i];
		
		assign addr	 =  read_valid[i] ?  read_address[i] : 
					   ( write_valid[i] ? write_address[i] : 'd0 ); 
			
	end
	endgenerate

		ram #(
			.preloadfile    (preloadfile[i]		),
			.MEM_ADDR_BITS	(MEM_ADDR_BITS		),
			.MEM_DATA_BITS	(MEM_DATA_BITS		)
		) u_ram (
			.clk			(clk				),
			.rst_n			(rst_n				),
			.en				(en					),
			.we				(we					),
			.addr			(addr				),
			.din			(write_data[i]		),
			.dout			(read_data[i]		)
		); 



endmodule
