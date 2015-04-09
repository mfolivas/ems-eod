USE [master]
GO
/****** Object:  Database [intranet]    Script Date: 04/10/2014 12:55:08 ******/
CREATE DATABASE [intranet] ON  PRIMARY 
( NAME = N'intranet_Data', FILENAME = N'D:\SQL 2008 Server Instances\MSSQL10.MSSQLSERVER\MSSQL\DATA\intranet.mdf' , SIZE = 9241792KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'intranet_Log', FILENAME = N'D:\SQL 2008 Server Instances\MSSQL10.MSSQLSERVER\MSSQL\DATA\intranet_1.ldf' , SIZE = 321088KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
GO
ALTER DATABASE [intranet] SET COMPATIBILITY_LEVEL = 80
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [intranet].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [intranet] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [intranet] SET ANSI_NULLS OFF
GO
ALTER DATABASE [intranet] SET ANSI_PADDING OFF
GO
ALTER DATABASE [intranet] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [intranet] SET ARITHABORT OFF
GO
ALTER DATABASE [intranet] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [intranet] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [intranet] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [intranet] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [intranet] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [intranet] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [intranet] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [intranet] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [intranet] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [intranet] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [intranet] SET  DISABLE_BROKER
GO
ALTER DATABASE [intranet] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [intranet] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [intranet] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [intranet] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [intranet] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [intranet] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [intranet] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [intranet] SET  READ_WRITE
GO
ALTER DATABASE [intranet] SET RECOVERY SIMPLE
GO
ALTER DATABASE [intranet] SET  MULTI_USER
GO
ALTER DATABASE [intranet] SET PAGE_VERIFY TORN_PAGE_DETECTION
GO
ALTER DATABASE [intranet] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'intranet', N'ON'
GO
USE [intranet]
GO
/****** Object:  User [quant]    Script Date: 04/10/2014 12:55:08 ******/
CREATE USER [quant] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[quant]
GO
/****** Object:  User [NT AUTHORITY\SYSTEM]    Script Date: 04/10/2014 12:55:08 ******/
CREATE USER [NT AUTHORITY\SYSTEM] FOR LOGIN [NT AUTHORITY\SYSTEM] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [IUSR_SERVER07]    Script Date: 04/10/2014 12:55:08 ******/
CREATE USER [IUSR_SERVER07] WITH DEFAULT_SCHEMA=[IUSR_SERVER07]
GO
/****** Object:  User [dbuser]    Script Date: 04/10/2014 12:55:08 ******/
CREATE USER [dbuser] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbuser]
GO
/****** Object:  User [dbread]    Script Date: 04/10/2014 12:55:08 ******/
CREATE USER [dbread] FOR LOGIN [dbread] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [CORP\GTS10$]    Script Date: 04/10/2014 12:55:08 ******/
CREATE USER [CORP\GTS10$] FOR LOGIN [CORP\GTS10$] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [BEXEC]    Script Date: 04/10/2014 12:55:08 ******/
CREATE USER [BEXEC] FOR LOGIN [CORP\BEXEC] WITH DEFAULT_SCHEMA=[BEXEC]
GO
/****** Object:  Schema [quant]    Script Date: 04/10/2014 12:55:09 ******/
CREATE SCHEMA [quant] AUTHORIZATION [quant]
GO
/****** Object:  Schema [IUSR_SERVER07]    Script Date: 04/10/2014 12:55:09 ******/
CREATE SCHEMA [IUSR_SERVER07] AUTHORIZATION [IUSR_SERVER07]
GO
/****** Object:  Schema [dbuser]    Script Date: 04/10/2014 12:55:09 ******/
CREATE SCHEMA [dbuser] AUTHORIZATION [dbuser]
GO
/****** Object:  Schema [BEXEC]    Script Date: 04/10/2014 12:55:09 ******/
CREATE SCHEMA [BEXEC] AUTHORIZATION [BEXEC]
GO
/****** Object:  StoredProcedure [dbo].[usp_reindex]    Script Date: 04/10/2014 12:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[usp_reindex]
AS
	-- reindex tables
	DECLARE @TableName varchar(255)
	DECLARE TableCursor CURSOR FOR SELECT table_name FROM information_schema.tables WHERE table_type = 'base table'
	OPEN TableCursor
	FETCH NEXT FROM TableCursor INTO @TableName
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		PRINT 'Reindexing ' + @TableName
		DBCC DBREINDEX(@TableName,' ',90)
		FETCH NEXT FROM TableCursor INTO @TableName
	END
	CLOSE TableCursor
	DEALLOCATE TableCursor
	DUMP TRAN intranet with no_log
	DBCC SHRINKDATABASE (intranet, 0,Truncateonly )
GO
/****** Object:  StoredProcedure [dbo].[usp_doPurgeAndReindex]    Script Date: 04/10/2014 12:55:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
	-- Add the parameters for the stored procedure here
	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
END
GO
*/

--CREATE PROC dbo.usp_doPurgeAndReindex 
CREATE PROC [dbo].[usp_doPurgeAndReindex]
AS
DECLARE @TableName varchar(255)
DECLARE TableCursor CURSOR FOR SELECT table_name FROM information_schema.tables WHERE table_type = 'base table'
OPEN TableCursor
FETCH NEXT FROM TableCursor INTO @TableName WHILE @@FETCH_STATUS = 0 BEGIN
  --PRINT 'Reindexing ' + @TableName
  DBCC DBREINDEX(@TableName,' ',90)
  FETCH NEXT FROM TableCursor INTO @TableName END CLOSE TableCursor DEALLOCATE TableCursor DUMP TRAN intranet with no_log DBCC SHRINKDATABASE (intranet, 0,Truncateonly )
