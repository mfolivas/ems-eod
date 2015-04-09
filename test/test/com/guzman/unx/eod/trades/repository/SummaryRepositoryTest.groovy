package test.com.guzman.unx.eod.trades.repository;

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
	
	
	private def insert_records_in_detail_and_summary_and_return_source_with_totals(String tradedate, String fileName = "_Executions_US_1.csv") {
		def sql = null
		def map = [:]
		try {
			sql = Sql.newInstance("jdbc:sqlserver://gts10:1433;databaseName=intranet", "dbuser",
				"bloody", "com.microsoft.sqlserver.jdbc.SQLServerDriver")
			
			//delete and insert records in the details
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
				println record
				map[record.Source] = record.total
			}
		} catch (Exception e) {
			throw e
		} finally {
			if(sql != null) {
				sql.close()
			}
		} 
		
		return map		
	}
	
	
	private def remove_summary_and_insert_again(String tradedate, String basketName, String fileName = "_Executions_US_1.csv") {
		insert_records_in_detail_and_summary_and_return_source_with_totals(tradedate, fileName)
		def delete = "DELETE tblTrades where TradeDate = ? and source not in (?)"
		
		def sql = Sql.newInstance("jdbc:sqlserver://gts10:1433;databaseName=intranet", "dbuser",
			"bloody", "com.microsoft.sqlserver.jdbc.SQLServerDriver")
		sql.execute(delete,[tradedate, basketName])
		
		def date = DateUtils.getDateTime(tradedate)
		assert summaryRepository.insert(date.toDate(), EMS.ITG)
		
		def query = "select Source, COUNT(*) as total from tbltrades where TradeDate = ? group by Source order by total"
		def map = [:]
		sql.eachRow(query, [tradedate]) { record ->
			map[record.Source] = record.total
		}
		sql.close()
		return map
	}
}
