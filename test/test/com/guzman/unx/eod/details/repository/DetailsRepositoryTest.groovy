package test.com.guzman.unx.eod.details.repository

import com.guzman.core.date.utils.DateUtils
import com.guzman.unx.eod.details.domain.EodRecord
import com.guzman.unx.eod.details.repository.DetailsRepository
import com.guzman.unx.eod.details.valueobjects.FileServiceITG
import com.guzman.unx.eod.trades.valueobjects.EMS
import groovy.sql.Sql
import org.h2.tools.RunScript
import org.joda.time.DateTime
import org.junit.BeforeClass
import org.junit.Test

class DetailsRepositoryTest {
	@BeforeClass
	public static void load_database() {
		def sql = Sql.newInstance("jdbc:h2:mem:intranet;MODE=MSSQLSERVER", "sa", "sa", "org.h2.Driver")
		RunScript.execute(sql.getConnection(), new FileReader("sql/master_detail_tables.sql"))
	}
	
	@Test
	public void should_insert_all_records_into_the_db() {
		def sql = Sql.newInstance("jdbc:h2:mem:intranet;MODE=MSSQLSERVER", "sa", "sa", "org.h2.Driver")
		sql.execute("DELETE FROM tblTradesDetail where tradedate = '20150327'")
		sql.close()
		def repository = new DetailsRepository()
		DateTime tradeDate = DateUtils.getDateTime("20150327")
		def fileLocation = "test-files/ClientEODTradeDetail_Guzman_US_20150327.csv"
		def records = FileServiceITG.getAllRecords(fileLocation, EMS.INSTINET)
		repository.insert(records, tradeDate.toDate())

		assert records.size() == 3822
		EodRecord firstRecord = records.get(0)
		assert firstRecord.rawLiquidity == ""
		assert firstRecord.lastMkt == "DBAX"
		assert firstRecord.lastLiquidity == ""
		assert firstRecord.currency == "USD"

		EodRecord record3774 = records.get(3774)
		assert record3774.rawLiquidity == "4"
		assert record3774.lastMkt == "XNAS"
		assert record3774.lastLiquidity == ""
		assert record3774.currency == "USD"

		EodRecord lastRecord = records.get(3821)
		assert lastRecord.rawLiquidity == "6/2"
		assert lastRecord.lastMkt == "XNYS"
		assert lastRecord.lastLiquidity == "52"
		assert lastRecord.currency == "USD"
	}
}
