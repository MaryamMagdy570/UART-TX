module TX_MUX 
(
  input wire [1:0]  MUX_Selection,
  input wire        Serial_Data,
  input wire        Parity_Bit,
  output reg        TX_OUT
);

localparam  LOGIC_ONE = 2'b00,    // for idle and stop
            LOGIC_ZERO = 2'b01,   // for start
            DATA_BITS = 2'b10,
            PARITY_BIT = 2'b11;


always @ (*)
  begin
    case(MUX_Selection)
      LOGIC_ONE:  begin
                    TX_OUT = 1'b1;
                  end 
      LOGIC_ZERO: begin
                    TX_OUT = 1'b0;
                  end 
      DATA_BITS:  begin
                    TX_OUT = Serial_Data;
                  end 
      PARITY_BIT: begin
                    TX_OUT = Parity_Bit;
                  end 
      default:    begin
                    TX_OUT = 1'b1;
                  end
    endcase
  end


endmodule