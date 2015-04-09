package test.com.guzman.unx.eod.service

import groovy.sql.Sql
import org.h2.tools.RunScript;

import static org.junit.Assert.*

import com.guzman.core.date.utils.DateUtils;
import com.guzman.unx.eod.service.DestinationsValidatorService

import org.joda.time.DateTime;
import org.junit.Test

class DestinationsValidatorServiceTest {

	@Test
	public void should_have_no_unknown_destinations() {
		def sql = Sql.newInstance("jdbc:h2:mem:intranet;MODE=MSSQLSERVER;IGNORECASE=true;", "sa", "sa", "org.h2.Driver")
		RunScript.execute(sql.getConnection(), new FileReader("sql/master_detail_tables.sql"))
		String filename = "test-files/20120626_Executions_US_1.csv"
		String date = "20120626"
		DateTime datetime = DateUtils.getDateTime(date)
		DestinationsValidatorService.validateThatAllRecordsHaveADestiantions(datetime.toDate(), filename)
		assert true == true
	}
}
