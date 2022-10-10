module TX_FSM 
(
  input wire          CLK,
  input wire          RST,
  input wire          Parity_Enable,
  input wire          Data_Valid,
  input wire          Serializer_DoneFlag,
  output reg          Serializer_Enable,
  output reg  [1:0]   Mux_Selection,
  output reg          Busy
);

localparam  IDLE = 3'b000,
            START = 3'b001,
            DATA = 3'b010,
            PARITY = 3'b011,
            STOP = 3'b100;

            
localparam  Logic_One = 2'b00,
            Logic_Zero = 2'b01,
            Data_Bits = 2'b10,
            Parity_Bit = 2'b11;


reg [2:0] Current_State;
reg [2:0] Current_State_comb;


always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        Current_State <= IDLE;
      end
    else
      begin
        Current_State <= Current_State_comb;
      end
  end


always @ (*)
  begin
    case(Current_State)
      IDLE:   begin
                if(Data_Valid)
                  begin
                    Current_State_comb = START;
                  end          
                else
                  begin
                    Current_State_comb = IDLE;
                  end
              end
      START:  begin
                Current_State_comb = DATA;
              end
      DATA:   begin
                if(Serializer_DoneFlag && Parity_Enable)
                  begin
                    Current_State_comb = PARITY;
                  end
                else if(Serializer_DoneFlag && !Parity_Enable)
                  begin
                    Current_State_comb = STOP;
                  end
                else
                  begin
                    Current_State_comb = DATA;
                  end
              end
      PARITY: begin
                Current_State_comb = STOP;
              end
      STOP:   begin
                Current_State_comb = IDLE;
                /*
                if(Data_Valid)
                  begin
                    Current_State_comb = START;
                  end
                else
                  begin
                    Current_State_comb = IDLE;
                  end
                */
              end
      default:begin
                Current_State_comb = IDLE;  
              end
    endcase
  end

always @ (*)
  begin
    case(Current_State)
      IDLE:   begin
                Serializer_Enable = 0;
                Mux_Selection = Logic_One;
                Busy = 0;
              end
      START:  begin
                Serializer_Enable = 1;
                Mux_Selection = Logic_Zero;
                Busy = 1;
              end
      DATA:   begin
                Serializer_Enable = 0;
                Mux_Selection = Data_Bits;
                Busy = 1;
              end
      PARITY: begin
                Serializer_Enable = 0;
                Mux_Selection = Parity_Bit;
                Busy = 1;
              end
      STOP:   begin
                Serializer_Enable = 0;
                Mux_Selection = Logic_One;
                Busy = 1;
              end
      default:begin
                Serializer_Enable = 0;
                Mux_Selection = Logic_One;
                Busy = 0;
              end
    endcase
  end


endmodule