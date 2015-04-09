package test.com.guzman.unx.eod.service

import org.junit.Ignore;

import static org.junit.Assert.*
import groovy.sql.Sql

import org.junit.Test

import com.guzman.unx.eod.service.EodService

class EodServiceTest {
	private static String TEST_URL = "jdbc:sqlserver://gts10:1433;databaseName=intranet"
	private static String PROD_URL = "jdbc:sqlserver://gts11:1433;databaseName=intranet"
	private static String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
	private static String TEST_USER = "dbuser"
	private static String PROD_USER = "dbread"
	private static String PASSWORD ="bloody"
	private static String TRADEDATE_UNX = "20110929"
	private static String TRADEDATES_ITG = "20120626"
	private static String FILENAME_ITG= "20120626_Executions_US_1.csv";
	private static int FILESIZE_UNX= 1228;
	private static int FILESIZE_ITG= 7;
	
	@Test
	public void should_process_records_ITG() {
//		def sql = Sql.newInstance(TEST_URL, TEST_USER, PASSWORD, DRIVER)
//		sql.execute("delete from tblTradesDetail where tradedate = ${TRADEDATES_ITG}")
//		sql.execute("delete from tbltrades where tradedate = ${TRADEDATES_ITG}")
//
//		def service = EodService.getInstance()
//		assert service.process(TRADEDATES_ITG, FILENAME_ITG)
//		should_query_prod_and_test_summary_table_and_all_records_should_match(FILESIZE_ITG)
	}
	
//	public void should_query_prod_and_test_summary_table_and_all_records_should_match(int recordsCounter) {
//		def testRecords = []
//		def sql = Sql.newInstance(TEST_URL, TEST_USER, PASSWORD, DRIVER)
//		String tradeQuery = "select Source,TradeDate,Symbol,Side,SharesTraded,Price,DestID,ExSystemID,Exchange,ClearingBroker from tbltrades where tradedate = '20110929'"
//		sql.eachRow(tradeQuery) {
//			testRecords << it.Source+","+it.TradeDate+","+it.Symbol+","+it.Side+","+it.SharesTraded+","+it.Price+","+it.DestID+","+it.ExSystemID+","+it.Exchange+","+it.ClearingBroker
//		}
//
//		def prod = Sql.newInstance(PROD_URL, PROD_USER, PASSWORD, DRIVER)
//
//		def prodRecors = []
//		prod.eachRow(tradeQuery) {
//			prodRecors << it.Source+","+it.TradeDate+","+it.Symbol+","+it.Side+","+it.SharesTraded+","+it.Price+","+it.DestID+","+it.ExSystemID+","+it.Exchange+","+it.ClearingBroker
//		}
//
//		assert 1228 == testRecords.size()
//		assert prodRecors.size() == testRecords.size()
//		testRecords.each{ tst ->
//			if(!prodRecors.contains(tst)) {
//				fail("The following test record does not exists in prod:\n"+tst)
//			}
//		}
//	}
}
