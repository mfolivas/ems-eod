package test.com.guzman.unx.eod.service;

import static org.junit.Assert.*

import com.guzman.core.date.utils.DateUtils;
import com.guzman.unx.eod.service.DestinationsValidatorService

import org.joda.time.DateTime;
import org.junit.Test

class DestinationsValidatorServiceTest {

	@Test
	public void should_have_no_unknown_destinations() {
		String filename = "test-files/20120626_Executions_US_1.csv"
		String date = "20120626"
		DateTime datetime = DateUtils.getDateTime(date)
		DestinationsValidatorService.validateThatAllRecordsHaveADestiantions(datetime.toDate(), filename)
		assert true == true
	}
}
