/**
 * Guzman and Company Copyrights 2011-2013
 * Created on: Oct 3, 2011
 * Programmer: marcelo
 */
package com.guzman.unx.eod.trades.repository

import java.sql.SQLClientInfoException;

import com.guzman.core.date.utils.DateUtils;
import com.guzman.core.properties.utils.PropertiesUtils;
import com.guzman.unx.eod.trades.valueobjects.EMS
import com.guzman.unx.eod.trades.valueobjects.Records;

import static com.guzman.core.properties.utils.PropertiesConstants.*

import groovy.sql.Sql;
import groovy.util.logging.Log4j;

/**
 * @author marcelo
 * We only need to implement the insert query
 */
@Log4j
class SummaryRepository {
	private PropertiesUtils props = PropertiesUtils.getDefault()
	
	private static final String INSERT_TRADE_STATEMENT = 
	'''
	INSERT into tblTrades (tradedate,source,symbol,side,price,SharesTraded,ordertype,DestID,exchange,ClearingBroker,exSystemID)
	SELECT ltrim(rtrim(TradeDate)) as tradedate, listID as source, symbol, 
	case side  
		when '1' then 'B' 
		when '2' then 'S'
		when '3' then 'T'
		when '5' then 'T'
	end as side,
	SUM( lastSh  *   cast(lastpx as Decimal(18,4))  ) /   SUM ( lastSh )  as AVGPRICE,
	SUM (LastSh)  as SHARES,
	'N/A'as ordertype ,0 as DestID, 'N/A' as exchange,'ML'as clearingBroker, 11 as exSystem
	FROM  tbltradesDetail where tradedate = ? and ems_name = ? 
	group by tradeDate, listID, symbol, side
	
	'''
	
	private static final String SUMMARY_INSERT =
	'''
	INSERT into tblTrades (tradedate,source,symbol,side,price,SharesTraded,ordertype,DestID,exchange,ClearingBroker,exSystemID)
	SELECT ltrim(rtrim(TradeDate)) as tradedate,  listID as source, symbol,
	case side 
		when '1' then 'B'
		when '2' then 'S'
		when '3' then 'T'
		when '5' then 'T'
	end as side,
	SUM( lastSh  *   cast(lastpx as Decimal(18,4))  ) /   SUM ( lastSh )  as AVGPRICE,
	SUM (LastSh)  as SHARES,
	'N/A'as ordertype ,0 as DestID, 'N/A' as exchange,'ML'as clearingBroker, 11 as exSystem
	FROM  tbltradesDetail where tradedate = ? 
	AND listId not in (##RECORDS##)
	group by tradeDate, listID, symbol, side
	'''
	
	private static String RECORDS_EXISTS =
	'''
	SELECT source, count(*) as total 
	from tbltrades where tradedate = ? 
	group by source
	''' 
	
	
	public boolean insert(Date date, EMS ems) {
		boolean processed = true
		def sql = null
		try {
			sql = getConnection()
			String formatDate = DateUtils.getDate(date)
			log.debug("Inserting into trades for " + ems)
			def records = getExistingRecords(date, ems)
			if(!records.isEmpty()) {
				log.debug("There are records in the table trades which were entered manually! The records are the following: " + records + ". We are going to ignore these records and insert the ones that are not there.")
				String sqloutput = Records.getSqlWithRecordOmmittedPopulated(SUMMARY_INSERT, records, "##RECORDS##")
				log.debug("About to process the SQL with the tradedate: ${formatDate}:\n" + sqloutput)
				sql.execute sqloutput, [formatDate]
			}
			else {
				log.debug("There are no records in the trade table. Inserting all from the details table to trades")
				sql.execute INSERT_TRADE_STATEMENT, [formatDate, ems.getName()]
			}
			 
			log.debug("Finished inserting into trades")
		} catch (Throwable e) {
			processed = false
			log.error("There was an error when inserting transactions into the trades using query:\n${INSERT_TRADE_STATEMENT}", e)
			e.printStackTrace()
		} finally {
			if(sql != null) {
				sql.close()
			} 
		}
		return processed
	}
	
	public def getExistingRecords(Date date, EMS ems) {
		def sql = null
		def records = [:]
		try {
			sql = getConnection()
			String formatDate = DateUtils.getDate(date)
			log.debug("Checking if there are any records in trades (summary)")
			sql.eachRow(RECORDS_EXISTS, [formatDate]) {
				records[it.source] = it.total
			}
		} catch (Throwable e) {
			log.error("There was an error when inserting transactions into the trades using query:\n${INSERT_TRADE_STATEMENT}", e)
		} finally {
			if(sql != null) {
				sql.close()
			}
		}
		return records
	} 
	
	private Sql getConnection() {
		def sql = Sql.newInstance(props.get(JDBC_URL), props.get(JDBC_USER),
			props.get(JDBC_PASSWORD), props.get(JDBC_DRIVER))
		return sql
	}
}
