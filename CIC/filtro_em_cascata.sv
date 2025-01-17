
module filter#(parameter WIDTH = 8, SIZE = 16)(
		input logic 				clock		,
									reset		,
		input logic  [WIDTH-1:0] 	x_in		,
		output logic [WIDTH-1:0] y_out			);
	logic ena;
	assign ena =1;
	logic  [WIDTH-1:0]wire_out_integ[SIZE-1:0];
	logic  [WIDTH-1:0]wire_out_comb[SIZE-1:0];
	logic  [WIDTH-1:0]integ_wire_comb;
	logic [4:0] counter;
	always_ff@(posedge clock, negedge reset)begin
		if(!reset)counter <= 0;
		else if(counter == SIZE-1)counter <= 0;
		else counter <=counter+1;
	end
	always_comb 			integ_wire_comb <= !counter ? wire_out_integ[0]: 0;
	assign 					y_out = counter == SIZE-1 ?  wire_out_comb[0]/SIZE :y_out;
	genvar i; generate begin
			for(i = 1; i < SIZE; i=i+1)begin:gen
			integrator integ_n_(
					.clock(clock)				,
					.reset(reset)				,
					.ena(ena)					,
					.x_in(wire_out_integ[i-1])	,
					.y_out(wire_out_integ[i])			
			);
			comb comb_n(
                	.clock(clock)					,
    		    	.reset(reset)					,
                	.ena(ena)						,
                	.x_in(wire_out_comb[i-1])		,
                	.y_out(wire_out_comb[i])
			);
	end end endgenerate
	integrator integ_n0(
			.clock(clock),
			.reset(reset),
			.ena(ena),
			.x_in(x_in),
			.y_out(wire_out_integ[0])
	);

	comb comb_n0(
			.clock(clock),
			.reset(reset),
			.ena(ena),
			.x_in(integ_wire_comb),
			.y_out(wire_out_comb[0])

	);	
endmodule

