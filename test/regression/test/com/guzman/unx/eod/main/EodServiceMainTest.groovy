package regression.test.com.guzman.unx.eod.main;

import static org.junit.Assert.*

import org.junit.Ignore;
import org.junit.Test

import groovy.sql.Sql

import com.guzman.unx.eod.details.valueobjects.FileService;
import com.guzman.unx.eod.service.EodService
import com.guzman.unx.eod.service.MultipleEODFileService;
import com.guzman.unx.eod.trades.valueobjects.EMS;

class EodServiceMainTest {

	@Test
	public void should_insert_all_records() {
//		def service = EodService.getInstance()
//		service.process("20130401", "ClientEODTradeDetail_Guzman_US_20130401.csv")
//		service.process("20130402", "ClientEODTradeDetail_Guzman_US_20130402.csv")
//		service.process("20130403", "ClientEODTradeDetail_Guzman_US_20130403.csv")
//		service.process("20130404", "ClientEODTradeDetail_Guzman_US_20130404.csv")
//		service.process("20130405", "ClientEODTradeDetail_Guzman_US_20130405.csv")
//		service.process("20130408", "ClientEODTradeDetail_Guzman_US_20130408.csv")
//		service.process("20121205", "20121205_Executions_EU_1.csv")
		assert true
	}
	
	
	@Ignore
	public void should_insert_all_international_files() {
		def sql = Sql.newInstance("jdbc:sqlserver://gts10:1433;databaseName=intranet",
			"dbuser", "bloody","com.microsoft.sqlserver.jdbc.SQLServerDriver")
		String deleteSql = "DELETE FROM tblTradesDetail where ems_name = ?"
		String international = EMS.INTERNATIONAL.getName()
		sql.execute(deleteSql,[international])
		MultipleEODFileService.processAllFiles()
		sql.eachRow("SELECT COUNT(*) as total FROM tblTradesDetail where ems_name = ?",[international]) { 
			assert 1206 == it.total
		} 
	}
	
	@Ignore
	public void should_insert_all_files_from_test_directory_who_are_international() {
		def sql = Sql.newInstance("jdbc:sqlserver://gts10:1433;databaseName=intranet",
			"dbuser", "bloody","com.microsoft.sqlserver.jdbc.SQLServerDriver")
		String deleteSql = "DELETE FROM tblTradesDetail where tradedate = ? and listid = ?"
		String deleteSummarySql = "DELETE FROM tblTrades where tradedate = ? and source like ?"
		def service = EodService.getInstance()
		new File("test-files/").eachFile { file ->
			//is international
			if(file.name =~/[0-9]{8}.Executions_[^US]/ && file.size() > 376) {
				String date = file.name.substring(0,8)
				String name = file.name
				println name
				def records = FileService.getAllRecords(file.absolutePath, EMS.INTERNATIONAL)
				assert records.size() > 0
				def baskets = [] as Set
				baskets.addAll(records.collect{ it.listId})
				println baskets
				baskets.each{ basket ->
					try {
						sql.execute(deleteSql, [date, basket])
						sql.execute(deleteSummarySql, [date, '%'+basket])
					} catch (Exception e) {
						e.printStackTrace()
					}
				}
				service.process(date, file.name)
			}
		}
		sql.close()
	}
}
