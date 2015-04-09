package test.com.guzman.unx.eod.trades.repository

import org.h2.tools.RunScript
import org.junit.Before
import org.junit.BeforeClass;

import static org.junit.Assert.*;

import org.junit.Test;

import com.guzman.core.date.utils.DateUtils;
import com.guzman.unx.eod.details.service.DetailsService;
import com.guzman.unx.eod.trades.repository.SummaryRepository
import com.guzman.unx.eod.trades.valueobjects.EMS;

import groovy.sql.Sql

class SummaryRepositoryTest {
	private def summaryRepository = new SummaryRepository()
	private static final String REPORT_DATE = "20121015"
	private static final String BASKET_THREE = "AB_MNRN-S-003"
	private static final String BASKET_FOUR = "JBPM-S-004"
	private static final String BASKET_FIVE = "JBPM-B-005"
	private static final String BASKET_SIX = "JBWMC-S-006"
	private static final String BASKET_SEVEN = "GE_CDP-S-007"

	@Before
	public void load_database() {
		def sql = getConnection()
		RunScript.execute(sql.getConnection(), new FileReader("sql/master_detail_tables.sql"))
	}

	
	@Test
	public void should_insert_only_records_that_are_not_in_trades() {
		def map = remove_summary_and_insert_again(REPORT_DATE, BASKET_SEVEN)
		assert map != null
		assert 5 == map.size()
		assert false == map.isEmpty()
		assert 405 == map.get(BASKET_THREE)
		assert 10 == map.get(BASKET_FOUR)
		assert 7 == map.get(BASKET_FIVE)
		assert 1 == map.get(BASKET_SIX)
		assert 117 == map.get(BASKET_SEVEN)
	}
	
	@Test
	public void should_keep_same_amount_of_records_for_intech() {
		String intech = "am20121108-B-itg"
		def map = remove_summary_and_insert_again("20121108", intech)
		assert map != null
		assert 9 == map.size()
		assert 90 == map.get(intech)
		assert 101 == map.get("am20121108-S-itg")
	}
	
	

	
	private def remove_summary_and_insert_again(String tradedate, String basketName, String fileName = "_Executions_US_1.csv") {
		def map = [:]
		def sql = getConnection()
		String deleteDetails = "delete tbltradesdetail where tradedate = ? and ems_name = ?"
		def itg = EMS.ITG
		sql.execute(deleteDetails, [tradedate, itg.getName()])

		def date = DateUtils.getDateTime(tradedate)

		def service = new DetailsService()
		service.process("test-files/"+tradedate+fileName, date.toDate(), itg)

		//Insert summary

		def delete = "DELETE tblTrades where TradeDate = ?"
		sql.execute(delete,[tradedate])

		assert summaryRepository.insert(date.toDate(), EMS.ITG)

		def query = "select Source, COUNT(*) as total from tbltrades where TradeDate = ? group by Source order by source"

		sql.eachRow(query, [tradedate]) { record ->
			map[record.Source] = record.total
		}
		def deleteBaskets = "delete tblTrades where TradeDate = ? and source not in (?)"


		sql.execute(deleteBaskets,[tradedate, basketName])

		assert summaryRepository.insert(date.toDate(), EMS.ITG)

		def queryTotal = "select Source, COUNT(*) as total from tbltrades where TradeDate = ? group by Source order by total"
		def filesWithTotals = [:]
		sql.eachRow(queryTotal, [tradedate]) { record ->
			filesWithTotals[record.Source] = record.total
		}
		sql.close()
		return filesWithTotals
	}

	private def getConnection() {
		return Sql.newInstance("jdbc:h2:mem:intranet;MODE=MSSQLSERVER", "sa", "sa", "org.h2.Driver")
	}
}
