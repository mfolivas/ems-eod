package test.com.guzman.unx.eod.details.domain;

import static org.junit.Assert.*;

import org.junit.Test;

import com.guzman.unx.eod.details.domain.ClientInfo;
import com.guzman.unx.eod.details.domain.EodRecord;
import com.guzman.unx.eod.trades.valueobjects.EMS;

class EodRecordsTest {

	@Test
	public void should_return_an_itg_record() {
		def line = "ITG,4128773,BQQ00001,,178.1.1,178.1.1,20120628,TEST_CLT40-B-001,ZVZZT,2,TEST001,B,200,Market,0,NMS,Day,DOT,GETC,GZML,,,4588301,200,1,0,Day,2-20120626,-1,100,1688.0001,20120626-14:32:06,20120626-14:56:16,20120626-14:56:16"
		def records = line.split(",")
		def eodRecord = EodRecord.valueOf(records, EMS.ITG)
		
		assert '4128773'==eodRecord.unxOrderId
		assert 'BQQ00001'==eodRecord.guzmanClientOrderId
		assert ''==eodRecord.originalGuzClientOrderId
		assert '178.1.1'==eodRecord.unxClientOrderId
		assert '178.1.1'==eodRecord.originalUnxClientOrderId
		assert '20120628'==eodRecord.tradeDate
		assert 'TEST_CLT40-B-001'==eodRecord.listId
		assert 'ZVZZT'==eodRecord.symbol
		assert '2'==eodRecord.idSource
		assert 'TEST001'==eodRecord.securityId
		assert 'B'==eodRecord.side
		assert 200==eodRecord.shares
		assert 'Market'==eodRecord.orderType
		assert '0'==eodRecord.priceClientLimit
		assert 'NMS'==eodRecord.exchange
		assert 'Day'==eodRecord.tif
		assert 'DOT'==eodRecord.destId
		assert 'GETC'==eodRecord.clearingBroker
		assert 'GZML'==eodRecord.mPid
		assert ''==eodRecord.algoStrategy
		assert ''==eodRecord.algoParameters
		assert '4588301'==eodRecord.unxWaveId
		assert 200==eodRecord.waveShares
		assert '1'==eodRecord.waveOrderType
		assert '0'==eodRecord.waveLimitPrice
		assert 'Day'==eodRecord.waveTif
		assert '2-20120626'==eodRecord.unxExecId
		assert '-1'==eodRecord.exchangeRefExecId
		assert 100==eodRecord.lastShares
		assert 1688.0001==eodRecord.lastPrice
		assert '2012-06-26 14:32:06'==eodRecord.orderReceived
		assert '2012-06-26 14:56:16'==eodRecord.dateTimeRouted
		assert '2012-06-26 14:56:16'==eodRecord.executionTime
	}
	
	
	@Test
	public void should_return_a_record_with_no_US_suffix() {
		def line = "TIAA-CREF (G754),Instinet,!1130405005590026,10405005567373D1,10405005567373D1,10405005590026D1,10405005590026D1,20130408,1130405005567374,HUB/B US,1,443510201,2,NYQ,160,ATC,0.0000,ATC,G-GSACHSALGOS,GSET,GZML,SOR,,,160,ATC,0.0000,DAY,171931907,160,94.4400,20130408-12:49:11,20130408-12:50:45,20130408-16:02:37"
		def records = line.split(",")
		def clientInfo = ClientInfo.valueOf("TIAA-CREF (G754)", "Instinet")
		def eodRecord = EodRecord.valueOf(records, EMS.INSTINET)
		
		//assert clientInfo == eodRecord.clientInfo
		assert clientInfo.clientName == eodRecord.clientName
		assert clientInfo.clientNetwork == eodRecord.clientNetwork
		assert '!1130405005590026'==eodRecord.unxOrderId
		assert '10405005567373D1'==eodRecord.guzmanClientOrderId
		assert '10405005567373D1'==eodRecord.originalGuzClientOrderId
		assert '10405005590026D1'==eodRecord.unxClientOrderId
		assert '10405005590026D1'==eodRecord.originalUnxClientOrderId
		assert '20130408'==eodRecord.tradeDate
		assert '1130405005567374'==eodRecord.listId
		assert 'HUB/B'==eodRecord.symbol
		assert '1'==eodRecord.idSource
		assert '443510201'==eodRecord.securityId
		assert '2'==eodRecord.side
		assert 160==eodRecord.shares
		assert 'ATC'==eodRecord.orderType
		assert '0.0000'==eodRecord.priceClientLimit
		assert 'NYQ'==eodRecord.exchange
		assert 'ATC'==eodRecord.tif
		assert 'G-GSACHSALGOS'==eodRecord.destId
		assert 'GSET'==eodRecord.clearingBroker
		assert 'GZML'==eodRecord.mPid
		assert 'SOR'==eodRecord.algoStrategy
		assert ''==eodRecord.algoParameters
		assert ''==eodRecord.unxWaveId
		assert 160==eodRecord.waveShares
		assert 'ATC'==eodRecord.waveOrderType
		assert '0.0000'==eodRecord.waveLimitPrice
		assert 'DAY'==eodRecord.waveTif
		assert '171931907'==eodRecord.unxExecId
		assert null ==eodRecord.exchangeRefExecId
		assert 160==eodRecord.lastShares
		assert 94.44==eodRecord.lastPrice
		assert '2013-04-08 12:49:11'==eodRecord.orderReceived
		assert '2013-04-08 12:50:45'==eodRecord.dateTimeRouted
		assert '2013-04-08 16:02:37'==eodRecord.executionTime
		
		
	}
}
