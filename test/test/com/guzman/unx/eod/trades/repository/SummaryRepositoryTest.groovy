package test.com.guzman.unx.eod.trades.repository

import com.guzman.core.date.utils.DateUtils
import com.guzman.unx.eod.details.service.DetailsService
import com.guzman.unx.eod.trades.repository.SummaryRepository
import com.guzman.unx.eod.trades.valueobjects.EMS
import groovy.sql.Sql
import org.h2.tools.RunScript
import org.junit.Test

class SummaryRepositoryTest {

	@Test
	public void should_process_detail_and_summary_for_20150327() {
		def summaryRepository = new SummaryRepository()
		def sql = getConnection()
		RunScript.execute(sql.getConnection(), new FileReader("sql/master_detail_tables.sql"))
		String tradeDate = "20150327"
		def date = DateUtils.getDateTime(tradeDate)
		def service = new DetailsService()
		service.process("test-files/ClientEODTradeDetail_Guzman_US_20150327.csv", date.toDate(), EMS.INSTINET)

		//Insert summary
		summaryRepository.insert(date.toDate(), EMS.INSTINET)

		//validate that the summary is fine
		def map = [:]
		def query = "select Source, COUNT(*) as total from tbltrades where TradeDate = ? group by Source order by source"

		sql.eachRow(query, [tradeDate]) { record ->
			map[record.Source] = record.total
		}

		assert map.get("AJO1") == 28
		assert map.get("BLK1") == 2
		assert map.get("NYCRS1") == 40
		assert map.get("QMA1") == 2
		assert map.get("QMA2") == 1
		assert map.get("QMA3") ==1
		assert map.get("QMAINTL") == 1
		assert map.get("TIAA1") == 111
		assert map.get("TIAA2") == 1
		assert map.get("TIAA3") == 58


	}

	private def getConnection() {
		return Sql.newInstance("jdbc:h2:mem:intranet;MODE=MSSQLSERVER", "sa", "sa", "org.h2.Driver")
	}
}
