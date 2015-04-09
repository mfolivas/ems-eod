package test.com.guzman.unx.eod.trades.valueobjects;

import static org.junit.Assert.*;

import org.junit.Test;

import com.guzman.unx.eod.trades.valueobjects.Records;

class RecordsTest {

	
	@Test
	public void should_return_just_one_record() {
		def records = ["JBTEIN-B-007":1]
		def output = Records.getRecordsWithSqlFormat(records)
		assert "'JBTEIN-B-007'" == output
	}
	
	@Test
	public void should_return_records() {
		def records = ["JBTEIN-B-007":1, "JBTEIN-S-007":2]
		def output = Records.getRecordsWithSqlFormat(records)
		assert "'JBTEIN-B-007','JBTEIN-S-007'" == output
		
		String sql = "AND listId not in (##RECORDS##)"
		def sqloutput = Records.getSqlWithRecordOmmittedPopulated(sql, records, "##RECORDS##")
		assert "AND listId not in ('JBTEIN-B-007','JBTEIN-S-007')" == sqloutput
	}
}
