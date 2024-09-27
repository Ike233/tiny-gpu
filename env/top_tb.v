module top_tb();

	reg	clk,rst_n,start;

	defparam u_prog_mem.preloadfile = "/nfs/home/ningyu/self_study/tiny_gpu/tiny-gpu/env/mem.vmf" 



	initial begin
		clk   = 1'b0;
		rst_n = 1'b0;
		start = 1'b0;
		always #5 clk = ~clk;
		#1000
		rst_n = 1'b1;
		#1000
		start = 1'b1;
	end

	wire	[PROGRAM_MEM_NUM_CHANNELS-1 : 0]	program_mem_read_valid										;		
	wire 	[PROGRAM_MEM_ADDR_BITS-1    : 0]	program_mem_read_address	[PROGRAM_MEM_NUM_CHANNELS-1 : 0];	
	wire 	[PROGRAM_MEM_NUM_CHANNELS-1 : 0]	program_mem_read_ready										;	
	wire 	[PROGRAM_MEM_DATA_BITS-1    : 0]	program_mem_read_data		[PROGRAM_MEM_NUM_CHANNELS-1 : 0];		

	wire	[DATA_MEM_NUM_CHANNELS-1 : 0]	data_mem_read_valid										;		
	wire 	[DATA_MEM_ADDR_BITS-1    : 0]	data_mem_read_address	[DATA_MEM_NUM_CHANNELS-1 : 0]	;	
	wire 	[DATA_MEM_NUM_CHANNELS-1 : 0]	data_mem_read_ready										;	
	wire 	[DATA_MEM_DATA_BITS-1    : 0]	data_mem_read_data		[DATA_MEM_NUM_CHANNELS-1 : 0]	;		
	wire 	[DATA_MEM_NUM_CHANNELS-1 : 0]	data_mem_write_valid									;				
	wire 	[DATA_MEM_ADDR_BITS-1    : 0]	data_mem_write_address	[DATA_MEM_NUM_CHANNELS-1 : 0]	;		
	wire 	[DATA_MEM_DATA_BITS-1    : 0]	data_mem_write_data		[DATA_MEM_NUM_CHANNELS-1 : 0]	;			
	wire 	[DATA_MEM_NUM_CHANNELS-1 : 0]	data_mem_write_ready									;		


	gpu #(
		.DATA_MEM_ADDR_BITS				(DATA_MEM_ADDR_BITS			),
		.DATA_MEM_DATA_BITS				(DATA_MEM_DATA_BITS			),
		.DATA_MEM_NUM_CHANNELS			(DATA_MEM_NUM_CHANNELS		),
		.PROGRAM_MEM_ADDR_BITS			(PROGRAM_MEM_ADDR_BITS		),
		.PROGRAM_MEM_DATA_BITS			(PROGRAM_MEM_DATA_BITS		),
		.PROGRAM_MEM_NUM_CHANNELS		(PROGRAM_MEM_NUM_CHANNELS	),
		.NUM_CORES						(NUM_CORES					),
		.THREADS_PER_BLOCK				(THREADS_PER_BLOCK			)
	) dut (
		.clk							(clk						),//i(1)
		.reset							(!rst_n						),//i(1)
		.start							(start						),//i(1)
		.done							(							),//o(1)
		.device_control_write_enable	(1'b1						),//i(1)
		.device_control_data			(8'd4						),//i(8)
		.program_mem_read_valid			(program_mem_read_valid		),//o(PROGRAM_MEM_NUM_CHANNELS)
		.program_mem_read_address		(program_mem_read_address	),//o(PROGRAM_MEM_ADDR_BITS*PROGRAM_MEM_NUM_CHANNELS)
		.program_mem_read_ready			(program_mem_read_ready		),//i(PROGRAM_MEM_NUM_CHANNELS)
		.program_mem_read_data			(program_mem_read_data		),//i(PROGRAM_MEM_DATA_BITS*PROGRAM_MEM_NUM_CHANNELS)
		.data_mem_read_valid			(data_mem_read_valid		),//o(DATA_MEM_NUM_CHANNELS)
		.data_mem_read_address			(data_mem_read_address		),//o(DATA_MEM_ADDR_BITS*DATA_MEM_NUM_CHANNELS)
		.data_mem_read_ready			(data_mem_read_ready		),//i(DATA_MEM_NUM_CHANNELS)
		.data_mem_read_data				(data_mem_read_data			),//i(DATA_MEM_DATA_BITS*DATA_MEM_NUM_CHANNELS)
		.data_mem_write_valid			(data_mem_write_valid		),//o(DATA_MEM_NUM_CHANNELS)
		.data_mem_write_address			(data_mem_write_address		),//o(DATA_MEM_ADDR_BITS*DATA_MEM_NUM_CHANNELS)
		.data_mem_write_data			(data_mem_write_data		),//o(DATA_MEM_DATA_BITS*DATA_MEM_NUM_CHANNELS)
		.data_mem_write_ready			(data_mem_write_ready		) //i(DATA_MEM_NUM_CHANNELS)
	);

	
	mem_wrapper #(
		.preloadfile		(							),
		.MEM_ADDR_BITS		(DATA_MEM_ADDR_BITS			),
		.MEM_DATA_BITS		(DATA_MEM_DATA_BITS			),
		.MEM_NUM_CHANNELS	(DATA_MEM_NUM_CHANNELS		)
	) u_data_mem (
		.clk				(clk						),//i(1)	
		.rst_n				(rst_n						),//i(1)	
		.read_valid			(data_mem_read_valid		),//i(DATA_MEM_NUM_CHANNELS)	
		.read_address		(data_mem_read_address		),//i(DATA_MEM_ADDR_BITS*DATA_MEM_NUM_CHANNELS	
		.read_ready			(data_mem_read_ready		),//o(DATA_MEM_NUM_CHANNELS)	
		.read_data			(data_mem_read_data			),//o(DATA_MEM_DATA_BITS*DATA_MEM_NUM_CHANNELS)	       
		.write_valid		(data_mem_write_valid		),//i(DATA_MEM_NUM_CHANNELS)	
		.write_address		(data_mem_write_address		),//i(DATA_MEM_ADDR_BITS*DATA_MEM_NUM_CHANNELS)	
		.write_ready		(data_mem_write_ready		),//o(DATA_MEM_NUM_CHANNELS)	
		.write_data			(data_mem_write_data		),//i(DATA_MEM_DATA_BITS*DATA_MEM_NUM_CHANNELS)	
	);


	mem_wrapper #(
		.preloadfile		(								),
		.MEM_ADDR_BITS		(PROGRAM_MEM_ADDR_BITS			),
		.MEM_DATA_BITS		(PROGRAM_MEM_DATA_BITS			),
		.MEM_NUM_CHANNELS	(PROGRAM_MEM_NUM_CHANNELS		)
	) u_prog_mem (
		.clk				(clk							),//i(1)	
		.rst_n				(rst_n							),//i(1)	
		.read_valid			(program_mem_read_valid			),//i(DATA_MEM_NUM_CHANNELS)	
		.read_address		(program_mem_read_address		),//i(DATA_MEM_ADDR_BITS*DATA_MEM_NUM_CHANNELS	
		.read_ready			(program_mem_read_ready			),//o(DATA_MEM_NUM_CHANNELS)	
		.read_data			(program_mem_read_data			),//o(DATA_MEM_DATA_BITS*DATA_MEM_NUM_CHANNELS)	       
		.write_valid		(1'b0							),//i(DATA_MEM_NUM_CHANNELS)	
		.write_address		( 'b0							),//i(DATA_MEM_ADDR_BITS*DATA_MEM_NUM_CHANNELS)	
		.write_ready		(								),//o(DATA_MEM_NUM_CHANNELS)	
		.write_data			( 'b0							),//i(DATA_MEM_DATA_BITS*DATA_MEM_NUM_CHANNELS)	
	);

endmodule 
