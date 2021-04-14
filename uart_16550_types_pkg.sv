package uart_16550_types_pkg;  

typedef struct packed {
	logic [23:0] reserved;
	logic [ 7:0] data; 		// TxD/RxD
} uart_data_t; // 4 bytes

typedef struct packed {
	logic [27:0] reserved;
	logic		 modemStatus;
	logic		 lineStatus;
	logic		 txDataEmpty ;
	logic		 rxDataAvailable;
} uart_interruptEnable_t; // 4 bytes

typedef struct packed {
	logic [23:0] reserved;
	logic [7:6]	 fifoEn;
    logic [5:4]	 reserved;
    logic [3:1]  interuptID2;
    logic		 interuptPending;	
} uart_interruptIdentification_t; // 4 bytes

typedef struct packed {
	logic [23:0] reserved;
	logic    	 divisorLatchAccessBit;
	logic    	 setBreak;
	logic        stickParity;
	logic		 evenParitySelect;
	logic		 parityEnable;
	logic		 numberOfStopBits;
	logic [1:0]  wordLengthSelect;
} uart_lineControl_t; // 4 bytes

typedef struct packed {
	logic [23:0] reserved;
	logic [7:5]  always000;
	logic		 loopBack;
	logic		 userOut2;
	logic		 userOut1;
	logic		 requestToSend; 
	logic		 dataTerminalReady; 
} uart_modemControl_t; // 4 bytes

typedef struct packed {
	logic [23:0] reserved;
	logic		 errorInRcvrFifo;
	logic		 transmitterEmpty;
	logic		 transmitterHoldingRegisterEmpty;
	logic		 breakInterupt;
	logic		 framingError;
	logic		 parityError;
	logic		 overRunError;
	logic		 dataReady;
} uart_lineStatus_t; // 4 bytes

typedef struct packed {
	logic [23:0] reserved;
	logic		 dataCarrierDetect;
	logic		 ringIndicator;
	logic		 dataSetReady;
	logic		 clearToSend;
	logic		 deltaDataCarrierDetect;
	logic		 trailingEdgeRingIndicator;
	logic		 deltaDataSetReady;
	logic		 dataClearToSend;
} uart_modemStatus_t; // 4 bytes

typedef struct packed {
	logic [23:0] reserved;
	logic [ 7:0] scratch; 
} uart_scratch_t; // 4 bytes

typedef struct packed {
	uart_scratch_t					scratch;
	uart_modemStatus_t				modemStatus;
	uart_lineStatus_t				lineStatus;
	uart_modemControl_t				modemControl;
	uart_lineControl_t				lineControl;
	uart_interruptIdentification_t	interruptIdentification;
	uart_interruptEnable_t			interruptEnable;
	uart_data_t			            data;
} uart_t;

parameter int baseAddress = 'h1000;   

parameter int offset_scratch					= 'h1C;
parameter int offset_modemStatus				= 'h18;
parameter int offset_lineStatus					= 'h14;
parameter int offset_modemControl				= 'h10;
parameter int offset_lineControl				= 'h0C;
parameter int offset_interruptIdentification	= 'h08; // RO when lineControl[7] == 1'b0
parameter int offset_interruptEnable			= 'h04; // RW when lineControl[7] == 1'b0
parameter int offset_data						= 'h00; // RW when lineControl[7] == 1'b0

endpackage :: uart_16550_types_pkg  

//	DLM_RW_DivisorLatchMsb_t			divisorLatchMsb;
//	DLL_RW_DivisorLatchLsb_t			divisorLatchLsb;
//	FCR_RW_FIFOControlStatus_t			fifoControlStatus;
//	
//parameter int offset_divisorLatchMsb			= 'h04; // RW when lineControl[7] == 1'b1
//parameter int offset_divisorLatchLsb			= 'h00; // RW when lineControl[7] == 1'b1 
//parameter int offset_fifoControlStatus			= 'h00; // WO control, RO status when lineControl[7] == 1'b1 

