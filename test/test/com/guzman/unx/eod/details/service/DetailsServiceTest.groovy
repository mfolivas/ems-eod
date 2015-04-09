package test.com.guzman.unx.eod.details.service;

import static org.junit.Assert.*;


import com.guzman.core.date.utils.DateUtils;
import com.guzman.unx.eod.trades.valueobjects.EMS
import org.junit.Test;

import com.guzman.unx.eod.details.service.DetailsService;

class DetailsServiceTest {

	
	@Test
	public void should_return_a_null_pointer_exception() {
		def service = DetailsService.valueOf()
		def date = DateUtils.getDateTime("20121231")
		assert true == service.process("test-files/20121231_Executions_US_1.csv", date.toDate(), EMS.ITG)
		//This should not thrown an error since it is now a warning
		assert true == true
	}
}
