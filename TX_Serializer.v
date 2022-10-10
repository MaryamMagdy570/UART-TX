module TX_Serializer #(parameter Data_Width = 8)
(
  input wire                    CLK,
  input wire                    RST,
  input wire                    Enable_Pulse,
  input wire [Data_Width-1:0]   Parallel_Data,
  output wire                   Serial_Data,       
  output wire                   Done_flag       
);

reg [Data_Width-1:0]    Shift_Register;
reg [2:0]               Counter;
//reg                     Registered_Enable;
//wire                    Enable_Pulse;

/*
//Enable_Pulse Pulse Generator
always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        Registered_Enable <= 0;
      end
    else
      begin
        Registered_Enable <= Enable_Pulse;
      end
  end

assign Enable_Pulse = Enable_Pulse && !Registered_Enable;
*/


always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        Shift_Register <= 'b0;
      end
    else if (Enable_Pulse)      //    else if (Enable_Pulse)
      begin
        Shift_Register <= Parallel_Data;
      end
    else if (!Done_flag)
      begin
        Shift_Register[Data_Width-2:0] <= Shift_Register[Data_Width-1:1];
      end
  end


always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        Counter <= 0;
      end
    else if (Enable_Pulse)
      begin
        Counter <= 0;
      end
    else if (!Done_flag)
      begin
        Counter <= Counter + 1;
      end
  end



assign Serial_Data = Shift_Register[0];

assign Done_flag = (Counter == 3'd7);


/*
always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        Done_flag <= 0;
      end
    else if (Enable_Pulse)
      begin
        Done_flag <= 0;
      end
    else if (Counter == 3'd7)
      begin
        Done_flag <= 1;
      end
  end
*/

endmodule