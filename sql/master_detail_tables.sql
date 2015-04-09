CREATE TABLE IF NOT EXISTS tblTradesDetail(
	EMS_Name varchar(10) NOT NULL,
	EMS_Order_ID varchar(50) NOT NULL,
	MsgType varchar(50) NULL,
	OrderStatus varchar(50) NULL,
	ExecTransType varchar(50) NULL,
	GuzClOrdID varchar(50) NULL,
	OrigGuzClOrdID varchar(50) NULL,
	EMSClOrdID varchar(50) NULL,
	OrigEmsClOrdID varchar(50) NULL,
	TradeDate varchar(10) NOT NULL,
	ListID varchar(50) NULL,
	Symbol varchar(10) NULL,
	IDsource varchar(50) NULL,
	SecurityID varchar(50) NULL,
	Side char(1) NULL,
	Shares bigint NULL,
	OrderType varchar(50) NULL,
	PxClientLmt varchar(50) NULL,
	Pxbenchmark varchar(50) NULL,
	Exchange varchar(10) NULL,
	TIF varchar(50) NULL,
	Destination varchar(50) NOT NULL,
	ExecutingBroker varchar(10) NULL,
	MPID varchar(50) NULL,
	AlgoStrategy varchar(50) NULL,
	AlgoParameters varchar(100) NULL,
	WaveID varchar(50) NULL,
	WaveShares bigint NULL,
	WaveOrderType varchar(50) NULL,
	WaveLmtPrx varchar(50) NULL,
	WaveTIF varchar(50) NULL,
	ExecID varchar(50) NOT NULL,
	ExecRefID varchar(50) NULL,
	LastSh bigint NULL,
	LastPx decimal(18, 4) NULL,
	datetime_OrderReceived datetime NULL,
	datetime_routed varchar(50) NULL,
	ExecutionTime datetime NULL,
	ID int IDENTITY(1,1) NOT NULL,
	ClientName varchar(100) NULL,
	ClientNetwork varchar(40) NULL);

CREATE TABLE IF NOT EXISTS tblTrades(
	TradeID bigint IDENTITY(1,1) NOT NULL,
	Source varchar(50) NOT NULL,
	TradeDate varchar(8) NOT NULL,
	Symbol varchar(10) NOT NULL,
	Side char(1) NOT NULL,
	SharesTraded bigint NOT NULL,
	SharesAllocated bigint NULL,
	Price decimal(18, 4) NOT NULL,
	OrderType varchar(50) NULL,
	DestID bigint NOT NULL,
	ExSystemID bigint NOT NULL,
	Exchange nvarchar(50) NOT NULL,
	ClearingBroker varchar(10) NULL,
	ExecutionTime datetime,
	PRIMARY KEY (TradeID));

CREATE TABLE IF NOT EXISTS tblBrokers(
	Destination varchar(10) NOT NULL,
	MPID varchar(8) NOT NULL,
	ML_Code varchar(2) NOT NULL,
	Name varchar(50) NULL,
	ITG_Code varchar(5) NOT NULL,
	PRIMARY KEY (ITG_Code ));