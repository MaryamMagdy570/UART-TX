module TX_Parity_Calculator #(parameter Data_Width = 8)
(
  input wire                    RST,
  input wire                    CLK,
  input wire                    Parity_Enable,
  input wire                    Data_Valid,
  input wire                    Parity_Type,
  input wire [Data_Width-1:0]   Parallel_Data,
  output reg                    Parity_Bit
);


reg [Data_Width-1:0]   Registered_Data;


//registering data to prevent glitching power on xor gate "operand isolation"
always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        Registered_Data <= 'b0;
      end
    else if(Data_Valid && Parity_Enable)
      begin
        Registered_Data <= Parallel_Data;
      end
  end


always @ (*)
  begin
    if(Parity_Enable && Parity_Type)            //odd parity  type = 1
      begin
        Parity_Bit = ~^Registered_Data;
      end
    else if(Parity_Enable && !Parity_Type)     //even parity  type = 0
      begin
        Parity_Bit = ^Registered_Data;
      end   
    else                                        //enable = 0      
      begin
        Parity_Bit = 0;
      end
  end



endmodule