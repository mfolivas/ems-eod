package test.com.guzman.unx.eod.details.valueobjects;

import static org.junit.Assert.*;


import org.junit.Test;

import com.guzman.unx.eod.details.domain.FileName;
import com.guzman.unx.eod.details.valueobjects.FileNameService;

class FileNameServiceTest {

	@Test(expected=NullPointerException.class)
	public void should_return_an_error() {
		FileNameService.createFileName(null)
	}
		
	@Test
	public void should_return_good_file(){
		
		FileName file = FileNameService.createFileName("20120202_Executions_US");
		assert file != null
	}
	
}
