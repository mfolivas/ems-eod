package test.com.guzman.unx.eod.details.valueobjects;

import static org.junit.Assert.*

import org.junit.Test

import com.guzman.unx.eod.details.domain.EodRecord
import com.guzman.unx.eod.details.valueobjects.FileService
import com.guzman.unx.eod.details.valueobjects.FileServiceITG
import com.guzman.unx.eod.trades.valueobjects.EMS

class FileServiceTest {

	@Test
	public void should_get_all_records() {
		def fileLocation = "test-files/20121127_Executions_AP_1.csv"
		def records = FileServiceITG.getAllRecords(fileLocation, EMS.INTERNATIONAL)
		assert records != null
		assert records.size() == 40
	}
	
	
	@Test
	public void should_return_just_one_error_when_empty_basket_name() {
		String rec1 = "ITG,41092084,,,241.3.1,241.3.1,20120828,,ZVZZT,2,TEST001,1,1000,1,0,NMS,Day,ITGG,ITGG,GZML,,,41092089,500,1,0,Day,2-20120828,-1,150,1297.5001,20120828-09:51:22,20120828-09:51:58,20120828-09:52:40"
		String rec2 = "ITG,41092084,,,241.3.1,241.3.1,20120828,,ZVZZT,2,TEST001,1,1000,1,0,NMS,Day,ITGG,ITGG,GZML,,,41092089,500,1,0,Day,3-20120828,-1,100,1297.5001,20120828-09:51:22,20120828-09:51:58,20120828-09:52:40"
		String rec3 = "ITG,41092084,,,241.3.1,241.3.1,20120828,,ZVZZT,2,TEST001,1,1000,1,0,NMS,Day,ITGG,ITGG,GZML,,,41092089,500,1,0,Day,4-20120828,-1,100,10.05,20120828-09:51:22,20120828-09:51:58,20120828-09:53:34"
		
		List<EodRecord> records = new ArrayList<EodRecord>()
		for (rec in [rec1, rec2, rec3]) {
			String[] record = rec.split(",")
			records <<  EodRecord.valueOf(record, EMS.ITG)
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