GO
/****** Object:  Table [dbo].[tblUSShortNames]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUSShortNames](
	[Name] [varchar](30) NOT NULL,
	[Description] [varchar](80) NULL,
	[ShortName] [varchar](4) NOT NULL,
UNIQUE NONCLUSTERED 
(
	[ShortName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE CLUSTERED INDEX [idxShortName_tblUSShortNames] ON [dbo].[tblUSShortNames] 
(
	[ShortName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUsers]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUsers](
	[UserID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NULL,
	[EmailAddress] [nvarchar](30) NULL,
	[Enabled] [bit] NOT NULL,
 CONSTRAINT [PK_tblUsers] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTradesGts]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTradesGts](
	[BasketID] [bigint] NOT NULL,
	[BasketName] [varchar](50) NOT NULL,
	[ClientName] [varchar](10) NOT NULL,
	[Side] [char](1) NOT NULL,
	[WaveID] [varchar](100) NULL,
	[TradeType] [char](1) NOT NULL,
	[GuzOrdID] [varchar](20) NULL,
	[Branch] [varchar](3) NULL,
	[SeqNum] [int] NULL,
	[TradeDate] [varchar](8) NOT NULL,
	[DestinationID] [varchar](20) NOT NULL,
	[Symbol] [varchar](10) NOT NULL,
	[OrderType] [char](1) NOT NULL,
	[OrderTime] [datetime] NOT NULL,
	[ExecID] [varchar](50) NOT NULL,
	[RemoteID] [varchar](50) NOT NULL,
	[Shares] [bigint] NOT NULL,
	[Price] [decimal](18, 10) NOT NULL,
	[ClearingBroker] [varchar](10) NULL,
	[ExecutionTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_tblTradesGts_TradeDate] ON [dbo].[tblTradesGts] 
(
	[TradeDate] DESC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblTradesGts_WaveID] ON [dbo].[tblTradesGts] 
(
	[WaveID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTradesDetail]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTradesDetail](
	[EMS_Name] [varchar](10) NOT NULL,
	[EMS_Order_ID] [varchar](50) NOT NULL,
	[MsgType] [varchar](50) NULL,
	[OrderStatus] [varchar](50) NULL,
	[ExecTransType] [varchar](50) NULL,
	[GuzClOrdID] [varchar](50) NULL,
	[OrigGuzClOrdID] [varchar](50) NULL,
	[EMSClOrdID] [varchar](50) NULL,
	[OrigEmsClOrdID] [varchar](50) NULL,
	[TradeDate] [varchar](10) NOT NULL,
	[ListID] [varchar](50) NULL,
	[Symbol] [varchar](10) NULL,
	[IDsource] [varchar](50) NULL,
	[SecurityID] [varchar](50) NULL,
	[Side] [char](1) NULL,
	[Shares] [bigint] NULL,
	[OrderType] [varchar](50) NULL,
	[PxClientLmt] [varchar](50) NULL,
	[Pxbenchmark] [varchar](50) NULL,
	[Exchange] [varchar](10) NULL,
	[TIF] [varchar](50) NULL,
	[Destination] [varchar](50) NOT NULL,
	[ExecutingBroker] [varchar](10) NULL,
	[MPID] [varchar](50) NULL,
	[AlgoStrategy] [varchar](50) NULL,
	[AlgoParameters] [varchar](100) NULL,
	[WaveID] [varchar](50) NULL,
	[WaveShares] [bigint] NULL,
	[WaveOrderType] [varchar](50) NULL,
	[WaveLmtPrx] [varchar](50) NULL,
	[WaveTIF] [varchar](50) NULL,
	[ExecID] [varchar](50) NOT NULL,
	[ExecRefID] [varchar](50) NULL,
	[LastSh] [bigint] NULL,
	[LastPx] [decimal](18, 4) NULL,
	[datetime_OrderReceived] [datetime] NULL,
	[datetime_routed] [varchar](50) NULL,
	[ExecutionTime] [datetime] NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClientName] [varchar](100) NULL,
	[ClientNetwork] [varchar](40) NULL,
 CONSTRAINT [PK_ID] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE CLUSTERED INDEX [IX_tblTradesDetailDate] ON [dbo].[tblTradesDetail] 
(
	[TradeDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblTradesDetailDestination] ON [dbo].[tblTradesDetail] 
(
	[Destination] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblTradesDetailEms] ON [dbo].[tblTradesDetail] 
(
	[EMS_Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTrades]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTrades](
	[TradeID] [bigint] IDENTITY(1,1) NOT NULL,
	[Source] [varchar](50) NOT NULL,
	[TradeDate] [varchar](8) NOT NULL,
	[Symbol] [varchar](10) NOT NULL,
	[Side] [char](1) NOT NULL,
	[SharesTraded] [bigint] NOT NULL,
	[SharesAllocated] [bigint] NULL,
	[Price] [decimal](18, 4) NOT NULL,
	[OrderType] [varchar](50) NULL,
	[DestID] [bigint] NOT NULL,
	[ExSystemID] [bigint] NOT NULL,
	[Exchange] [nvarchar](50) NOT NULL,
	[ClearingBroker] [varchar](10) NULL,
	[ExecutionTime] [datetime] NOT NULL,
 CONSTRAINT [PK_tblTrades] PRIMARY KEY CLUSTERED 
(
	[TradeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_tblTrades_TradeDateAndSource] ON [dbo].[tblTrades] 
(
	[TradeDate] DESC,
	[Source] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'either BasketID or desc from trader' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblTrades', @level2type=N'COLUMN',@level2name=N'Source'
GO
/****** Object:  Table [dbo].[tblSlkTickets]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSlkTickets](
	[SlkTicketID] [bigint] IDENTITY(1,1) NOT NULL,
	[SlkRefNum] [int] NOT NULL,
	[Source] [varchar](50) NOT NULL,
	[ClientId] [bigint] NULL,
	[ClientName] [varchar](20) NULL,
	[ClearingBrokerTradeAs] [nvarchar](4) NULL,
	[ClearingBrokerClearedAs] [varchar](10) NULL,
	[AcctID] [bigint] NOT NULL,
	[AcctNumClient] [varchar](50) NULL,
	[AcctNumGSEC] [varchar](8) NOT NULL,
	[AcctNumPenson] [varchar](10) NULL,
	[AcctNumClearingBroker] [varchar](10) NULL,
	[AlertCode] [varchar](20) NULL,
	[PriceExecuted] [decimal](18, 4) NULL,
	[PriceStrike] [decimal](18, 10) NOT NULL,
	[PriceToBook] [decimal](18, 4) NULL,
	[ExchangeCode] [varchar](4) NULL,
	[Symbol] [varchar](10) NOT NULL,
	[Side] [char](1) NOT NULL,
	[SharesAllocated] [bigint] NOT NULL,
	[TaxID] [varchar](20) NULL,
	[TradeDate] [varchar](8) NOT NULL,
	[TradeType] [char](1) NULL,
	[SharesOrdered] [bigint] NOT NULL,
	[CommissionRate] [decimal](18, 10) NOT NULL,
	[CommType] [varchar](2) NULL,
	[Commission] [decimal](18, 9) NULL,
	[CUSIP] [char](9) NULL,
	[Description] [varchar](50) NULL,
	[GrossMonies] [decimal](18, 10) NOT NULL,
	[NetMonies] [decimal](18, 10) NOT NULL,
	[SecFee] [decimal](18, 10) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[SettleDate] [datetime] NULL,
	[bOpen] [bit] NOT NULL,
	[Flag] [char](1) NOT NULL,
	[Currency] [varchar](5) NULL,
	[Tax] [decimal](18, 10) NULL,
	[Country] [varchar](5) NULL,
	[bEOD] [bit] NULL,
 CONSTRAINT [PK_tblSlkTickets] PRIMARY KEY CLUSTERED 
(
	[SlkTicketID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_tblSlkTickets_AcctNumSLK] ON [dbo].[tblSlkTickets] 
(
	[AcctNumGSEC] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblSlkTickets_PensonAcctNum] ON [dbo].[tblSlkTickets] 
(
	[AcctNumPenson] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblSlkTickets_TradeDate] ON [dbo].[tblSlkTickets] 
(
	[TradeDate] DESC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'imported in OASYS file' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSlkTickets', @level2type=N'COLUMN',@level2name=N'AcctNumGSEC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'imported in OASYS file' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSlkTickets', @level2type=N'COLUMN',@level2name=N'AlertCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'agency or principal' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSlkTickets', @level2type=N'COLUMN',@level2name=N'TradeType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'aka Principal' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSlkTickets', @level2type=N'COLUMN',@level2name=N'GrossMonies'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Blotter O/C for options' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSlkTickets', @level2type=N'COLUMN',@level2name=N'bOpen'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'D domestic, I international, B blotter' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSlkTickets', @level2type=N'COLUMN',@level2name=N'Flag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'flag for intraday partial EOD generated' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblSlkTickets', @level2type=N'COLUMN',@level2name=N'bEOD'
GO
/****** Object:  Table [dbo].[tblSecurityTypes]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSecurityTypes](
	[SecurityType] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_tblExTypes] PRIMARY KEY CLUSTERED 
(
	[SecurityType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblSecurityMaster]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSecurityMaster](
	[Symbol] [varchar](10) NOT NULL,
	[Name] [varchar](50) NULL,
	[CUSIP] [varchar](9) NULL,
	[ISIN] [varchar](15) NULL,
	[SEDOL] [varchar](15) NULL,
	[LastClose] [numeric](18, 4) NULL,
	[LastVolume] [bigint] NULL,
	[IntlFlag] [bit] NOT NULL,
	[Nasdaq] [bit] NULL,
	[Otcbb] [bit] NULL,
	[PrimaryExchange] [varchar](7) NULL,
	[IndustryGroup] [varchar](50) NULL,
	[IndustrySector] [varchar](50) NULL,
	[LastAction] [varchar](80) NULL,
	[DateAdd] [datetime] NOT NULL,
	[DateEdit] [datetime] NOT NULL,
	[Px_Open] [varchar](50) NULL,
 CONSTRAINT [pk_tblsecurityMaster] PRIMARY KEY CLUSTERED 
(
	[Symbol] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblReps]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReps](
	[RepID] [bigint] NOT NULL,
	[RepCode] [nvarchar](6) NULL,
	[RepName] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPortfolioTrades]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPortfolioTrades](
	[PortfolioTradeID] [bigint] IDENTITY(1,1) NOT NULL,
	[TradeDate] [varchar](8) NOT NULL,
	[Acct] [varchar](20) NOT NULL,
	[GroupName] [varchar](50) NOT NULL,
	[Source] [varchar](50) NOT NULL,
	[Symbol] [varchar](10) NOT NULL,
	[Side] [varchar](5) NOT NULL,
	[Shares] [int] NOT NULL,
	[Price] [float] NOT NULL,
	[Monies] [float] NULL,
	[CreatedOn] [datetime] NOT NULL,
	[EditedOn] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblPlanSponsors]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblPlanSponsors](
	[PlanSponsorID] [bigint] IDENTITY(1,1) NOT NULL,
	[PlanSponsorName] [varchar](50) NULL,
	[PlanSponsorDesc] [varchar](100) NULL,
	[SoftDollarRate] [real] NULL,
 CONSTRAINT [PK_tblSoftDollarSponsors] PRIMARY KEY CLUSTERED 
(
	[PlanSponsorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblOrderTypes]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOrderTypes](
	[OrderType] [nvarchar](10) NOT NULL,
	[OrderTypeGroup] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_tblOrderTypes] PRIMARY KEY CLUSTERED 
(
	[OrderType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblOrderRoles]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblOrderRoles](
	[OrderRole] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_tblOrderRoles] PRIMARY KEY CLUSTERED 
(
	[OrderRole] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblMarkets]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblMarkets](
	[MarketID] [bigint] IDENTITY(1,1) NOT NULL,
	[Market] [nvarchar](15) NULL,
	[MarketDesc] [nvarchar](50) NULL,
	[MarketExch] [nvarchar](50) NULL,
	[NewSourceID] [bigint] NULL,
	[NewTypeID] [bigint] NULL,
 CONSTRAINT [PK_tblMarkets] PRIMARY KEY CLUSTERED 
(
	[MarketID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblFirmAccts]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblFirmAccts](
	[AcctNumGSEC] [varchar](20) NOT NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_tblFirmAccts] PRIMARY KEY CLUSTERED 
(
	[AcctNumGSEC] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblExSystems]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblExSystems](
	[ExSystemID] [bigint] IDENTITY(1,1) NOT NULL,
	[ExSystemName] [nvarchar](20) NULL,
	[ExSystemDesc] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblExSystems] PRIMARY KEY CLUSTERED 
(
	[ExSystemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblExchanges]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblExchanges](
	[Exchange] [nvarchar](10) NOT NULL,
	[ExchangeDesc] [nvarchar](50) NULL,
	[BBExchID] [bigint] NULL,
 CONSTRAINT [PK_tblExchanges] PRIMARY KEY CLUSTERED 
(
	[Exchange] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblEntityTypes]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblEntityTypes](
	[EntityType] [varchar](32) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDomesticExchanges]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDomesticExchanges](
	[Name] [varchar](10) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblDestinations]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDestinations](
	[DestID] [bigint] IDENTITY(1,1) NOT NULL,
	[DestName] [nvarchar](50) NULL,
	[DestDesc] [nvarchar](50) NULL,
	[DestGroup] [nvarchar](20) NULL,
	[GtsDestID] [nvarchar](15) NULL,
	[Report11ACGroup] [nvarchar](15) NULL,
 CONSTRAINT [PK_tblExSources] PRIMARY KEY CLUSTERED 
(
	[DestID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCountries]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCountries](
	[CountryID] [bigint] IDENTITY(1,1) NOT NULL,
	[Country] [nvarchar](20) NOT NULL,
	[Currency] [nvarchar](20) NULL,
	[BloombergID] [bigint] NULL,
 CONSTRAINT [PK_tblCountries] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCommUpto2003]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCommUpto2003](
	[PlanSponsorID] [bigint] NOT NULL,
	[Commissions] [decimal](18, 10) NOT NULL,
	[PurchasePower] [decimal](18, 10) NOT NULL,
	[Payments] [decimal](18, 10) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblClearingBrokers]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblClearingBrokers](
	[ClearingBrokerID] [bigint] IDENTITY(1,1) NOT NULL,
	[ClearingBrokerName] [nvarchar](10) NOT NULL,
	[ClearingBrokerName_full] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblClearingBrokers] PRIMARY KEY CLUSTERED 
(
	[ClearingBrokerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblBrokers]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBrokers](
	[Destination] [varchar](10) NOT NULL,
	[MPID] [varchar](8) NOT NULL,
	[ML_Code] [varchar](2) NOT NULL,
	[Name] [varchar](50) NULL,
	[ITG_Code] [varchar](5) NOT NULL,
UNIQUE NONCLUSTERED 
(
	[ITG_Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE CLUSTERED INDEX [idxITG_code_tblBrokers] ON [dbo].[tblBrokers] 
(
	[ITG_Code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblBrokerDealers]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBrokerDealers](
	[BrokerDealerID] [bigint] IDENTITY(1,1) NOT NULL,
	[BrokerDeakerName] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblBrokerDealers] PRIMARY KEY CLUSTERED 
(
	[BrokerDealerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblBrokerDealer]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBrokerDealer](
	[BrokerDealer] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tblBrokerDealer] PRIMARY KEY CLUSTERED 
(
	[BrokerDealer] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblAvgPrice]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAvgPrice](
	[RecID] [bigint] IDENTITY(1,1) NOT NULL,
	[ticker] [varchar](10) NULL,
	[shares] [int] NULL,
	[price] [float] NULL,
	[entrytime] [datetime] NULL,
	[entrydt] [varchar](12) NULL,
 CONSTRAINT [PK_tblAvgPrice] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblClientsGTS]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblClientsGTS](
	[ClientIndex] [int] IDENTITY(1,1) NOT NULL,
	[ClientGts] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblClientsGTS] PRIMARY KEY CLUSTERED 
(
	[ClientGts] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_CC_VenueFixDump]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_CC_VenueFixDump](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TradeDate] [varchar](8) NOT NULL,
	[MsgSeqNum] [int] NULL,
	[BeginString] [varchar](10) NULL,
	[MsgType] [varchar](1) NOT NULL,
	[ClOrdID] [varchar](30) NOT NULL,
	[OrderID] [varchar](30) NULL,
	[OrigClOrdID] [varchar](30) NULL,
	[ExecID] [varchar](30) NULL,
	[ExecRefID] [varchar](30) NULL,
	[Symbol] [varchar](20) NULL,
	[SymbolSfx] [varchar](10) NULL,
	[Side] [varchar](1) NOT NULL,
	[OrderQty] [int] NULL,
	[OrdType] [varchar](1) NULL,
	[Price] [decimal](10, 6) NULL,
	[LastShares] [int] NULL,
	[LastPx] [decimal](10, 6) NULL,
	[AvgPx] [decimal](10, 6) NULL,
	[CumQty] [int] NULL,
	[LeavesQty] [int] NULL,
	[OrdStatus] [varchar](1) NULL,
	[ExecType] [varchar](1) NULL,
	[ExecTransType] [varchar](1) NULL,
	[SendingTime] [varchar](20) NULL,
	[TransactTime] [varchar](20) NULL,
	[TimeInForce] [int] NULL,
	[ExecInst] [varchar](1) NULL,
	[HandlInst] [int] NULL,
	[CxlType] [varchar](30) NULL,
	[Text] [varchar](200) NULL,
	[SenderCompID] [varchar](20) NOT NULL,
	[SenderSubID] [varchar](20) NULL,
	[OnBehalfOfCompID] [varchar](20) NULL,
	[OnBehalfOfSubID] [varchar](20) NULL,
	[SenderLocationID] [varchar](20) NULL,
	[TargetCompID] [varchar](20) NOT NULL,
	[TargetSubID] [varchar](20) NULL,
	[DeliverToCompID] [varchar](20) NULL,
	[DeliverToSubID] [varchar](20) NULL,
	[TargetLocationID] [varchar](20) NULL,
	[Account] [varchar](30) NULL,
	[ClientID] [varchar](30) NULL,
	[ExDestination] [varchar](2) NULL,
	[ExecBroker] [varchar](10) NULL,
	[Rule80A] [varchar](1) NULL,
	[SecurityExchange] [varchar](2) NULL,
	[PossDupFlag] [int] NULL,
	[PossResend] [int] NULL,
	[ListID] [varchar](30) NULL,
	[Subject] [varchar](30) NULL,
	[SecurityID] [varchar](15) NULL,
	[IDSource] [varchar](1) NULL,
	[Currency] [varchar](4) NULL,
	[ComplianceID] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_tradedate_tbl_CC_VenueFixDump] ON [dbo].[tbl_CC_VenueFixDump] 
(
	[TradeDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_CC_MapClientVenue]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_CC_MapClientVenue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BaseOrderID] [varchar](100) NULL,
	[ActiveClOrdID] [varchar](50) NULL,
	[SenderCompID] [varchar](50) NULL,
	[SenderSubID] [varchar](50) NULL,
	[SenderLocationID] [varchar](50) NULL,
	[OnBehalfOfCompID] [varchar](50) NULL,
	[OnBehalfOfSubID] [varchar](50) NULL,
	[TargetCompID] [varchar](50) NULL,
	[TargetSubID] [varchar](50) NULL,
	[TargetLocationID] [varchar](50) NULL,
	[DeliverToCompID] [varchar](50) NULL,
	[DeliverToSubID] [varchar](50) NULL,
	[ClientID] [varchar](50) NULL,
	[BeginString] [varchar](50) NULL,
	[MsgSeqNum] [varchar](50) NULL,
	[BasketName] [varchar](50) NULL,
	[ClientName] [varchar](50) NULL,
	[DropCopy] [varchar](50) NULL,
	[calculateCumQtyAndAvgPrice] [varchar](50) NULL,
	[TradeDate] [varchar](8) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idxDate_MapClientVenue] ON [dbo].[tbl_CC_MapClientVenue] 
(
	[TradeDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idxSenderCompID_MapClientVenue] ON [dbo].[tbl_CC_MapClientVenue] 
(
	[SenderCompID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_CC_ClientTag]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_CC_ClientTag](
	[SenderCompID] [varchar](50) NULL,
	[TargetCompID] [varchar](50) NULL,
	[BeginString] [varchar](50) NULL,
	[ClientTag] [varchar](50) NULL,
	[SessionID] [varchar](50) NULL,
	[SessionStatus] [varchar](10) NULL,
	[DropCopy] [varchar](10) NULL,
	[OutSenderCompID] [varchar](50) NULL,
	[OutTargetCompID] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_CC_ClientOrders]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_CC_ClientOrders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BaseOrderID] [varchar](100) NULL,
	[GuzOrdID] [varchar](50) NULL,
	[ClOrdID] [varchar](50) NULL,
	[OrigClOrdID] [varchar](50) NULL,
	[Symbol] [varchar](50) NULL,
	[SymbolSfx] [varchar](50) NULL,
	[Side] [varchar](50) NULL,
	[OrderQty] [int] NULL,
	[Price] [varchar](50) NULL,
	[OrdType] [varchar](50) NULL,
	[OrdStatus] [varchar](50) NULL,
	[ClientStatus] [varchar](50) NULL,
	[SendingTime] [varchar](50) NULL,
	[BasketName] [varchar](50) NULL,
	[MsgSeqNum] [varchar](50) NULL,
	[TradeDate] [varchar](8) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_doBackupAndPurge]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[sp_doBackupAndPurge]
AS
DECLARE @TableName varchar(255)
DECLARE TableCursor CURSOR FOR SELECT table_name FROM information_schema.tables WHERE table_type = 'base table'
OPEN TableCursor
FETCH NEXT FROM TableCursor INTO @TableName WHILE @@FETCH_STATUS = 0 BEGIN
  --PRINT 'Reindexing ' + @TableName
  DBCC DBREINDEX(@TableName,' ',90)
  FETCH NEXT FROM TableCursor INTO @TableName END CLOSE TableCursor DEALLOCATE TableCursor DUMP TRAN intranet with no_log DBCC SHRINKDATABASE (intranet, 0,Truncateonly )
/*
To execute this code from SQL command line do the following lines in this comment ....

USE [intranet]
GO

DECLARE	@return_value int
EXEC	@return_value = [dbo].[sp_doBackupAndPurge]
SELECT	'Return Value' = @return_value

GO
*/
GO
/****** Object:  Table [dbo].[SecurityMaster$]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecurityMaster$](
	[symbol] [nvarchar](255) NULL,
	[cusip] [nvarchar](255) NULL,
	[description] [nvarchar](255) NULL,
	[nasdaq] [nvarchar](255) NULL,
	[exch] [nvarchar](255) NULL,
	[industry] [nvarchar](255) NULL,
	[status] [nvarchar](255) NULL,
	[dateadd] [nvarchar](255) NULL,
	[dateedit] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAccessPerms]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAccessPerms](
	[UserID] [bigint] NOT NULL,
	[Area] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_tblAccessPerms] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[Area] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAccessLogs]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAccessLogs](
	[AccessLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccessType] [varchar](20) NOT NULL,
	[UserID] [bigint] NOT NULL,
	[TableName] [varchar](50) NOT NULL,
	[Memo] [varchar](100) NOT NULL,
	[DateAdd] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblClients]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblClients](
	[ClientID] [bigint] IDENTITY(1,1) NOT NULL,
	[BrokerDealer] [varchar](20) NOT NULL,
	[EntityType] [varchar](32) NULL,
	[SecFileNumber] [varchar](8) NULL,
	[EntityUpdatedBy] [varchar](6) NULL,
	[ClientName] [nvarchar](30) NOT NULL,
	[ClientName_full] [nvarchar](50) NULL,
	[Contact_title] [nvarchar](6) NULL,
	[Contact_fname] [nvarchar](20) NULL,
	[Contact_mname] [nvarchar](20) NULL,
	[Contact_lname] [nvarchar](30) NULL,
	[Contact_nickname] [nvarchar](20) NULL,
	[Contact_position] [nvarchar](30) NULL,
	[Address1] [nvarchar](50) NULL,
	[Address2] [nvarchar](50) NULL,
	[City] [nvarchar](30) NULL,
	[State] [nvarchar](20) NULL,
	[Zip] [nvarchar](10) NULL,
	[TaxID] [nvarchar](10) NULL,
	[memo] [nvarchar](255) NULL,
	[DateOpen] [datetime] NULL,
	[DateEdit] [datetime] NULL,
	[UserID] [bigint] NULL,
	[GuzmanContact] [varchar](50) NULL,
	[ClientAlertAcronym] [varchar](12) NULL,
	[ClearingBroker] [varchar](10) NULL,
	[active] [bit] NULL,
	[ltid] [varchar](10) NULL,
 CONSTRAINT [PK_tblClients] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblAllocations]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAllocations](
	[TradeID] [bigint] NOT NULL,
	[SlkTicketID] [bigint] NOT NULL,
	[Shares] [bigint] NOT NULL,
	[Price] [decimal](18, 10) NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblAllocations_SlkTicketID] ON [dbo].[tblAllocations] 
(
	[SlkTicketID] DESC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblAllocations_TradeID] ON [dbo].[tblAllocations] 
(
	[TradeID] DESC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_createTradesFromGtsDA]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_createTradesFromGtsDA]
    @BasketName   varchar(50)
AS 
      BEGIN TRAN ct
        INSERT INTO tblTrades 
            --SELECT BasketName AS Source, LEFT(@BasketID,8) AS TradeDate, symbol, side, SUM(shares) as SharesTraded, '0' AS SharesAllocated, SUM(Shares*Price)/SUM(Shares) AS Price, 'N/A' AS OrderType, '0' AS DestID, '2' AS ExSystemID, 'N/A' AS Exchange, GETDATE() AS ExecutionTime
            SELECT BasketName AS Source, (YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate())) AS TradeDate, symbol, side, SUM(shares) as SharesTraded, '0' AS SharesAllocated, SUM(Shares*Price)/SUM(Shares) AS Price, 'N/A' AS OrderType, '0' AS DestID, '2' AS ExSystemID, 'N/A' AS Exchange, GETDATE() AS ExecutionTime
            FROM tblTradesGts 
            WHERE BasketName=@BasketName 
            AND TRADEDATE=(YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate()))
            GROUP BY BasketName, Symbol, Side
    IF @@ERROR=0 COMMIT TRAN ct
    ELSE ROLLBACK TRAN ct
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_createTradesFromGts]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_createTradesFromGts]
    @BasketID   varchar(12),
    @TradeDate varchar(8)
AS 

    BEGIN TRAN ct
        INSERT INTO tblTrades
            --SELECT BasketName AS Source, LEFT(@BasketID,8) AS TradeDate, symbol, side, SUM(shares) as SharesTraded, '0' AS SharesAllocated, SUM(Shares*Price)/SUM(Shares) AS Price, 'N/A' AS OrderType, '0' AS DestID, '2' AS ExSystemID, 'N/A' AS Exchange, GETDATE() AS ExecutionTime
            SELECT BasketName AS Source, @TradeDate AS TradeDate, symbol, side, SUM(shares) as SharesTraded, '0' AS SharesAllocated, SUM(Shares*Price)/SUM(Shares) AS Price, 'N/A' AS OrderType, '0' AS DestID, '2' AS ExSystemID, 'N/A' AS Exchange, ClearingBroker, GETDATE() AS ExecutionTime
            FROM tblTradesGts 
            WHERE BasketID=@BasketID 
            AND TRADEDATE=@TradeDate
            AND Shares > 0
            GROUP BY BasketName, ClientName, Symbol, Side, ClearingBroker
    IF @@ERROR=0 COMMIT TRAN ct
    ELSE ROLLBACK TRAN ct
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_createTrade]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_createTrade]
  @Source varchar(50),
  @Symbol       varchar(10),
  @Side         char(1),
  @SharesTraded bigint,
  @Price        decimal(18,10),
  @OrderType    varchar(8),
  @DestID       bigint,
  @ExSystemID   bigint,
  @Exchange     nvarchar(50),
  @ClearingBroker     nvarchar(10)
AS 
  BEGIN TRAN tr
    INSERT INTO tblTrades(Source,Symbol,Side,SharesTraded,Price,OrderType,DestID,ExSystemID,Exchange,ClearingBroker, TradeDate) 
      VALUES(@Source,@Symbol,@Side,@SharesTraded,@Price,@OrderType,@DestID,@ExSystemID,@Exchange,@ClearingBroker,(YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate()))) 
  IF @@ERROR=0 COMMIT TRAN ct
  ELSE ROLLBACK TRAN ct
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_createSlkTicket_maunal]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_createSlkTicket_maunal]
  
  @slkRefNum        int, 
  @acctNumGSEC      varchar(20),
  @acctNumPenson    varchar(20),
  @acctNumClient    varchar(50),
  @alertCode        varchar(20),
  @acctID           bigint,
  @taxID            varchar(20),
  @clientName       varchar(20),
  @source           varchar(50),
      
  @symbol           varchar(10),
  @side             char(1),
  @tradeType        char(1),
  @sharesOrdered    bigint,  
  @sharesAllocated  bigint,
  @priceStrike      decimal(18,10), 
  @priceExecuted    decimal(18,10),    
  @commissionRate   decimal(18,10),
  @commType         varchar(2),   
  @commission       decimal(18,10), 
  
  @secFee           decimal(18,10),
  @grossMonies      decimal(18,10),
  @netMonies        decimal(18,10),
  @currency         varchar(5),
  @exchangeCode     varchar(4),   
  @country          varchar(5),
  @cusip            char(9),
  @tax              decimal(18,10),
  @description      varchar(50),
  
  @tradeDate        varchar(8),
  @settleDate       varchar(8),
  @bOpen            bit,
  @flag             varchar(1),
   
  @slkTicketID      bigint OUTPUT 
AS 
  --DECLARE @SlkTicketID bigint 
  DECLARE @myerror bit
  SET @myerror = 0    
  --SET @tradeDate = YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate())
  BEGIN
  BEGIN TRAN a     
  
  --create a new SlkTicket
  INSERT INTO tblSlkTickets(SlkRefNum,AcctNumGSEC,AcctNumPenson,AcctNumClient,AlertCode,AcctID,TaxID,ClientName,Source,
        Symbol,Side,TradeType,SharesOrdered,SharesAllocated,PriceStrike,PriceExecuted,PriceToBook,CommissionRate,CommType,Commission,
        SecFee,GrossMonies,NetMonies,Currency,ExchangeCode,Country,Cusip,Tax,Description,
        TradeDate,SettleDate,bOpen,Flag,CreatedOn) 
  VALUES(@slkRefNum,@acctNumGSEC,@acctNumPenson,@acctNumClient,@alertCode,@acctID,@taxID,@clientName,@source,
        @symbol,@side,@tradeType,@sharesOrdered,@sharesAllocated,@priceStrike,@priceExecuted,@priceExecuted,@commissionRate,@CommType,@commission,
        @secFee,@grossMonies,@netMonies,@currency,@exchangeCode,@country,@cusip,@tax,@description,
        @tradeDate,@settleDate,@bOpen,@flag,GETDATE())
  --SELECT @SlkTicketID = @@IDENTITY 
  SET @slkTicketID =  Scope_Identity()  
    IF @@ROWCOUNT  <> 1 SET @myerror = 1
    IF @@ERROR = 0 AND @myerror=0 COMMIT TRAN a
    ELSE ROLLBACK TRAN a
  
  END   
  RETURN 1
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_createSlkTicket_manual]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_createSlkTicket_manual]
  
  @slkRefNum        int, 
  @acctNumGSEC      varchar(20),
  @acctNumPenson    varchar(20),
  @acctNumClient    varchar(50),
  @alertCode        varchar(20),
  @acctID           bigint,
  @taxID            varchar(20),
  @clientName       varchar(20),
  @source           varchar(50),
      
  @symbol           varchar(10),
  @side             char(1),
  @tradeType        char(1),
  @sharesOrdered    bigint,  
  @sharesAllocated  bigint,
  @priceStrike      decimal(18,10), 
  @priceExecuted    decimal(18,10),    
  @commissionRate   decimal(18,10),
  @commType         varchar(2),   
  @commission       decimal(18,10), 
  
  @secFee           decimal(18,10),
  @grossMonies      decimal(18,10),
  @netMonies        decimal(18,10),
  @currency         varchar(5),
  @exchangeCode     varchar(4),   
  @country          varchar(5),
  @cusip            char(9),
  @tax              decimal(18,10),
  @description      varchar(50),
  
  @tradeDate        varchar(8),
  @settleDate       varchar(8),
  @bOpen            bit,
  @flag             varchar(1),
   
  @slkTicketID      bigint OUTPUT 
AS 
  --DECLARE @SlkTicketID bigint 
  DECLARE @myerror bit
  SET @myerror = 0    
  --SET @tradeDate = YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate())
  BEGIN
  BEGIN TRAN a     
  
  --create a new SlkTicket
  INSERT INTO tblSlkTickets(SlkRefNum,AcctNumGSEC,AcctNumPenson,AcctNumClient,AlertCode,AcctID,TaxID,ClientName,Source,
        Symbol,Side,TradeType,SharesOrdered,SharesAllocated,PriceStrike,PriceExecuted,PriceToBook,CommissionRate,CommType,Commission,
        SecFee,GrossMonies,NetMonies,Currency,ExchangeCode,Country,Cusip,Tax,Description,
        TradeDate,SettleDate,bOpen,Flag,CreatedOn) 
  VALUES(@slkRefNum,@acctNumGSEC,@acctNumPenson,@acctNumClient,@alertCode,@acctID,@taxID,@clientName,@source,
        @symbol,@side,@tradeType,@sharesOrdered,@sharesAllocated,@priceStrike,@priceExecuted,@priceExecuted,@commissionRate,@CommType,@commission,
        @secFee,@grossMonies,@netMonies,@currency,@exchangeCode,@country,@cusip,@tax,@description,
        @tradeDate,@settleDate,@bOpen,@flag,GETDATE())
  --SELECT @SlkTicketID = @@IDENTITY 
  SET @slkTicketID =  Scope_Identity()  
    IF @@ROWCOUNT  <> 1 SET @myerror = 1
    IF @@ERROR = 0 AND @myerror=0 COMMIT TRAN a
    ELSE ROLLBACK TRAN a
  
  END   
  RETURN 1
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_createSlkTicket_Client]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_createSlkTicket_Client]
  
  @slkRefNum        int, 
  @acctNumGSEC       varchar(20),
  @acctNumPenson    varchar(20),
  @acctNumClient    varchar(50),
  @alertCode        varchar(20),
  @acctID           bigint,
  @taxID            varchar(20),
  @clientName       varchar(20),
  @source           varchar(50),
      
  @symbol           varchar(10),
  @side             char(1),
  @tradeType        char(1),
  @sharesOrdered    bigint,  
  @sharesAllocated  bigint,
  @priceStrike      decimal(18,10), 
  @priceExecuted    decimal(18,10),    
  @commissionRate   decimal(18,10),
  @commType     varchar(2),   
  @commission       decimal(18,10), 
  
  @secFee           decimal(18,10),
  @grossMonies      decimal(18,10),
  @netMonies        decimal(18,10),
  @currency         varchar(5),
  @exchangeCode     varchar(4),   
  @country          varchar(5),
  @cusip            char(9),
  @tax              decimal(18,10),
  @description      varchar(50),
  
  @tradeDate        varchar(8),
  @settleDate       varchar(8),
  @bOpen            bit,
  @flag             varchar(1),
   
  @slkTicketID      bigint OUTPUT 
AS 
  --DECLARE @SlkTicketID bigint 
  DECLARE @myerror bit
  SET @myerror = 0    
  --SET @tradeDate = YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate())
  BEGIN
  BEGIN TRAN a     
  
  --create a new SlkTicket
  INSERT INTO tblSlkTickets(SlkRefNum,AcctNumGSEC,AcctNumPenson,AcctNumClient,AlertCode,AcctID,TaxID,ClientName,Source,
        Symbol,Side,TradeType,SharesOrdered,SharesAllocated,PriceStrike,PriceExecuted,PriceToBook,CommissionRate,CommType,Commission,
        SecFee,GrossMonies,NetMonies,Currency,ExchangeCode,Country,Cusip,Tax,Description,
        TradeDate,SettleDate,bOpen,Flag,CreatedOn) 
  VALUES(@slkRefNum,@acctNumGSEC,@acctNumPenson,@acctNumClient,@alertCode,@acctID,@taxID,@clientName,@source,
        @symbol,@side,@tradeType,@sharesOrdered,@sharesAllocated,@priceStrike,@priceExecuted,@priceExecuted,@commissionRate,@CommType,@commission,
        @secFee,@grossMonies,@netMonies,@currency,@exchangeCode,@country,@cusip,@tax,@description,
        @tradeDate,@settleDate,@bOpen,@flag,GETDATE())
  --SELECT @SlkTicketID = @@IDENTITY 
  SET @slkTicketID =  Scope_Identity()  
    IF @@ROWCOUNT  <> 1 SET @myerror = 1
    IF @@ERROR = 0 AND @myerror=0 COMMIT TRAN a
    ELSE ROLLBACK TRAN a
  
  END   
  RETURN 1
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_createSlkTicket]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_createSlkTicket]
  
  @slkRefNum        int,    
  @source           varchar(50),
  @clientName       varchar(20),
  @clearingBroker   varchar(20),
  @acctNumGSEC      varchar(20),
  @acctNumPenson    varchar(20),
  @acctNumClient    varchar(50),
  @alertCode        varchar(20),
  @acctID           bigint,
  @taxID            varchar(20),
  
  @symbol           varchar(10),
  @side             char(1),
  @tradeType        char(1),
  @sharesOrdered    bigint,  
  @sharesAllocated  bigint,
  @priceStrike      decimal(18,10), 
  @priceExecuted    decimal(18,10),    
  @commType         varchar(2), 
  @commissionRate   decimal(18,10),
  @commission       decimal(18,10),  
  
  @tradeDate        varchar(8),
  @cusip            char(9),
  @description      varchar(50),
  @exchangeCode     varchar(4),   
  @grossMonies      decimal(18,10),
  @secFee           decimal(18,10),
  @netMonies        decimal(18,10),
    
  @slkTicketID      bigint OUTPUT 
AS 
  --DECLARE @myerror bit
  --SET @myerror = 0    
  --SET @tradeDate = YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate())
  BEGIN
  --BEGIN TRAN a     
  --create a new SlkTicket
  INSERT INTO tblSlkTickets(SlkRefNum,Source,ClientName,ClearingBroker,acctNumGSEC,AcctNumPenson,AcctNumClient,AlertCode,AcctID,TaxID,
        Symbol,Side,TradeType,SharesOrdered,SharesAllocated,PriceStrike,PriceExecuted,PriceToBook,CommType,CommissionRate,Commission,
        TradeDate,Cusip,Description,ExchangeCode,GrossMonies,SecFee,NetMonies,CreatedOn) 
  VALUES (@slkRefNum,@source,@clientName,@clearingBroker,@acctNumGSEC,@acctNumPenson,@acctNumClient,@alertCode,@acctID,@taxID,
        @symbol,@side,@tradeType,@sharesOrdered,@sharesAllocated,@priceStrike,@priceExecuted,@priceExecuted,@CommType,@commissionRate,@commission,
        @tradeDate,@cusip,@description,@exchangeCode,@grossMonies,@secFee,@netMonies,GETDATE())
  SELECT @SlkTicketID = @@IDENTITY 
  --SET @slkTicketID =  Scope_Identity()  
  --  IF @@ROWCOUNT  <> 1 SET @myerror = 1
  --  IF @@ERROR = 0 AND @myerror=0 COMMIT TRAN a
  --  ELSE ROLLBACK TRAN a
  
  END   
  RETURN 1
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_insertGtsTrades_NEW]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_insertGtsTrades_NEW]
  
  @basketID         bigint,
  @basketName       varchar(50),
  @clientID       	varchar(10),
  @side             char(1),
  @waveName			varchar(50),
  @tradeType        char(1),
  @guzOrdID			varchar(20),
  @tradeDate		varchar(8),
  @destID			varchar(8),
  @symbol			varchar(10),
  @orderType		char(1),
  @orderTime		datetime,
  @execID			varchar(50),
  @remoteID			varchar(50),
  @shares			bigint,
  @price			decimal(18,10),
  @execTime			datetime
AS 
  DECLARE @myerror bit
  SET @myerror = 0    
  BEGIN
  BEGIN TRAN a     
  
  --insert into tblTradesGts
  INSERT INTO tblTradesGts(basketID,basketName,clientID,side,waveName,tradeType,guzOrdID,tradeDate,
        destinationID,symbol,orderType,orderTime,execID,remoteID,shares,price,executionTime) 
  VALUES (@basketID,@basketName,@clientID,@side,@waveName,@tradeType,@guzOrdID,@tradeDate,
        @destID,@symbol,@orderType,@orderTime,@execID,@remoteID,@shares,@price,@execTime)
	IF @@ROWCOUNT  <> 1 SET @myerror = 1
	IF @@ERROR = 0 AND @myerror=0 COMMIT TRAN a
	ELSE ROLLBACK TRAN a
  END   
  RETURN 1
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_insertGtsTrades]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_insertGtsTrades]
  
  @basketID         bigint,
  @basketName       varchar(50),
  @clientName         varchar(10),
  @side             char(1),
  @waveID     varchar(50),
  @waveName     varchar(50),
  @tradeType        char(1),
  @branch     varchar(3),
  @seqNum     int,
  @tradeDate    varchar(8),
  @destID     varchar(20),
  @symbol     varchar(10),
  @orderType    char(1),
  @orderTime    datetime,
  @execID     varchar(50),
  @remoteID     varchar(50),
  @shares     bigint,
  @price      decimal(18,10),
  @execTime     datetime,
  @clearingBroker varchar(25),
  @guzOrdId varchar(25)
AS 
  DECLARE @myerror bit
  SET @myerror = 0    
  BEGIN
  BEGIN TRAN a     
  
  --insert into tblTradesGts
  --INSERT INTO tblTradesGts(basketID,basketName,clientID,side,waveID,tradeType,branch,seqNum,tradeDate,
  INSERT INTO tblTradesGts(basketID,basketName,clientName,side,waveID,tradeType,guzOrdId,branch,seqNum,tradeDate,
        destinationID,symbol,orderType,orderTime,execID,remoteID,shares,price,executionTime,clearingBroker) 
  VALUES (@basketID,@basketName,@clientName,@side,@waveID,@tradeType,@guzOrdId,@branch,@seqNum,@tradeDate,
        @destID,@symbol,@orderType,@orderTime,@execID,@remoteID,@shares,@price,@execTime,@clearingBroker)
  IF @@ROWCOUNT  <> 1 SET @myerror = 1
  IF @@ERROR = 0 AND @myerror=0 COMMIT TRAN a
  ELSE ROLLBACK TRAN a
  END   
  RETURN 1
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_insertDATrades]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_insertDATrades]
  
  @basketID         bigint,
  @basketName       varchar(50),
  @clientID       	varchar(10),
  @side             char(1),
  @waveID			varchar(50),
  @waveName			varchar(50),
  @tradeType        char(1),
  @branch			varchar(3),
  @seqNum			int,
  @tradeDate		varchar(8),
  @destID			varchar(8),
  @symbol			varchar(10),
  @orderType		char(1),
  @orderTime		datetime,
  @execID			varchar(50),
  @remoteID			varchar(50),
  @shares			bigint,
  @price			decimal(18,10),
  @execTime			datetime
AS 
  DECLARE @myerror bit
  SET @myerror = 0    
  BEGIN
  BEGIN TRAN a     
  
  --insert into tblTradesGts
  INSERT INTO tblTradesGts(basketID,basketName,clientID,side,waveID,waveName,tradeType,branch,seqNum,tradeDate,
        destinationID,symbol,orderType,orderTime,execID,remoteID,shares,price,executionTime) 
  VALUES (@basketID,@basketName,@clientID,@side,@waveID,@waveName,@tradeType,@branch,@seqNum,@tradeDate,
        @destID,@symbol,@orderType,@orderTime,@execID,@remoteID,@shares,@price,@execTime)
	IF @@ROWCOUNT  <> 1 SET @myerror = 1
	IF @@ERROR = 0 AND @myerror=0 COMMIT TRAN a
	ELSE ROLLBACK TRAN a
  END   
  RETURN 1
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_updateCommission]    Script Date: 04/10/2014 12:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_updateCommission]
  AS

  UPDATE tblSlkTickets SET Commission =  CommissionRate 
    WHERE YEAR(CreatedOn)=YEAR(getDate()) AND MONTH(CreatedOn)=MONTH(getDate()) AND DAY(CreatedOn)=DAY(getDate())
    AND CommType='FF'
  UPDATE tblSlkTickets SET Commission =  SharesAllocated*CommissionRate 
    WHERE YEAR(CreatedOn)=YEAR(getDate()) AND MONTH(CreatedOn)=MONTH(getDate()) AND DAY(CreatedOn)=DAY(getDate())
    AND CommType='DS'
  UPDATE tblSlkTickets SET Commission =  SharesAllocated*PriceToBook*CommissionRate*0.0001
    WHERE YEAR(CreatedOn)=YEAR(getDate()) AND MONTH(CreatedOn)=MONTH(getDate()) AND DAY(CreatedOn)=DAY(getDate())
    AND CommType='BP'
  UPDATE tblSlkTickets SET Commission = ROUND(ROUND(Commission,4),2) 
    WHERE YEAR(CreatedOn)=YEAR(getDate()) AND MONTH(CreatedOn)=MONTH(getDate()) AND DAY(CreatedOn)=DAY(getDate())
  RETURN 1
GO
/****** Object:  View [dbuser].[V_ALLOCSLKTICKET]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbuser].[V_ALLOCSLKTICKET] AS SELECT SUM(Shares) Shares, SlkTicketID FROM tblALLOCATIONS GROUP BY SlkTicketID
GO
/****** Object:  View [dbo].[Customers]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Customers] AS select sum(shares) SHARES, TRADEID from tblALLOCATIONS GROUP BY TRADEID
GO
/****** Object:  View [dbuser].[V_TRADEALLOC]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbuser].[V_TRADEALLOC] AS SELECT SUM(Shares) SHARES, TRADEID from tblALLOCATIONS GROUP BY TRADEID
GO
/****** Object:  StoredProcedure [dbo].[usp_AddAccessLogEvent]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_AddAccessLogEvent]
	@userID		bigint,
	@tblName	varchar(20),
	@accessType	varchar(20),
	@query		varchar(50)
AS 
	--creates a new Allocation and updates tblTrades & tblSlkTickets
	DECLARE @myerror				bit
	SET @myerror=0
	BEGIN
	BEGIN TRAN ca
		INSERT INTO tblAccessLogs ( UserID, TableName, AccessType, Memo, DateAdd )
         		VALUES ( @UserID, @tblName, @accessType, @query, getDate() )
		IF @@ROWCOUNT <> 1	SET @myerror=1
	IF @@ERROR=0 AND @myerror=0 COMMIT TRAN ca
	ELSE ROLLBACK TRAN ca
	END
GO
/****** Object:  Table [dbo].[tblSoftDollarPayments]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSoftDollarPayments](
	[SoftDollarPaymentID] [bigint] IDENTITY(1,1) NOT NULL,
	[PlanSponsorID] [bigint] NOT NULL,
	[ClientID] [bigint] NULL,
	[Payee] [varchar](20) NULL,
	[PayAmount] [float] NULL,
	[PayDate] [datetime] NULL,
	[CheckNum] [varchar](20) NULL,
	[CheckDate] [datetime] NULL,
	[DateAdd] [datetime] NULL,
	[DateEdit] [datetime] NULL,
 CONSTRAINT [PK_tblSoftDollarPayments] PRIMARY KEY CLUSTERED 
(
	[SoftDollarPaymentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_createAllocation]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_createAllocation]
  @TradeID      bigint,
  @SlkTicketID  bigint,
  @Shares       bigint,
  @Price        decimal(18,10),
  @ClearingBroker varchar(20)
  
AS 
  --creates a new Allocation and updates tblTrades & tblSlkTickets
  DECLARE @myerror        bit
  DECLARE @SharesTraded   bigint
  DECLARE @SharesAllocated  bigint
  DECLARE @TradeDate varchar(8)
  --DECLARE @Price        decimal(18,10)
  SET @TradeDate = (YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate()))
  SET @myerror=0
  
  IF @Price <=0
    SELECT @SharesTraded=SharesTraded, @SharesAllocated=SharesAllocated, @Price=Price FROM tblTrades WHERE TradeID=@TradeID AND TRADEDATE=@TradeDate
  ELSE
    SELECT @SharesTraded=SharesTraded, @SharesAllocated=SharesAllocated FROM tblTrades WHERE TradeID=@TradeID AND TRADEDATE=@TradeDate
  IF @Shares <= @SharesTraded-@SharesAllocated AND @Shares > 0
  BEGIN
    BEGIN TRAN ca
      UPDATE tblTrades SET SharesAllocated=SharesAllocated+@Shares WHERE TradeID=@TradeID AND TRADEDATE=@TradeDate
      IF @@ROWCOUNT <> 1  SET @myerror=1
      INSERT INTO tblAllocations ( TradeID, SlkTicketID, Shares, Price ) VALUES ( @TradeID, @SlkTicketID, @Shares, @Price )
      IF @@ROWCOUNT <> 1  SET @myerror=1
      UPDATE tblSlkTickets SET SharesAllocated=SharesAllocated+@Shares, 
        PriceExecuted=((PriceExecuted*SharesAllocated)+(@Price*@Shares))/(SharesAllocated+@Shares),
        PriceToBook=((PriceExecuted*SharesAllocated)+(@Price*@Shares))/(SharesAllocated+@Shares)
       WHERE SlkTicketID=@SlkTicketID AND TRADEDATE=@TradeDate AND ClearingBroker=@ClearingBroker
      IF @@ROWCOUNT <> 1  SET @myerror=1
    IF @@ERROR=0 AND @myerror=0 COMMIT TRAN ca
    ELSE ROLLBACK TRAN ca
END
  --RETURN 1
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_BlockAllocTradeSource]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_BlockAllocTradeSource]
  @trdSource        varchar(50),    --1
  @acctID           bigint,         --2
  @taxID            varchar(20),    --3
  @clientName       varchar(20),    --4
  @acctNumClient    varchar(50),    --5
  @acctNumGSEC      varchar(20),    --6
  @alertCode        varchar(20),    --7
  @commissionRate   decimal(18,10), --8
  @commType         varchar(2),     --9
  @slkSource        varchar(50)    --10
  --@slkTicketID      bigint OUTPUT   --11
AS 
  DECLARE @slkTicketID      bigint
  DECLARE @myerror bit,@tradeID bigint,@symbol varchar(10),@side char(1),@tradeType char(1),
  @shToAlloc  bigint,@stkPx decimal(18,10),@averagePrice decimal(18,10), @tradeDate varchar(8)
  SET @myerror = 0    
  SET @tradeDate = YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate())
  BEGIN TRAN a     
    DECLARE slk_cursor CURSOR FOR     
    SELECT  tradeID,symbol,side,price,(sharesTraded - sharesAllocated) as shToAlloc FROM tblTrades T 
    WHERE YEAR(ExecutionTime)=YEAR(GETDATE()) AND MONTH(ExecutionTime)=MONTH(GETDATE()) AND DAY(ExecutionTime)=DAY(GETDATE()) 
    AND T.source =@trdSource AND (sharesTraded - sharesAllocated) > 0
    OPEN slk_cursor FETCH NEXT FROM slk_cursor INTO @tradeID, @symbol, @side, @stkPx, @shToAlloc
  WHILE @@FETCH_STATUS = 0
    BEGIN
      
      EXEC usp_trg_createSlkTicket 0,@slkSource,@clientName,'GSEC',@acctNumGSEC,'',@acctNumClient,@alertCode,@acctID,@taxID,
        @symbol,@side,@tradeType, @shToAlloc, @shToAlloc,@stkPx,@stkPx,@CommType,@commissionRate,0,
        @tradeDate,'0000000','','',0,0,0,@slkTicketID OUTPUT
        
      -- EXEC usp_trg_createSlkTicket 0,@slkSource,@acctID,@taxID,@clientName,@acctNumClient,@acctNumGSEC,@alertCode,
      --  @symbol,@side,@tradeType, @shToAlloc, @shToAlloc,@stkPx,@stkPx,@commissionRate,0,
      --  ' ','0000000',' ',@tradeDate,0,0,0,@CommType,@slkTicketID OUTPUT
      
      --EXEC usp_trg_createSlkTicket 0,@slkSource,0,@taxID,@clientName,@acctNumClient,@acctNumGSEC,@alertCode,
      --@exchangeCode,@cusip,@description,@tradeDate,@grossMonies,@netMonies,@secFee,@CommType, @slkTicketID OUTPUT
        
        INSERT INTO tblAllocations VALUES (@tradeID, @slkTicketID, @ShToAlloc, @StkPx)
      
        UPDATE tblTrades SET SharesAllocated = SharesAllocated + @ShToAlloc WHERE tradeID=@tradeID
      
        FETCH NEXT FROM slk_cursor INTO @tradeID, @symbol, @side, @stkPx, @shToAlloc
    END
    CLOSE slk_cursor
    DEALLOCATE slk_cursor
    IF @@ERROR = 0 
    COMMIT TRAN a
    ELSE 
    ROLLBACK TRAN a
 RETURN 1
GO
/****** Object:  Table [dbo].[tblTickets]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTickets](
	[TicketID] [bigint] IDENTITY(1,1) NOT NULL,
	[ClientID] [bigint] NOT NULL,
	[AcctID] [bigint] NOT NULL,
	[AcctType] [varchar](10) NULL,
	[BasketFlag] [bit] NULL,
	[Branch] [varchar](3) NULL,
	[ClearingBrokerID] [bigint] NULL,
	[Country] [nvarchar](20) NULL,
	[DateTrade] [datetime] NULL,
	[FirstWaveTime] [varchar](5) NULL,
	[Memo] [nvarchar](255) NULL,
	[OrderRole] [nvarchar](20) NULL,
	[OrderType] [nvarchar](10) NULL,
	[SecurityType] [nvarchar](20) NULL,
	[Side] [nvarchar](1) NULL,
	[CrossFlag] [bit] NULL,
	[PlanSponsorID] [bigint] NULL,
	[ProgramStrategy] [varchar](2) NOT NULL,
	[SoftDollarRate] [real] NULL,
	[Symbol] [nvarchar](20) NULL,
	[DateAdd] [datetime] NULL,
	[DateEdit] [datetime] NULL,
	[UserID] [bigint] NULL,
	[TaxID] [varchar](10) NULL,
	[PTRCode] [varchar](10) NULL,
	[ELFlag] [varchar](1) NULL,
	[PgmTradeFlag] [bit] NULL,
	[BrkTransFlag] [bit] NULL,
	[BreakFlag] [bit] NULL,
 CONSTRAINT [PK_tblTickets] PRIMARY KEY CLUSTERED 
(
	[TicketID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_deleteTradeSource]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_deleteTradeSource]
    @TradeSource    varchar(50)
    --@bDeleteSlkTicket bit
AS 
    DECLARE @TradeDate  varchar(8)
    SET @TradeDate=YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate())
    --SET @TradeDate=(right(datepart(year,getdate()),4) + right((datepart(month,getdate()) + 100),2) + right((datepart(day,getdate()) + 100),2))
    -- reset the affected SlkTrade record, since one of its AllocMaps will be deleted, will recalculate later  
    --UPDATE tblSlkTickets
    --    SET SharesAllocated=0, AveragePrice=0, GrossMonies=0,NetMonies=0,SecFee=0 
    --    WHERE SlkTicketID IN 
    --        (SELECT SlkTicketID FROM tblAllocations WHERE TradeID IN 
    --            (SELECT TradeID FROM tblTrades WHERE Source=@TradeSource AND TradeDate=@TradeDate) )
    --DELETE FROM tblAllocations WHERE SlkTicketID IN 
    --   (SELECT SlkTicketID FROM tblTrades WHERE Source=@TradeSource AND TradeDate=@TradeDate)  
    DELETE FROM tblAllocations WHERE TradeID IN 
       (SELECT TradeID FROM tblTrades WHERE Source=@TradeSource AND TradeDate=@TradeDate)  
    DELETE FROM tblTrades WHERE Source=@TradeSource AND TradeDate=@TradeDate
    DELETE FROM tblTradesGts WHERE BasketName=@TradeSource AND TradeDate=@TradeDate
    -- recalculate fields in tblSlkTickets:
    --UPDATE tblSlkTickets
    --    SET AveragePrice=alloc.ap, SharesAllocated=alloc.sh
    --   FROM (SELECT SlkTicketID, SUM(shares) as sh, SUM(shares*price)/SUM(shares) as ap FROM tblAllocations GROUP BY SlkTicketID) AS alloc
    --    WHERE tblSlkTickets.SlkTicketID=alloc.SlkTicketID
    --IF(@bDeleteSlkTicket=1) BEGIN
    --  DELETE FROM tblSlkTickets WHERE SOURCE = @TradeSource AND YEAR(CreatedOn)= YEAR(GetDate()) AND MONTH(CreatedOn)= MONTH(GETdATE()) AND DAY(CREATEDON) = DAY(GETDATE())
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_deleteTradesAndTicketsByTradeSource]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_deleteTradesAndTicketsByTradeSource]
    @TradeSource    varchar(50)
    --@bDeleteSlkTicket bit
AS 
    DECLARE @TradeDate  varchar(8)
    SET @TradeDate=YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate())
    
    --added: to set tickets from allocated into unallocated
    DELETE b 
    FROM tblAllocations a join tblSlkTickets b on a.SlkTicketID = b.SlkTicketID
    WHERE a.TradeID IN 
       (SELECT TradeID FROM tblTrades WHERE Source=@TradeSource AND TradeDate=@TradeDate );
       
    DELETE FROM tblAllocations WHERE TradeID IN 
       (SELECT TradeID FROM tblTrades WHERE Source=@TradeSource AND TradeDate=@TradeDate)  
    DELETE FROM tblTrades WHERE Source=@TradeSource AND TradeDate=@TradeDate
    DELETE FROM tblTradesGts WHERE BasketName=@TradeSource AND TradeDate=@TradeDate
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_deleteTrade]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_deleteTrade] @TradeID bigint
AS
  DECLARE @Source varchar(50)
  DECLARE @Symbol varchar(10)
  DECLARE @Side   char(1)
  DECLARE @TradeDate varchar(8)				
  BEGIN
  BEGIN TRAN dt 
    DELETE FROM tblAllocations WHERE TradeID = @TradeID
    SELECT @Source=Source, @Symbol=Symbol, @Side=Side, @TradeDate=TradeDate FROM tblTrades WHERE TradeID =@TradeID
    DELETE FROM tblTradesGts WHERE BasketName=@Source AND Symbol=@Symbol AND Side=@Side AND TradeDate=@TradeDate
    DELETE FROM tblTrades WHERE TradeID = @TradeID
    IF @@ERROR=0 COMMIT TRAN dt
    ELSE ROLLBACK TRAN dt	 
 END
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_deleteSlkTicketSource]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_deleteSlkTicketSource]
    @SlkTicketSource    varchar(50)
AS 
    --DECLARE @TradeDate  varchar(8)
    --SET @TradeDate=(right(datepart(year,getdate()),4) + right((datepart(month,getdate()) + 100),2) + right((datepart(day,getdate()) + 100),2))
    --SET @tradeDate = YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate())
    DELETE FROM tblAllocations WHERE SlkTicketID IN 
       --(SELECT SlkTicketID FROM tblSlkTickets WHERE Source=@SlkTicketSource AND TradeDate = CONVERT(CHAR(8),GETDATE(),112))
       (SELECT SlkTicketID FROM tblSlkTickets WHERE Source=@SlkTicketSource AND CONVERT(CHAR(8),CreatedOn,112) = CONVERT(CHAR(8),GETDATE(),112))
       --(SELECT SlkTicketID FROM tblSlkTickets WHERE Source=@SlkTicketSource AND CreatedOn > Convert(varchar(10), GETdATE(), 101))  
       --(SELECT SlkTicketID FROM tblSlkTickets WHERE Source=@SlkTicketSource AND TRADEDATE=YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate()))
    --DELETE FROM tblSlkTickets WHERE Source=@SlkTicketSource AND TradeDate = CONVERT(CHAR(8),GETDATE(),112)
    DELETE FROM tblSlkTickets WHERE Source=@SlkTicketSource AND CONVERT(CHAR(8),CreatedOn,112) = CONVERT(CHAR(8),GETDATE(),112)
	--DELETE FROM tblSlkTickets WHERE Source=@SlkTicketSource AND TRADEDATE=YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate())
    --DELETE FROM tblSlkTickets WHERE Source=@SlkTicketSource AND CreatedOn > Convert(varchar(10), GETdATE(), 101)
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_deleteSlkTicketsArray]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[usp_trg_deleteSlkTicketsArray](@Array varchar(8000)) 
AS
set nocount on
-- @Array is the array we wish to parse
-- @Separator is the separator charactor such as a comma
DECLARE @separator char
declare @separator_position int -- This is used to locate each separator character
declare @SlkTicketID varchar(50) -- this holds each array value as it is returned

-- For my loop to work I need an extra separator at the end.  I always look to the
-- left of the separator character for each array value
set @separator = ','
set @array = @array + @separator

-- Loop through the string searching for separtor characters
while patindex('%' + @separator + '%' , @array) <> 0 
begin

  -- patindex matches the a pattern against a string
  set @separator_position =  patindex('%' + @separator + '%' , @array)
  set @SlkTicketID = RTRIM(LTRIM(left(@array, @separator_position - 1)))
  -- @array_value holds the value of this element of the array
  --select @SlkTicketID = RTRIM(LTRIM(@array_value))
  --PRINT @array_value
  BEGIN
  BEGIN TRAN dt  	
  	DELETE FROM tblAllocations WHERE SlkTicketID = @SlkTicketID
  	DELETE FROM tblSlkTickets  WHERE SlkTicketID = @SlkTicketID
  	IF @@ERROR=0 COMMIT TRAN dt
    ELSE ROLLBACK TRAN dt	 
  END	
  -- This replaces what we just processed with and empty string
  set @array = stuff(@array, 1, @separator_position, '')
end


set nocount off
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_deleteSlkTickets]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_deleteSlkTickets] @SlkTicketID bigint
AS
  BEGIN
  BEGIN TRAN dt  	
  	SET NOCOUNT ON
  	DELETE FROM tblAllocations WHERE SlkTicketID = @SlkTicketID
  	DELETE FROM tblSlkTickets  WHERE SlkTicketID = @SlkTicketID
  	IF @@ERROR=0 COMMIT TRAN dt
    ELSE ROLLBACK TRAN dt	 
  	SET NOCOUNT OFF
  END
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_deleteAllocation]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_deleteAllocation]
	@TradeID        bigint,
    @SlkTicketID	bigint
AS
	BEGIN
		BEGIN TRAN da
			IF @slkTicketID = 0 
				BEGIN
				DELETE FROM tblAllocations WHERE TradeID = @TradeID
				END
			ELSE IF @tradeID = 0
				BEGIN
				DELETE FROM tblAllocations WHERE SlkTicketID = @SlkTicketID;
				UPDATE tblSlkTickets set ClearingBrokerTradeAs = null WHERE SlkTicketID = @SlkTicketID;
				END
			END 
        IF @@ERROR=0 COMMIT TRAN da
		ELSE ROLLBACK TRAN da
		--END 
	--END
GO
/****** Object:  Table [dbo].[tblaccounts_old]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblaccounts_old](
	[AcctID] [bigint] IDENTITY(1,1) NOT NULL,
	[AcctName] [varchar](80) NOT NULL,
	[ClientID] [bigint] NULL,
	[AcctNumGSEC] [varchar](20) NULL,
	[AcctNumPenson] [varchar](20) NULL,
	[AcctNumML] [varchar](10) NULL,
	[AcctNumInternal] [varchar](20) NULL,
	[AcctNumClientFund] [varchar](20) NULL,
	[AcctNumClientAcct] [varchar](20) NULL,
	[AcctType] [varchar](20) NULL,
	[AgentID] [varchar](20) NULL,
	[Alert] [varchar](20) NULL,
	[PsetBic] [varchar](12) NULL,
	[Pset] [varchar](12) NULL,
	[DTCID] [varchar](20) NULL,
	[InstID] [varchar](20) NULL,
	[IntPartyID1] [varchar](20) NULL,
	[IntPartyAcctNum1] [varchar](20) NULL,
	[IntPartyID2] [varchar](20) NULL,
	[IntPartyAcctNum2] [varchar](20) NULL,
	[Memo] [varchar](1000) NULL,
	[PBName] [varchar](30) NULL,
	[PBFlag] [bit] NULL,
	[PBDocsF150Flag] [bit] NULL,
	[PBDocsF151Flag] [bit] NULL,
	[PBDocsF1toAFlag] [bit] NULL,
	[SoftFlag] [bit] NULL,
	[SpecialFlag] [bit] NULL,
	[Status] [smallint] NULL,
	[TaxID] [varchar](20) NULL,
	[LastModifiedBy] [varchar](10) NULL,
	[EditDate] [smalldatetime] NULL,
	[OpenDate] [smalldatetime] NULL,
	[UserID] [bigint] NULL,
	[rep] [varchar](4) NULL,
 CONSTRAINT [PK_tblAccounts] PRIMARY KEY CLUSTERED 
(
	[AcctID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_tblAccounts_AcctNumSLK] ON [dbo].[tblaccounts_old] 
(
	[AcctNumGSEC] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblAccounts_ClientID_AcctName] ON [dbo].[tblaccounts_old] 
(
	[ClientID] ASC,
	[AcctName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblaccounts_old', @level2type=N'COLUMN',@level2name=N'AcctID'
GO
/****** Object:  Table [dbo].[tblaccounts]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblaccounts](
	[AcctID] [bigint] IDENTITY(1,1) NOT NULL,
	[AcctName] [varchar](80) NOT NULL,
	[ClientID] [bigint] NULL,
	[AccountNumberClBroker] [varchar](20) NULL,
	[ClearBroker] [varchar](10) NULL,
	[AcctNumInternal] [varchar](20) NULL,
	[AcctNumClientFund] [varchar](20) NULL,
	[AcctNumClientAcct] [varchar](20) NULL,
	[AcctType] [varchar](20) NULL,
	[AgentID] [varchar](20) NULL,
	[Alert] [varchar](20) NULL,
	[PsetBic] [varchar](12) NULL,
	[Pset] [varchar](12) NULL,
	[DTCID] [varchar](20) NULL,
	[InstID] [varchar](20) NULL,
	[IntPartyID1] [varchar](20) NULL,
	[IntPartyAcctNum1] [varchar](20) NULL,
	[IntPartyID2] [varchar](20) NULL,
	[IntPartyAcctNum2] [varchar](20) NULL,
	[Memo] [varchar](1000) NULL,
	[PBName] [varchar](30) NULL,
	[PBFlag] [bit] NULL,
	[PBDocsF150Flag] [bit] NULL,
	[PBDocsF151Flag] [bit] NULL,
	[PBDocsF1toAFlag] [bit] NULL,
	[SoftFlag] [bit] NULL,
	[SpecialFlag] [bit] NULL,
	[Status] [smallint] NULL,
	[TaxID] [varchar](20) NULL,
	[LastModifiedBy] [varchar](10) NULL,
	[EditDate] [smalldatetime] NULL,
	[OpenDate] [smalldatetime] NULL,
	[UserID] [bigint] NULL,
	[rep] [varchar](4) NULL,
 CONSTRAINT [PK_accounts] PRIMARY KEY CLUSTERED 
(
	[AcctID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idx_accounts_acct_brk] ON [dbo].[tblaccounts] 
(
	[ClearBroker] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_accounts_acct_inter] ON [dbo].[tblaccounts] 
(
	[AcctNumInternal] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_accounts_acct_name] ON [dbo].[tblaccounts] 
(
	[AcctName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_accounts_acct_number] ON [dbo].[tblaccounts] 
(
	[AccountNumberClBroker] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblClientContacts]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblClientContacts](
	[ClientContactID] [bigint] IDENTITY(1,1) NOT NULL,
	[ClientID] [bigint] NOT NULL,
	[ContactName] [varchar](50) NOT NULL,
	[PhoneNumber] [varchar](20) NULL,
	[Description] [varchar](50) NULL,
	[DateAdd] [datetime] NOT NULL,
	[DateEdit] [datetime] NOT NULL,
	[ContactType] [varchar](20) NULL,
 CONSTRAINT [PK_tblClientAttributes] PRIMARY KEY CLUSTERED 
(
	[ClientContactID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[GetClientName]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[GetClientName]
  @parClientID int
AS SELECT ClientName FROM tblClients WHERE ClientID = @parClientID
GO
/****** Object:  Table [dbo].[tblCommissions]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCommissions](
	[CommID] [bigint] IDENTITY(1,1) NOT NULL,
	[TicketID] [bigint] NOT NULL,
	[DestID] [bigint] NOT NULL,
	[ExSystemID] [bigint] NOT NULL,
	[Exchange] [nvarchar](10) NOT NULL,
	[CrossFlag] [bit] NULL,
	[CommRate] [float] NULL,
	[CommType] [varchar](2) NULL,
	[Commission] [decimal](18, 4) NULL,
	[Price] [float] NULL,
	[Shares] [int] NULL,
	[DateAdd] [datetime] NULL,
	[DateEdit] [datetime] NULL,
	[DollarValue] [decimal](18, 4) NULL,
	[Branch] [varchar](4) NULL,
	[Symbols] [int] NULL,
 CONSTRAINT [PK_tblCommissions] PRIMARY KEY CLUSTERED 
(
	[CommID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblCommissions', @level2type=N'COLUMN',@level2name=N'CommType'
GO
/****** Object:  StoredProcedure [dbo].[GetAcctIDFromSLKAcctNum]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- by leoguzman
-- 2001.07.06
CREATE PROC [dbo].[GetAcctIDFromSLKAcctNum]
  @parAcctNumSLK NVARCHAR(20) OUTPUT
AS
DECLARE @answer NVARCHAR(20)
DECLARE @tmpAcctID BIGINT
DECLARE @tmpAcctNumSLK NVARCHAR(20)
SET @answer = '0'		-- the default answer if no match is found
DECLARE curname CURSOR
READ_ONLY
FOR SELECT AcctID, AcctNumSLK FROM intranet.dbo.tblAccounts
OPEN curname
FETCH NEXT FROM curname INTO @tmpAcctID, @tmpAcctNumSLK
WHILE (@@fetch_status <> -1) AND (@answer = 0)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
		if @parAcctNumSLK = @tmpAcctNumSLK set @answer = @tmpAcctID
	END
	FETCH NEXT FROM curname INTO @tmpAcctID, @tmpAcctNumSLK
END
CLOSE curname
DEALLOCATE curname
print  @answer
RETURN @answer
GO
/****** Object:  StoredProcedure [dbo].[GetAcctID]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAcctID]
	@parAcctNum NVARCHAR(20) OUTPUT
AS
DECLARE @tmpAcctID BIGINT
DECLARE @tmpAcctNum NVARCHAR(20)
DECLARE MyCursor CURSOR READ_ONLY FOR
	SELECT AcctID
	FROM intranet.dbo.tblAccounts
	WHERE (AcctNumSLK = @parAcctNum)
		OR (AcctNumPershing = @parAcctNum)
		OR (AcctNumFidelity = @parAcctNum)
OPEN MyCursor
FETCH NEXT FROM MyCursor INTO @tmpAcctID
IF (@tmpAcctID is null)
BEGIN
	set @tmpAcctID = 0
END
CLOSE MyCursor
DEALLOCATE MyCursor
RETURN @tmpAcctID
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_createAllocSlkTicket]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_trg_createAllocSlkTicket]
  
  @SlkRefNum      int,    
  @Source         varchar(50),
  @clientName     varchar(20),
  @clearingBroker varchar(20),
  @acctNumGSEC    varchar(20),
  @acctNumPenson  varchar(20),
  @acctNumClient  varchar(50),
  @alertCode      varchar(20),
  @acctID         bigint,
  @taxID          varchar(20),
  
  @symbol         varchar(10),
  @side           char(1),
  @tradeType      char(1),
  @SharesOrdered  bigint,  
  @SharesAllocated  bigint,
  @priceStrike    decimal(18,10),
  @priceExecuted  decimal(18,10),
  @commType       varchar(2),
  @commissionRate decimal(18,10),
  @commission     decimal(18,10), 

  @Cusip          char(9),
  @Description    varchar(50),  
  @TradeID        bigint
  
AS 
  DECLARE @SlkTicketID bigint 
  DECLARE @exchangeCode char(4)
  DECLARE @myerror bit
  DECLARE @tradeDate varchar(8)
  SET @myerror = 0
  SET @exchangeCode = ' '
  SET @TradeDate = (YEAR(GetDate())*10000+MONTH(GetDate())*100+DAY(GetDate()))
  BEGIN
  BEGIN TRAN a
    EXEC usp_trg_createSlkTicket @SlkRefNum,@Source,@ClientName,@clearingBroker,@acctNumGSEC,@AcctNumPenson,@AcctNumClient,@AlertCode,@AcctID,@TaxID,
            @Symbol,@Side,@TradeType,@SharesOrdered,0,@priceStrike,0,@commType,@CommissionRate,@Commission,
            @TradeDate,@Cusip,@Description,@exchangeCode,0,0,0,@SlkTicketID OUTPUT
    EXEC usp_trg_createAllocation @TradeID,@SlkTicketID,@SharesAllocated,@priceExecuted,@ClearingBroker
  IF @@ERROR=0 COMMIT TRAN a
  ELSE ROLLBACK TRAN a
  END
  RETURN 1
GO
/****** Object:  StoredProcedure [dbo].[usp_trg_linkAccounts]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_trg_linkAccounts]
  @clientID bigint, 
  @source varchar(50)
  AS
  --DECLARE @acctID bigint
  DECLARE @slkTicketID bigint
  DECLARE @clearingBroker varchar(20)
  DECLARE @acctNumGSEC varchar(20)
  DECLARE @acctNumPenson varchar(20)
  DECLARE @acctNumMerril varchar(20)
  DECLARE @alertCode varchar(20)
  DECLARE @clientName varchar(20)
  DECLARE @acctNumClient varchar(50)
  DECLARE @todayDate varchar(8) = convert(varchar, getdate(), 112)
  --DECLARE @counter bigint
  --DECLARE @j bigint
  --set @j = 0
  SELECT @clientName=ClientName, @clearingBroker=ClearingBroker FROM tblClients WHERE ClientID = @clientID
  IF @clearingBroker='GSEC'
  BEGIN
    DECLARE MyCursor CURSOR FOR
      SELECT AcctNumClearingBroker,AlertCode,AcctNumClient,SlkTicketID FROM tblSlkTickets 
      WHERE Source=@source AND (AcctNumClearingBroker IS NULL OR LEN(AcctNumClearingBroker) < 7 )
        AND tradeDate = @todayDate
      OPEN MyCursor
      FETCH NEXT FROM MyCursor INTO @acctNumGSEC,@alertCode, @acctNumClient, @slkTicketID
      WHILE (@@FETCH_STATUS = 0)
      BEGIN    
        SELECT @acctNumGSEC=acctNumGSEC FROM tblAccounts WHERE STATUS=1 AND CLIENTID=@clientID 
        AND (LEFT(AcctName,LEN(@acctNumClient)+1)=@acctNumClient+' ' OR LEFT(AcctName,LEN(@acctNumClient)+1)=@acctNumClient+'-') 
        IF((@acctNumGSEC IS NULL OR LEN(@acctNumGSEC) < 7 ) AND ((@alertCode IS NOT NULL) AND LEN(@alertCode)> 0 ))
        BEGIN 
          SELECT @acctNumGSEC=AcctNumGSEC FROM tblAccounts WHERE Alert = @alertCode AND ClientID =@clientID AND STATUS = 1 
        END
        IF(LEN(@acctNumGSEC) > 6)    
        BEGIN 
          UPDATE tblSlkTickets SET AcctNumClearingBroker=@AcctNumGSEC, ClearingBrokerClearedAs=@clearingBroker WHERE slkTicketID = @slkTicketID
          UPDATE tblSlkTickets SET ClientName=@clientName, ClientId=@clientID WHERE SlkTicketID = @slkTicketID AND ClientName IS NULL
        END
      FETCH NEXT FROM MyCursor INTO @acctNumGSEC, @alertCode, @acctNumClient, @slkTicketID
    END
    CLOSE MyCursor
    DEALLOCATE MyCursor
  END  
  ELSE IF @clearingBroker='PEN'
  BEGIN
    DECLARE MyCursor CURSOR FOR
      SELECT AcctNumClearingBroker,AlertCode,AcctNumClient,SlkTicketID FROM tblSlkTickets 
      WHERE Source=@source AND (AcctNumClearingBroker IS NULL OR LEN(AcctNumClearingBroker) < 7 )
      AND tradeDate = @todayDate
      OPEN MyCursor
      FETCH NEXT FROM MyCursor INTO @acctNumPenson,@alertCode, @acctNumClient, @slkTicketID
      WHILE (@@FETCH_STATUS = 0)
      BEGIN    
        SELECT @acctNumPenson=acctNumPenson FROM tblAccounts WHERE STATUS=1 AND CLIENTID=@clientID 
        AND (LEFT(AcctName,LEN(@acctNumClient)+1)=@acctNumClient+' ' OR LEFT(AcctName,LEN(@acctNumClient)+1)=@acctNumClient+'-') 
        IF((@acctNumPenson IS NULL OR LEN(@acctNumPenson) < 7 ) AND ((@alertCode IS NOT NULL) AND LEN(@alertCode)> 0 ))
        BEGIN 
          SELECT @acctNumPenson=AcctNumPenson FROM tblAccounts WHERE Alert = @alertCode AND ClientID =@clientID AND STATUS = 1 
        END
        IF(LEN(@acctNumPenson) > 6)    
        BEGIN 
          UPDATE tblSlkTickets SET AcctNumClearingBroker=@AcctNumPenson, ClearingBrokerClearedAs=@clearingBroker WHERE slkTicketID = @slkTicketID
          UPDATE tblSlkTickets SET ClientName=@clientName, ClientId=@clientId WHERE SlkTicketID = @slkTicketID AND ClientName IS NULL
        END
      FETCH NEXT FROM MyCursor INTO @acctNumPenson, @alertCode, @acctNumClient, @slkTicketID
    END  
    CLOSE MyCursor
    DEALLOCATE MyCursor
  END
  ELSE IF @clearingBroker='ML'
  BEGIN
    DECLARE MyCursor CURSOR FOR
      SELECT AcctNumClearingBroker,AlertCode,AcctNumClient,SlkTicketID FROM tblSlkTickets 
      WHERE Source=@source AND (AcctNumClearingBroker IS NULL OR LEN(AcctNumClearingBroker) < 7 )
      AND tradeDate = @todayDate
      OPEN MyCursor
      FETCH NEXT FROM MyCursor INTO @acctNumPenson,@alertCode, @acctNumClient, @slkTicketID
      WHILE (@@FETCH_STATUS = 0)
      BEGIN    
        SELECT @acctNumMerril=AcctNumML FROM tblAccounts WHERE STATUS=1 AND CLIENTID=@clientID 
        AND (LEFT(AcctName,LEN(@acctNumClient)+1)=@acctNumClient+' ' OR LEFT(AcctName,LEN(@acctNumClient)+1)=@acctNumClient+'-') 
        IF((@acctNumMerril IS NULL OR LEN(@acctNumMerril) < 7 ) AND ((@alertCode IS NOT NULL) AND LEN(@alertCode)> 0 ))
        BEGIN 
          SELECT @acctNumMerril=AcctNumML FROM tblAccounts WHERE Alert = @alertCode AND ClientID =@clientID AND STATUS = 1 
        END
        IF(LEN(@acctNumMerril) > 0)    
        BEGIN 
          UPDATE tblSlkTickets SET AcctNumClearingBroker=@acctNumMerril, ClearingBrokerClearedAs=@clearingBroker WHERE slkTicketID = @slkTicketID
          UPDATE tblSlkTickets SET ClientName=@clientName, ClientId=@clientID WHERE SlkTicketID = @slkTicketID AND ClientName IS NULL
        END
      FETCH NEXT FROM MyCursor INTO @acctNumPenson, @alertCode, @acctNumClient, @slkTicketID
    END  
    CLOSE MyCursor
    DEALLOCATE MyCursor
  END
GO
/****** Object:  View [dbo].[v_getComms]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[v_getComms]
AS
SELECT co.CommID, co.TicketID, co.DestID, co.ExSystemID, co.Exchange, co.CommRate, co.Commission,
	co.Price, co.Shares, co.DateAdd AS CommDateAdd, 
	co.DateEdit AS CommDateEdit, 
	de.DestName, de.DestDesc, de.DestGroup, 
	esy.ExSystemName, esy.ExSystemDesc, 
	t.ClientID, t.AcctID, t.BasketFlag, t.ClearingBrokerID, t.Country, t.DateTrade, 
	t.Memo AS TicketMemo, t.OrderRole, t.OrderType, t.Side, t.PlanSponsorID, t.SoftDollarRate, 
	t.Symbol, t.DateAdd AS TicketDateAdd, t.DateEdit AS TicketDateEdit, 
	cb.ClearingBrokerName, cb.ClearingBrokerName_full, 
	t.SecurityType, ps.PlanSponsorName, ps.PlanSponsorDesc, 
  	a.AcctName, a.AcctNumSLK, a.AcctNumPershing, a.AcctNumFidelity, a.AcctNumInternal, 
	a.AgentID, a.Alert, a.DTCID, a.InstID, a.IntPartyID1, a.IntPartyAcctNum1, a.IntPartyID2, 
	a.IntPartyAcctNum2, a.memo AS AccountMemo, a.PBName, a.PBFlag, a.PBDocsF150Flag, 
	a.PBDocsF151Flag, a.PBDocsF1toAFlag, a.ptrID, a.rep, a.SoftFlag, a.SpecialFlag, 
	a.Status, a.TaxID AS AccountTaxID, a.EditDate, a.OpenDate, 
	c.ClientName, c.ClientName_full, c.Contact_title, c.Contact_fname, c.Contact_mname, 
	c.Contact_lname, c.Contact_nickname, c.Contact_position, c.Address1, c.Address2, 
	c.City, c.State, c.Zip, c.TaxID AS ClientTaxID, c.memo AS ClientMemo, 
	c.DateOpen AS ClientDateOpen, c.DateEdit AS ClientDateEdit
FROM dbo.tblCommissions co INNER JOIN
  dbo.tblDestinations de ON co.DestID = de.DestID INNER JOIN
  dbo.tblExSystems esy ON co.ExSystemID = esy.ExSystemID INNER JOIN
  dbo.tblTickets t ON co.TicketID = t.TicketID INNER JOIN
  dbo.tblClearingBrokers cb ON t.ClearingBrokerID = cb.ClearingBrokerID INNER JOIN
  dbo.tblPlanSponsors ps ON t.PlanSponsorID = ps.PlanSponsorID INNER JOIN
  dbo.tblClients c ON t.ClientID = c.ClientID INNER JOIN
  dbo.tblAccounts a ON t.AcctID = a.AcctID
GO
/****** Object:  View [dbo].[GetComms_full_OLD]    Script Date: 04/10/2014 12:55:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[GetComms_full_OLD]
AS
SELECT     co.CommID, co.TicketID, co.DestID, co.ExSystemID, co.Exchange, co.CommRate, co.Price, co.Shares, co.DateAdd AS CommDateAdd, 
                      co.DateEdit AS CommDateEdit, de.DestName, de.DestDesc, de.DestGroup, esy.ExSystemName, esy.ExSystemDesc, 
                       t.ClientID, t.AcctID, t.BasketFlag, t.ClearingBrokerID, t.Country, t.DateTrade, t.Memo AS TicketMemo, 
                      t.OrderRole, t.OrderType, t.Side, t.SoftDollarSponsorID, t.Symbol, t.DateAdd AS TicketDateAdd, t.DateEdit AS TicketDateEdit, cb.ClearingBrokerName, 
                      cb.ClearingBrokerName_full, t.SecurityType, sds.SoftDollarSponsorName, sds.SoftDollarSponsorDesc, sds.SoftDollarRate, 
                      a.AcctName, a.AcctNumSLK, a.AcctNumPershing, a.AcctNumFidelity, a.AcctNumInternal, a.AgentID, a.Alert, a.DTCID, a.InstID, a.IntPartyID1, 
                      a.IntPartyAcctNum1, a.IntPartyID2, a.IntPartyAcctNum2, a.memo AS AccountMemo, a.PBName, a.PBFlag, a.PBDocsF150Flag, a.PBDocsF151Flag, 
                      a.PBDocsF1toAFlag, a.ptrID, a.rep, a.SoftFlag, a.SpecialFlag, a.Status, a.TaxID AS AccountTaxID, a.EditDate, a.OpenDate, c.ClientName, 
                      c.ClientName_full, c.Contact_title, c.Contact_fname, c.Contact_mname, c.Contact_lname, c.Contact_nickname, c.Contact_position, c.Address1, 
                      c.Address2, c.City, c.State, c.Zip, c.TaxID AS ClientTaxID, c.memo AS ClientMemo, c.DateOpen AS ClientDateOpen, c.DateEdit AS ClientDateEdit
FROM         dbo.tblCommissions co INNER JOIN
                      dbo.tblDestinations de ON co.DestID = de.DestID INNER JOIN
                      dbo.tblExSystems esy ON co.ExSystemID = esy.ExSystemID INNER JOIN
                      dbo.tblTickets t ON co.TicketID = t.TicketID INNER JOIN
                      dbo.tblClearingBrokers cb ON t.ClearingBrokerID = cb.ClearingBrokerID INNER JOIN
                      dbo.tblSoftDollarSponsors sds ON t.SoftDollarSponsorID = sds.SoftDollarSponsorID INNER JOIN
                      dbo.tblClients c ON t.ClientID = c.ClientID INNER JOIN
                      dbo.tblAccounts a ON t.AcctID = a.AcctID
GO
/****** Object:  Default [DF_tblUsers_Enabled]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblUsers] ADD  CONSTRAINT [DF_tblUsers_Enabled]  DEFAULT (0) FOR [Enabled]
GO
/****** Object:  Default [DF_tblTrades_TradeDate]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblTrades] ADD  CONSTRAINT [DF_tblTrades_TradeDate]  DEFAULT (right(datepart(year,getdate()),4) + right((datepart(month,getdate()) + 100),2) + right((datepart(day,getdate()) + 100),2)) FOR [TradeDate]
GO
/****** Object:  Default [DF_tblTrades_SharesAllocated]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblTrades] ADD  CONSTRAINT [DF_tblTrades_SharesAllocated]  DEFAULT (0) FOR [SharesAllocated]
GO
/****** Object:  Default [DF_tblTrades_ExecutionTime]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblTrades] ADD  CONSTRAINT [DF_tblTrades_ExecutionTime]  DEFAULT (getdate()) FOR [ExecutionTime]
GO
/****** Object:  Default [DF_tblSlkTickets_ClearingBroker]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblSlkTickets_ClearingBroker]  DEFAULT ('NA') FOR [ClearingBrokerClearedAs]
GO
/****** Object:  Default [DF_tblSlkTickets_AcctNumSLK]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblSlkTickets_AcctNumSLK]  DEFAULT ('') FOR [AcctNumGSEC]
GO
/****** Object:  Default [DF_tblAllocations_ExecutedPrice]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblAllocations_ExecutedPrice]  DEFAULT ((0)) FOR [PriceExecuted]
GO
/****** Object:  Default [DF_tblAllocations_StrikePrice]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblAllocations_StrikePrice]  DEFAULT ((0)) FOR [PriceStrike]
GO
/****** Object:  Default [DF_tblAllocations_SharesAllocated]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblAllocations_SharesAllocated]  DEFAULT ((0)) FOR [SharesAllocated]
GO
/****** Object:  Default [DF_tblAllocations_SharesOrdered]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblAllocations_SharesOrdered]  DEFAULT ((0)) FOR [SharesOrdered]
GO
/****** Object:  Default [DF_tblAllocations_CommissionRate]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblAllocations_CommissionRate]  DEFAULT ((0)) FOR [CommissionRate]
GO
/****** Object:  Default [DF_tblSlkTickets_Commission]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblSlkTickets_Commission]  DEFAULT ((0)) FOR [Commission]
GO
/****** Object:  Default [DF_tblAllocations_GrossMonies]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblAllocations_GrossMonies]  DEFAULT ((0)) FOR [GrossMonies]
GO
/****** Object:  Default [DF_tblAllocations_NetMonies]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblAllocations_NetMonies]  DEFAULT ((0)) FOR [NetMonies]
GO
/****** Object:  Default [DF_tblAllocations_SecFee]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblAllocations_SecFee]  DEFAULT ((0)) FOR [SecFee]
GO
/****** Object:  Default [DF_tblSlkTickets_bBlotter]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblSlkTickets_bBlotter]  DEFAULT ((1)) FOR [bOpen]
GO
/****** Object:  Default [DF_tblSlkTickets_Flag]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblSlkTickets_Flag]  DEFAULT ('D') FOR [Flag]
GO
/****** Object:  Default [DF_tblSlkTickets_Tax]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblSlkTickets_Tax]  DEFAULT ((0)) FOR [Tax]
GO
/****** Object:  Default [DF_tblSlkTickets_bEOD]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblSlkTickets] ADD  CONSTRAINT [DF_tblSlkTickets_bEOD]  DEFAULT ((0)) FOR [bEOD]
GO
/****** Object:  Default [DF_tblPortfolioTrades_TradeDate]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblPortfolioTrades] ADD  CONSTRAINT [DF_tblPortfolioTrades_TradeDate]  DEFAULT (right(datepart(year,getdate()),4) + right((datepart(month,getdate()) + 100),2) + right((datepart(day,getdate()) + 100),2)) FOR [TradeDate]
GO
/****** Object:  Default [DF_tblPortfolioTrades_GroupName]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblPortfolioTrades] ADD  CONSTRAINT [DF_tblPortfolioTrades_GroupName]  DEFAULT ('DEFAULT') FOR [GroupName]
GO
/****** Object:  Default [DF_tblPortfolioTrades_CreatedOn]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblPortfolioTrades] ADD  CONSTRAINT [DF_tblPortfolioTrades_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
/****** Object:  Default [DF_tblPortfolioTrades_EditedOn]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblPortfolioTrades] ADD  CONSTRAINT [DF_tblPortfolioTrades_EditedOn]  DEFAULT (getdate()) FOR [EditedOn]
GO
/****** Object:  Default [DF_tblAccessLogs_DateAdd]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblAccessLogs] ADD  CONSTRAINT [DF_tblAccessLogs_DateAdd]  DEFAULT (getdate()) FOR [DateAdd]
GO
/****** Object:  Default [DF_tblTickets_CrossFlag]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblTickets] ADD  CONSTRAINT [DF_tblTickets_CrossFlag]  DEFAULT (0) FOR [CrossFlag]
GO
/****** Object:  Default [DF_tblTickets_ProgramStrategy]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblTickets] ADD  CONSTRAINT [DF_tblTickets_ProgramStrategy]  DEFAULT ('NA') FOR [ProgramStrategy]
GO
/****** Object:  Default [DF_tblTickets_SoftDollarRate]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblTickets] ADD  CONSTRAINT [DF_tblTickets_SoftDollarRate]  DEFAULT (0) FOR [SoftDollarRate]
GO
/****** Object:  Default [DF_tblTickets_BreakFlag]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblTickets] ADD  CONSTRAINT [DF_tblTickets_BreakFlag]  DEFAULT (0) FOR [BreakFlag]
GO
/****** Object:  Default [DF_tblAccounts_UserID]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblaccounts_old] ADD  CONSTRAINT [DF_tblAccounts_UserID]  DEFAULT ((0)) FOR [UserID]
GO
/****** Object:  Default [DF_tblClientAttributes_DateAdd]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblClientContacts] ADD  CONSTRAINT [DF_tblClientAttributes_DateAdd]  DEFAULT (getdate()) FOR [DateAdd]
GO
/****** Object:  Default [DF_tblClientAttributes_DateEdit]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblClientContacts] ADD  CONSTRAINT [DF_tblClientAttributes_DateEdit]  DEFAULT (getdate()) FOR [DateEdit]
GO
/****** Object:  Default [DF_tblCommissions_CrossFlag]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblCommissions] ADD  CONSTRAINT [DF_tblCommissions_CrossFlag]  DEFAULT (0) FOR [CrossFlag]
GO
/****** Object:  Default [DF_tblCommissions_CommType]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblCommissions] ADD  CONSTRAINT [DF_tblCommissions_CommType]  DEFAULT ('DS') FOR [CommType]
GO
/****** Object:  Default [DF_tblCommissions_Commission]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblCommissions] ADD  CONSTRAINT [DF_tblCommissions_Commission]  DEFAULT (0) FOR [Commission]
GO
/****** Object:  Default [DF_tblCommissions_Shares]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblCommissions] ADD  CONSTRAINT [DF_tblCommissions_Shares]  DEFAULT (0) FOR [Shares]
GO
/****** Object:  ForeignKey [FK_tblAccessPerms_tblUsers]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblAccessPerms]  WITH CHECK ADD  CONSTRAINT [FK_tblAccessPerms_tblUsers] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUsers] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblAccessPerms] CHECK CONSTRAINT [FK_tblAccessPerms_tblUsers]
GO
/****** Object:  ForeignKey [FK_tblAccessLogs_tblUsers]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblAccessLogs]  WITH NOCHECK ADD  CONSTRAINT [FK_tblAccessLogs_tblUsers] FOREIGN KEY([UserID])
REFERENCES [dbo].[tblUsers] ([UserID])
GO
ALTER TABLE [dbo].[tblAccessLogs] CHECK CONSTRAINT [FK_tblAccessLogs_tblUsers]
GO
/****** Object:  ForeignKey [FK_tblClients_tblBrokerDealer]    Script Date: 04/10/2014 12:55:13 ******/
ALTER TABLE [dbo].[tblClients]  WITH NOCHECK ADD  CONSTRAINT [FK_tblClients_tblBrokerDealer] FOREIGN KEY([BrokerDealer])
REFERENCES [dbo].[tblBrokerDealer] ([BrokerDealer])
GO
ALTER TABLE [dbo].[tblClients] CHECK CONSTRAINT [FK_tblClients_tblBrokerDealer]
GO
/****** Object:  ForeignKey [FK_tblSoftDollarPayments_tblClients]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblSoftDollarPayments]  WITH NOCHECK ADD  CONSTRAINT [FK_tblSoftDollarPayments_tblClients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[tblClients] ([ClientID])
GO
ALTER TABLE [dbo].[tblSoftDollarPayments] CHECK CONSTRAINT [FK_tblSoftDollarPayments_tblClients]
GO
/****** Object:  ForeignKey [FK_tblSoftDollarPayments_tblPlanSponsors]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblSoftDollarPayments]  WITH NOCHECK ADD  CONSTRAINT [FK_tblSoftDollarPayments_tblPlanSponsors] FOREIGN KEY([PlanSponsorID])
REFERENCES [dbo].[tblPlanSponsors] ([PlanSponsorID])
GO
ALTER TABLE [dbo].[tblSoftDollarPayments] CHECK CONSTRAINT [FK_tblSoftDollarPayments_tblPlanSponsors]
GO
/****** Object:  ForeignKey [FK_tblTickets_tblClearingBrokers]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblTickets]  WITH NOCHECK ADD  CONSTRAINT [FK_tblTickets_tblClearingBrokers] FOREIGN KEY([ClearingBrokerID])
REFERENCES [dbo].[tblClearingBrokers] ([ClearingBrokerID])
GO
ALTER TABLE [dbo].[tblTickets] CHECK CONSTRAINT [FK_tblTickets_tblClearingBrokers]
GO
/****** Object:  ForeignKey [FK_tblTickets_tblClients]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblTickets]  WITH NOCHECK ADD  CONSTRAINT [FK_tblTickets_tblClients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[tblClients] ([ClientID])
GO
ALTER TABLE [dbo].[tblTickets] CHECK CONSTRAINT [FK_tblTickets_tblClients]
GO
/****** Object:  ForeignKey [FK_tblTickets_tblOrderRoles]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblTickets]  WITH NOCHECK ADD  CONSTRAINT [FK_tblTickets_tblOrderRoles] FOREIGN KEY([OrderRole])
REFERENCES [dbo].[tblOrderRoles] ([OrderRole])
GO
ALTER TABLE [dbo].[tblTickets] CHECK CONSTRAINT [FK_tblTickets_tblOrderRoles]
GO
/****** Object:  ForeignKey [FK_tblTickets_tblOrderTypes]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblTickets]  WITH NOCHECK ADD  CONSTRAINT [FK_tblTickets_tblOrderTypes] FOREIGN KEY([OrderType])
REFERENCES [dbo].[tblOrderTypes] ([OrderType])
GO
ALTER TABLE [dbo].[tblTickets] CHECK CONSTRAINT [FK_tblTickets_tblOrderTypes]
GO
/****** Object:  ForeignKey [FK_tblTickets_tblPlanSponsors]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblTickets]  WITH NOCHECK ADD  CONSTRAINT [FK_tblTickets_tblPlanSponsors] FOREIGN KEY([PlanSponsorID])
REFERENCES [dbo].[tblPlanSponsors] ([PlanSponsorID])
GO
ALTER TABLE [dbo].[tblTickets] CHECK CONSTRAINT [FK_tblTickets_tblPlanSponsors]
GO
/****** Object:  ForeignKey [FK_tblTickets_tblSecurityTypes]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblTickets]  WITH NOCHECK ADD  CONSTRAINT [FK_tblTickets_tblSecurityTypes] FOREIGN KEY([SecurityType])
REFERENCES [dbo].[tblSecurityTypes] ([SecurityType])
GO
ALTER TABLE [dbo].[tblTickets] CHECK CONSTRAINT [FK_tblTickets_tblSecurityTypes]
GO
/****** Object:  ForeignKey [FK_accounts_clients]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblaccounts_old]  WITH NOCHECK ADD  CONSTRAINT [FK_accounts_clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[tblClients] ([ClientID])
GO
ALTER TABLE [dbo].[tblaccounts_old] CHECK CONSTRAINT [FK_accounts_clients]
GO
/****** Object:  ForeignKey [FK_Accounts_tblClients]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblaccounts_old]  WITH NOCHECK ADD  CONSTRAINT [FK_Accounts_tblClients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[tblClients] ([ClientID])
GO
ALTER TABLE [dbo].[tblaccounts_old] CHECK CONSTRAINT [FK_Accounts_tblClients]
GO
/****** Object:  ForeignKey [FK_tblAccounts_tblClients]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblaccounts_old]  WITH NOCHECK ADD  CONSTRAINT [FK_tblAccounts_tblClients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[tblClients] ([ClientID])
GO
ALTER TABLE [dbo].[tblaccounts_old] CHECK CONSTRAINT [FK_tblAccounts_tblClients]
GO
/****** Object:  ForeignKey [FK_account_client]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblaccounts]  WITH NOCHECK ADD  CONSTRAINT [FK_account_client] FOREIGN KEY([ClientID])
REFERENCES [dbo].[tblClients] ([ClientID])
GO
ALTER TABLE [dbo].[tblaccounts] CHECK CONSTRAINT [FK_account_client]
GO
/****** Object:  ForeignKey [FK_tblClientContacts_tblClients]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblClientContacts]  WITH NOCHECK ADD  CONSTRAINT [FK_tblClientContacts_tblClients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[tblClients] ([ClientID])
GO
ALTER TABLE [dbo].[tblClientContacts] CHECK CONSTRAINT [FK_tblClientContacts_tblClients]
GO
/****** Object:  ForeignKey [FK_tblCommissions_tblExchanges]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblCommissions]  WITH NOCHECK ADD  CONSTRAINT [FK_tblCommissions_tblExchanges] FOREIGN KEY([Exchange])
REFERENCES [dbo].[tblExchanges] ([Exchange])
GO
ALTER TABLE [dbo].[tblCommissions] CHECK CONSTRAINT [FK_tblCommissions_tblExchanges]
GO
/****** Object:  ForeignKey [FK_tblCommissions_tblExSources]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblCommissions]  WITH NOCHECK ADD  CONSTRAINT [FK_tblCommissions_tblExSources] FOREIGN KEY([DestID])
REFERENCES [dbo].[tblDestinations] ([DestID])
GO
ALTER TABLE [dbo].[tblCommissions] CHECK CONSTRAINT [FK_tblCommissions_tblExSources]
GO
/****** Object:  ForeignKey [FK_tblCommissions_tblExSystems]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblCommissions]  WITH NOCHECK ADD  CONSTRAINT [FK_tblCommissions_tblExSystems] FOREIGN KEY([ExSystemID])
REFERENCES [dbo].[tblExSystems] ([ExSystemID])
GO
ALTER TABLE [dbo].[tblCommissions] CHECK CONSTRAINT [FK_tblCommissions_tblExSystems]
GO
/****** Object:  ForeignKey [FK_tblCommissions_tblTickets]    Script Date: 04/10/2014 12:55:15 ******/
ALTER TABLE [dbo].[tblCommissions]  WITH NOCHECK ADD  CONSTRAINT [FK_tblCommissions_tblTickets] FOREIGN KEY([TicketID])
REFERENCES [dbo].[tblTickets] ([TicketID])
GO
ALTER TABLE [dbo].[tblCommissions] CHECK CONSTRAINT [FK_tblCommissions_tblTickets]
GO
