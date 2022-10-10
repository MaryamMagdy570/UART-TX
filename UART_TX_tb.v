`timescale 1ns/1ps

module UART_TX_tb #(parameter TX_Data_Width_tb = 8) ();

  reg                        TX_RST_tb;
  reg                        TX_CLK_tb;
  reg [TX_Data_Width_tb-1:0] TX_Parallel_Data_tb;
  reg                        TX_Data_Valid_tb;
  reg                        TX_Parity_Enable_tb;
  reg                        TX_Parity_Type_tb;
  wire                       TX_OUT_tb;
  wire                       TX_Busy_tb;


localparam CLK_SIZE = 5;

initial 
begin
  Initial_Values ();

  RESET ();

  /////////////////////////////////////////////////////////////////
  //no parity

  Check_ONCE(1,0);  //check idle state

  Valid ();

  Check_ONCE(0,1);   //Check start bit

  #CLK_SIZE

  Check_Frame_Data_Part(8'b11100111);  //check data

  #CLK_SIZE

  Check_ONCE (1,1);  //check stop bit

  #CLK_SIZE

  Check_ONCE (1,0);  //back to idle state

  ///////////////////////////////////////////////////////////////////
  //odd parity

  TX_Parity_Enable_tb = 1;
  TX_Parity_Type_tb = 1;

  Check_ONCE(1,0);  //check idle state

  Valid ();

  Check_ONCE(0,1);  //Check start bit

  #CLK_SIZE

  Check_Frame_Data_Part(8'b11100111);  //check data

  #CLK_SIZE

  Check_ONCE (1,1);  //check parity bit

  #CLK_SIZE

  Check_ONCE (1,1);  //check stop bit

  #CLK_SIZE

  Check_ONCE (1,0);  //back to idle state

  ///////////////////////////////////////////////////////////////////
  //even parity

  TX_Parity_Enable_tb = 1;
  TX_Parity_Type_tb = 0;

  Check_ONCE(1,0);  //check idle state

  Valid ();

  Check_ONCE(0,1);  //Check start bit

  #CLK_SIZE

  Check_Frame_Data_Part(8'b11100111);  //check data

  #CLK_SIZE

  Check_ONCE (0,1);  //check parity bit

  #CLK_SIZE

  Check_ONCE (1,1);  //check stop bit

  #CLK_SIZE

  Check_ONCE (1,0);  //back to idle state

  ///////////////////////////////////////////////////////////////////
  //if valid come during frame transimition he should ignore 
  TX_Parity_Enable_tb = 0;
  TX_Parallel_Data_tb = 8'b0000000;

  Check_ONCE(1,0);  //check idle state

  Valid ();

  Check_ONCE(0,1);   //Check start bit

  #(CLK_SIZE*4)
  
  TX_Parallel_Data_tb = 8'b11111111;

  Valid ();

  Check_ONCE(0,1);

  #(CLK_SIZE*2)

  Check_ONCE(0,1);

  #(CLK_SIZE*2)

  Check_ONCE(1,1);  //check stop bit

  #CLK_SIZE

  Check_ONCE (1,0);  //back to idle state

   ///////////////////////////////////////////////////////////////////
   // 2 FRAMES with even parity

  TX_Parallel_Data_tb = 8'b11100111;
  TX_Parity_Enable_tb = 1;
  TX_Parity_Type_tb = 0;

  Check_ONCE(1,0);  //check idle state

  Valid ();

  Check_ONCE(0,1);  //Check start bit

  #CLK_SIZE

  Check_Frame_Data_Part(8'b11100111);  //check data

  #CLK_SIZE

  Check_ONCE (0,1);  //check parity bit

  #CLK_SIZE

  Check_ONCE (1,1);  //check stop bit

  #CLK_SIZE
  
  Check_ONCE(1,0);  //check idle state

  TX_Parallel_Data_tb = 8'b00111000;
  Valid ();

  Check_ONCE(0,1);   //Check start bit

  #CLK_SIZE

  Check_Frame_Data_Part(8'b00111000);  //check data

  #CLK_SIZE

  Check_ONCE (1,1);  //check parity bit

  #CLK_SIZE

  Check_ONCE (1,1);  //check stop bit

  #CLK_SIZE

  Check_ONCE (1,0);  //back to idle state

  $stop;

end




always #(CLK_SIZE/2.0) TX_CLK_tb = !TX_CLK_tb;



task Initial_Values ();
  begin
    TX_CLK_tb = 0;
    TX_Parallel_Data_tb = 8'b11100111;
    TX_Parity_Enable_tb = 0;
    TX_Parity_Type_tb = 0;
  end
endtask


task RESET ();
  begin
    TX_RST_tb = 1;
    #(CLK_SIZE/2.0)
    TX_RST_tb = 0;
    #(CLK_SIZE/2.0)
    TX_RST_tb = 1;
  end
endtask


task Valid ();
  begin
    TX_Data_Valid_tb = 1;
    #CLK_SIZE
    TX_Data_Valid_tb = 0;
  end
endtask


task Check_ONCE
(
  input tx_out,
  input busy_signal
);
  begin
    if(TX_OUT_tb == tx_out && TX_Busy_tb == busy_signal)
      begin
        $display ("pass");
      end
    else
      begin
        $display ("fail");
      end
  end
endtask


task Check_Frame_Data_Part
(
  input [TX_Data_Width_tb-1:0]  parallel_data
);
  begin
    if(TX_OUT_tb == parallel_data[0] && TX_Busy_tb == 1)
      begin   $display ("pass");  end
    else
      begin   $display ("fail");  end

    #CLK_SIZE
    
    if(TX_OUT_tb == parallel_data[1] && TX_Busy_tb == 1)
      begin   $display ("pass");  end
    else
      begin   $display ("fail");  end
    
    #CLK_SIZE
    
    if(TX_OUT_tb == parallel_data[2] && TX_Busy_tb == 1)
      begin   $display ("pass");  end
    else
      begin   $display ("fail");  end
    
    #CLK_SIZE
    
    if(TX_OUT_tb == parallel_data[3] && TX_Busy_tb == 1)
      begin   $display ("pass");  end
    else
      begin   $display ("fail");  end
    
    #CLK_SIZE
    
    if(TX_OUT_tb == parallel_data[4] && TX_Busy_tb == 1)
      begin   $display ("pass");  end
    else
      begin   $display ("fail");  end
    
    #CLK_SIZE
    
    if(TX_OUT_tb == parallel_data[5] && TX_Busy_tb == 1)
      begin   $display ("pass");  end
    else
      begin   $display ("fail");  end
    
    #CLK_SIZE 
    
    if(TX_OUT_tb == parallel_data[6] && TX_Busy_tb == 1)
      begin   $display ("pass");  end
    else
      begin   $display ("fail");  end
    
    #CLK_SIZE
    
    if(TX_OUT_tb == parallel_data[7] && TX_Busy_tb == 1)
      begin   $display ("pass");  end
    else
      begin   $display ("fail");  end

  end
endtask



UART_TX_TOP 
#(
  .TX_Data_Width (TX_Data_Width_tb )
)
DUT(
  .TX_RST           (TX_RST_tb           ),
  .TX_CLK           (TX_CLK_tb           ),
  .TX_Parallel_Data (TX_Parallel_Data_tb ),
  .TX_Data_Valid    (TX_Data_Valid_tb    ),
  .TX_Parity_Enable (TX_Parity_Enable_tb ),
  .TX_Parity_Type   (TX_Parity_Type_tb   ),
  .TX_OUT           (TX_OUT_tb           ),
  .TX_Busy          (TX_Busy_tb          )
);


endmodule