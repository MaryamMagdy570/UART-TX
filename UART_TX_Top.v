module UART_TX_TOP #(parameter TX_Data_Width = 8)
(
  input wire                      TX_RST,
  input wire                      TX_CLK,
  input wire [TX_Data_Width-1:0]  TX_Parallel_Data,
  input wire                      TX_Data_Valid,
  input wire                      TX_Parity_Enable,
  input wire                      TX_Parity_Type,
  output wire                     TX_OUT,
  output wire                     TX_Busy
);


//internal
wire          TX_Serializer_Enable;
wire          TX_Serializer_DoneFlag;
wire  [1:0]   TX_Mux_Selection;
wire          TX_Serial_Data;
wire          TX_Parity_Bit;



TX_Parity_Calculator 
#(
  .Data_Width (TX_Data_Width)
)
u_TX_Parity_Calculator
(
  .RST           (TX_RST),
  .CLK           (TX_CLK),
  .Parity_Enable (TX_Parity_Enable),
  .Data_Valid    (TX_Data_Valid),
  .Parity_Type   (TX_Parity_Type),
  .Parallel_Data (TX_Parallel_Data),
  .Parity_Bit    (TX_Parity_Bit)
);




TX_FSM  u_TX_FSM
(
  .RST                 (TX_RST),
  .CLK                 (TX_CLK),
  .Parity_Enable       (TX_Parity_Enable),
  .Data_Valid          (TX_Data_Valid),
  .Serializer_DoneFlag (TX_Serializer_DoneFlag),
  .Serializer_Enable   (TX_Serializer_Enable),
  .Mux_Selection       (TX_Mux_Selection),
  .Busy                (TX_Busy)
);




TX_Serializer 
#(
  .Data_Width (TX_Data_Width)
)
u_TX_Serializer
(
  .RST           (TX_RST),
  .CLK           (TX_CLK),
  .Enable_Pulse  (TX_Serializer_Enable),
  .Parallel_Data (TX_Parallel_Data),
  .Serial_Data   (TX_Serial_Data),
  .Done_flag     (TX_Serializer_DoneFlag)
);




TX_MUX  u_TX_MUX
(
  .MUX_Selection (TX_Mux_Selection),
  .Serial_Data   (TX_Serial_Data),
  .Parity_Bit    (TX_Parity_Bit),
  .TX_OUT        (TX_OUT)
);


endmodule