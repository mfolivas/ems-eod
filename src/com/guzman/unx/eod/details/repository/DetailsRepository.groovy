/**
 * Guzman and Company Copyrights 2011-2013
 * Created on: Sep 30, 2011
 * Programmer: marcelo
 */
package com.guzman.unx.eod.details.repository

import java.util.Date;

import groovy.sql.Sql;
import groovy.util.logging.Log4j;
import static com.guzman.core.properties.utils.PropertiesConstants.*

import com.guzman.core.date.utils.DateUtils;
import com.guzman.core.properties.utils.PropertiesUtils
import com.guzman.core.validation.Validation;
import com.guzman.unx.eod.details.domain.EodRecord;
import com.guzman.unx.eod.trades.valueobjects.EMS
/**
 * @author marcelo
 * Inserts details records into the table
 */
@Log4j
final class DetailsRepository {
	private PropertiesUtils props = PropertiesUtils.getDefault()
	private final String BATCH_SIZE = props.get("unx.eod.batch.size")
	public static final String INSERT_INTO_DETAILS = '''
	insert into tblTradesDetail (  
	EMS_Name,EMS_order_id,GuzClOrdID,       						--3
	OrigGuzClOrdID,EmsClOrdID,OrigEmsClOrdID,TradeDate,ListID, 		--8
	Symbol,IDSource,SecurityID,side,shares,  					    --13
	OrderType,PxClientLmt,   	    	   							--15
	PxBenchmark, Exchange,TIF,Destination,  						--19
	ExecutingBroker,MPID,AlgoStrategy, AlgoParameters,WaveID,   	--24
	WaveShares,WaveOrderType,WaveLmtPrx,WaveTIF, 					--28
	ExecID,ExecRefID,LastSh,LastPx,									--32
	datetime_orderReceived,datetime_routed,ExecutionTime,			--35
	ClientName, ClientNetwork,	 									--37
	RawLiquidity, LastMkt, LastLiquidity, Currency)	 				--41
	values (?,?,?,?,?,?,?,?,?,? --10
			,?,?,?,?,?,?,?,?,?,? --20
			,?,?,?,?,?,?,?,?,?,? --30
			,?,?,?,?,? 			 --35
			,?,?				 --37
			,?,?,?,?)			 --41
    '''
	
	private static final String RECORDS_EXISTS = "select count(*) as total from tblTradesDetail where tradeDate = ? and EMS_Name = ?"
	
	private static String UNKNOW_DESTINATION_RECORDS =
	'''
	select destination, count(*) as total 
	from tbltradesdetail detail 
	where detail.tradedate = ? and detail.ems_name = ?  
	and detail.destination != 'MANUAL' and not exists (
	select null from tblbrokers where detail.destination = destination)
	group by destination
	''' 

	public void insert(List<EodRecord> records, Date tradeDate) {
		if(Validation.isEmpty(records)) {
			log.error("Records are empty")
			throw new NullPointerException("Records cannot be null")
		}
		log.debug("Inserting detail records")
		EMS firstRecord = records.get(0).ems
		//Don't check if there are records for international
		//Most likely, there will be domestic records
		if((firstRecord.equals(EMS.ITG) || firstRecord.equals(EMS.INSTINET)|| firstRecord.equals(EMS.INSTINET_INTL)) && recordsExists(tradeDate, firstRecord)) {
			String tradeDateFormat = DateUtils.getDate(tradeDate)
			log.error("There are records in the table tblTradesDetails for the trade date: " + tradeDateFormat+" along with the EMS: " + ems)
			throw new IllegalArgumentException("There are records in the table tblTradesDetail for the trade date: " + tradeDateFormat + " along with the EMS: " + ems)
		}
		
		def sql = null
		def record = null
		try {
			sql = getConnection()
			int batchsize = Integer.valueOf(BATCH_SIZE).intValue()
			
			log.debug("About to insert a total of: "+records.size() + " records with in batch sizes of: " + batchsize + " for the query\n${INSERT_INTO_DETAILS}")
			sql.withTransaction {
				sql.withBatch(batchsize, INSERT_INTO_DETAILS) { ps ->
					records.eachWithIndex{ inRec, index ->
						record = inRec
						ps.addBatch(record.getList().toList())//40
					}
				}
				record = null
			}
			log.debug "Finished inserting all records"
			
		} catch (Throwable e) {
			log.error("There was an error processing the insert batch using query\n${INSERT_INTO_DETAILS}\nThe error happened in the following record: "+ record.getList(), e)
			throw new IllegalArgumentException("There was an error when processing the transactions using sql: "+ INSERT_INTO_DETAILS , e)
		} finally {
			if(sql != null) {
				sql.close()
			}
		}
	}
	
	private boolean recordsExists(Date tradeDate, EMS ems) {
		def sql = null
		int total = 0
		try {
			sql = getConnection()
			String date = DateUtils.getDate(tradeDate)
			log.debug("Validating if any records exists using the query: ${RECORDS_EXISTS} with param: ${date}")
			sql.eachRow(RECORDS_EXISTS, [date, ems.toString()]) { row ->
				total = row.total
			}	
		} catch (Exception e) {
			log.error("There was an error when executing the following query: ${RECORDS_EXISTS}", e)
			throw new IllegalArgumentException("Error when executing the ${RECORDS_EXISTS} query", e)
		}
		return total > 0
	}
	
	public def getNonExistingDestinations(Date date, EMS ems) {
		def sql = null
		def records = [:]
		try {
			sql = getConnection()
			String formatDate = DateUtils.getDate(date)
			log.debug("Validating if there are records with unknow destination id")
			sql.eachRow(UNKNOW_DESTINATION_RECORDS, [formatDate, ems.toString()]) {
				records[it.source.replaceAll( "${ems}-", "")] = it.total
			}
		}catch(Throwable e) {
			log.error("There was an error when checking the existing destinations", e)
			throw new IllegalArgumentException("There was an error when checking the existing destinations", e)
		} finally {
			if(sql != null) {
				sql.close()
			}
		}
	}
	
	private Sql getConnection() {
		def sql = Sql.newInstance(props.get(JDBC_URL), props.get(JDBC_USER),
			props.get(JDBC_PASSWORD), props.get(JDBC_DRIVER))
		return sql
	}
}
