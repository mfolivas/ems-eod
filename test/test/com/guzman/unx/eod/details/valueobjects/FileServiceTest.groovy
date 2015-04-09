package test.com.guzman.unx.eod.details.valueobjects

import com.guzman.unx.eod.details.domain.EodRecord
import com.guzman.unx.eod.details.valueobjects.FileService
import com.guzman.unx.eod.details.valueobjects.FileServiceITG
import com.guzman.unx.eod.trades.valueobjects.EMS
import org.junit.Test

class FileServiceTest {
	
	
	@Test
	public void should_return_just_one_error_when_empty_basket_name() {
		String rec1 = "TIAA,Instinet,!1150326017013365,10326016920779D1,10326016920779D1,10326017013365D1,10326017013365D1,20150327,TIAA3,AIRM US,1,009128307,1,NSQ,1049,5,,ATC,G-MLALGO,MLCO,GZML,8. QMOC,,,1049,,0.0000,DAY,172913687,1049,47.0200,20150327-13:12:29,20150327-13:14:16,20150327-16:00:00,4,XNAS,,USD"
		String rec2 = "TIAA,Instinet,!1150326017013368,10326016920809D1,10326016920809D1,AAA 8308/03272015,AAA 8308/03272015,20150327,,SNX US,1,87162W100,1,NYQ,658,5,,ATC,INSTINET,NYSE,GZML,SmartRouter,,,658,,0.0000,DAY,172946741,606,76.1800,20150327-13:12:29,20150327-13:14:16,20150327-16:07:51,6/2,XNYS,52,USD"
		String rec3 = "TIAA,Instinet,!1150326017013368,10326016920809D1,10326016920809D1,AAA 8308/03272015,AAA 8308/03272015,20150327,TIAA3,SNX US,1,87162W100,1,NYQ,658,5,,ATC,INSTINET,NYSE,GZML,SmartRouter,,,658,,0.0000,DAY,172946743,52,76.1800,20150327-13:12:29,20150327-13:14:16,20150327-16:07:51,6/2,XNYS,52,USD"
		
		List<EodRecord> records = new ArrayList<EodRecord>()
		for (rec in [rec1, rec2, rec3]) {
			String[] record = rec.split(",")
			records <<  EodRecord.valueOf(record, EMS.INSTINET)
		}
		assert 3 == records.size()
		assert false == FileService.doAllRecordsHaveASourceName(records)
	}
	
	@Test
	public void should_skip_lines() {
		String line = "﻿ClientName,ClentNetwork,ems_order_id,ClordID,OrigClordID,EmsClordID,OrigEmsClordID,TradeDate,ListID,Symbol,IDSource,SecurityID,Side,PrimaryExchange,ClientShares,ClientOrderType,ClientLmtPx,ClientTIF,Destination,ExecBroker,MPID,AlgoStrategy,AlgoParameters,WaveID,WaveShares,WaveOrderType,WaveLmtPx,WaveTIF,ExecID,LastSh,LastPx,datetime_orderreceived,datetime_routed,datetime_executed\n"
		assert line =~ "ClientName"
		assert true == FileServiceITG.shouldSkip(line)
		line = ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"
		assert true == FileServiceITG.shouldSkip(line)
	}
}
