package test.com.guzman.unx.eod.details.domain;

import static org.junit.Assert.*;

import com.guzman.unx.eod.details.domain.FileName
import com.guzman.unx.eod.trades.valueobjects.EMS;

import org.junit.Test;

class FileNameTest {
	
	@Test(expected=NullPointerException.class)
	public void should_throw_an_exception_due_to_no_name() {
		def filename = new FileName(null, null)
		String ems = filename.getEms()
	}
	
	@Test
	public void should_be_able_to_fetch_the_correct_ems() {
		def filename = new FileName("20121023_Executions_AP_1.csv", "test-files/")
		EMS ems = filename.getEms()
		assert EMS.INTERNATIONAL == ems
		
		filename = new FileName("20120612_Executions_US_1.csv", "test-files/")
		filename = new FileName("20120612_Executions_US_1.txt", "test-files/")
		filename = new FileName("20120612_Executions_US_1", "test-files/")
		ems = filename.getEms()
		assert EMS.ITG == ems
	}
}
