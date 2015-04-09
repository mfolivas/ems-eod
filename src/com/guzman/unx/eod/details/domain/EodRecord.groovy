/**
 * Guzman and Company Copyrights 2011-2013
 * Created on: Sep 30, 2011
 * Programmer: marcelo
 */
package com.guzman.unx.eod.details.domain

import groovy.transform.Immutable
import groovy.util.logging.Log4j

import com.guzman.unx.eod.details.service.mapper.RecordMapperFactory
import com.guzman.unx.eod.details.valueobjects.EodRecordList
import com.guzman.unx.eod.trades.valueobjects.EMS
/**
 * @author marcelo
 * Stores all the records from the file
 */

@Log4j
@Immutable
final class EodRecord {
	String unxOrderId, msgType, orderStatus
	String execTransType, guzmanClientOrderId
	String originalGuzClientOrderId, unxClientOrderId
	String originalUnxClientOrderId, tradeDate
	String listId, symbol, idSource
	String securityId
	String side
	Long shares
	String orderType, priceClientLimit, priceBenchMark
	Double price
	String exchange, tif, destId, clearingBroker
	String mPid, algoStrategy, algoParameters,unxWaveId
	Long waveShares
	String waveOrderType, waveLimitPrice,waveTif, exchangeExecId,unxExecId, exchangeRefExecId, unxExecRefId
	Long lastShares
	Double lastPrice
	String orderReceived
	String dateTimeRouted, executionTime
	Long tradeId
	String source
	Long sharesTraded, sharesAllocated, exSystemId
	String liquidity
	EMS ems
	String clientName, clientNetwork
	
	public static EodRecord valueOf (String[] records, EMS ems) {
		if(records == null || records.size() < 1 || ems == null) {
			log.error("There records are empty and cannot process")
			throw new NullPointerException("The records are empty and cannot process")
		}
		return RecordMapperFactory.valueOf(records, ems)
	}
	
	/**
	 * This will return a list of the record to insert into the batch
	 * @return
	 */
	public def getList() {
		return EodRecordList.getList(this)
	}
}
