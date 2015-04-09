package test.com.guzman.unx.eod.details.repository;

import static org.junit.Assert.*
import groovy.sql.Sql

import org.joda.time.DateTime
import org.junit.Test

import com.guzman.core.date.utils.DateUtils
import com.guzman.unx.eod.details.domain.EodRecord
import com.guzman.unx.eod.details.repository.DetailsRepository
import com.guzman.unx.eod.details.valueobjects.FileServiceITG;
import com.guzman.unx.eod.trades.valueobjects.EMS

class DetailsRepositoryTest {
	
	
	@Test
	public void should_insert_all_records_into_the_db() {
		def sql = Sql.newInstance("jdbc:sqlserver://gts10:1433;databaseName=intranet",
			"dbuser", "bloody","com.microsoft.sqlserver.jdbc.SQLServerDriver")
		sql.execute("DELETE FROM tblTradesDetail where tradedate = '20121015'")
		sql.close()
		def repository = new DetailsRepository()
		DateTime tradeDate = DateUtils.getDateTime("20121015")
		def fileLocation = "test-files/SMALL20121015.csv"
		def records = FileServiceITG.getAllRecords(fileLocation, EMS.ITG)
		repository.insert(records, tradeDate.toDate())
	}
	
	@Test
	public void should_be_able_to_insert_raw_record() {
		String line = "ITG,80143179,20120921C00000410,,265.1624.1,265.1624.1,20121015,JBPM-B-005,UTX,2,2915500,1,2400,1,0,NYS,Day,CSEX,CSEX,GZML,INLINE,(0 - 99%)=15|(0 - 99%)=7|Auction=Default|Execution Style=Normal,80143211,1000,1,0,Day,474-20120921,-1,100,81.0199,20120921-12:48:00,20120921-12:49:30,20120921-12:49:52"
		insert_into_the_db(line)
	}
	
	public void insert_into_the_db(String line) {
		def sql = Sql.newInstance("jdbc:sqlserver://gts10:1433;databaseName=intranet",
			"dbuser", "bloody","com.microsoft.sqlserver.jdbc.SQLServerDriver")
		sql.execute("DELETE FROM tblTradesDetail where tradedate = '20120118'")
		
		String[] record = line.split(",")
		def unxRecord = EodRecord.valueOf(record, EMS.ITG)
		def list = unxRecord.getList().toList()
		sql.execute(DetailsRepository.INSERT_INTO_DETAILS, list)
		sql.close()
	}
}
