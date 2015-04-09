package test.com.guzman.unx.eod.details.valueobjects;

import static org.junit.Assert.*;

import org.junit.Test;

import com.guzman.unx.eod.details.service.mapper.InstinetRecordMapper;
import com.guzman.unx.eod.details.domain.ClientInfo;
import com.guzman.unx.eod.details.domain.EodRecord
import com.guzman.unx.eod.trades.valueobjects.EMS;

class InstinetValuePositionTest {

	@Test
	public void should_return_an_instinet_record() {
		
		String actualRecord = "TIAA-CREF (G754),Instinet,!1130405005590026,10405005567373D1,10405005567373D1,10405005590026D1,10405005590026D1,20130408,1130405005567374,HUB/B US,1,443510201,2,NYQ,160,ATC,0.0000,ATC,G-GSACHSALGOS,GSET,GZML,SOR,,,160,ATC,0.0000,DAY,171931907,160,94.4400,20130408-12:49:11,20130408-12:50:45,20130408-16:02:37"
		String[] record = actualRecord.split(",")
		EodRecord eodRecord = InstinetRecordMapper.get(record, EMS.INSTINET)
		assert eodRecord != null
		assert "TIAA-CREF (G754)" == eodRecord.clientName
		assert "Instinet" == eodRecord.clientNetwork
		assert "10405005590026D1" == eodRecord.unxClientOrderId
		assert "!1130405005590026" == eodRecord.unxOrderId
		assert null == eodRecord.orderStatus
		assert "G-GSACHSALGOS" == eodRecord.destId
		assert "GZML" == eodRecord.mPid
	} 
}
