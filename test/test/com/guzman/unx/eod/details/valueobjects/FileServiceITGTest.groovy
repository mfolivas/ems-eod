package test.com.guzman.unx.eod.details.valueobjects;

import static org.junit.Assert.*

import org.junit.Test

import com.guzman.unx.eod.details.valueobjects.FileServiceITG
import com.guzman.unx.eod.trades.valueobjects.EMS

class FileServiceITGTest {

	@Test
	public void should_get_seven_records() {
		def fileLocation = "test-files/20120626_Executions_US_1.csv"
		def records = FileServiceITG.getAllRecords(fileLocation, EMS.ITG)
		assert records != null
		assert records.size() == 7
		def record = records.get(0)
		def expectedRecord = ['ITG','4128773','BQQ00001',null,'178.1.1','178.1.1','20120628','TEST_CLT40-B-001','ZVZZT','2','TEST001','B','200','Market','0',null,'NMS','Day','DOT','GETC','GZML',null,null,'4588301','200','1','0','Day','2-20120626',null,'100','1688.0001','2012-06-26 14:32:06','2012-06-26 14:56:16','2012-06-26 14:56:16',null,null]
		assert expectedRecord == record.getList()
		
	}
	
	
}
