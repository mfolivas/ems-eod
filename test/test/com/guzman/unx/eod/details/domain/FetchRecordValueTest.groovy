package test.com.guzman.unx.eod.details.domain;

import static org.junit.Assert.*

import org.junit.Test

import com.guzman.unx.eod.details.domain.FetchRecordValue
import com.guzman.unx.eod.details.valueobjects.ITGValuesPositions

class FetchRecordValueTest {

	@Test
	public void should_return_a_valid_date() {
		def line = "ITG,4128773,BQQ00001,,178.1.1,178.1.1,20120628,TEST_CLT40-B-001,ZVZZT,2,TEST001,B,200,Market,0,NMS,Day,DOT,GETC,GZML,,,4588301,200,1,0,Day,2-20120626,-1,100,1688.0001,20120626-14:32:06,20120626-14:56:16,20120626-14:56:16"
		def records = line.split(",")
		def date = FetchRecordValue.getDateFormatted(records, ITGValuesPositions.DATETIME_ROUTED)
		assert "2012-06-26 14:56:16" == date
	}
}
