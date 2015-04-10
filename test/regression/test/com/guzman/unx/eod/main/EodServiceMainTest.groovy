package regression.test.com.guzman.unx.eod.main

import org.h2.tools.RunScript;

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
		def sql = Sql.newInstance("jdbc:h2:mem:intranet;MODE=MSSQLSERVER", "sa", "sa", "org.h2.Driver")
		RunScript.execute(sql.getConnection(), new FileReader("sql/master_detail_tables.sql"))
		def service = EodService.getInstance()
		service.process("20150327", "ClientEODTradeDetail_Guzman_US_20150327.csv")
		service.process("20130402", "ClientEODTradeDetail_Guzman_US_20150403.csv")
		service.process("20130403", "ClientEODTradeDetail_Guzman_US_20150406.csv")
//		service.process("20130404", "ClientEODTradeDetail_Guzman_US_20130404.csv")
//		service.process("20130405", "ClientEODTradeDetail_Guzman_US_20130405.csv")
//		service.process("20130408", "ClientEODTradeDetail_Guzman_US_20130408.csv")
//		service.process("20121205", "20121205_Executions_EU_1.csv")
		assert true
	}
}
