package com.guzman.unx.eod.details.service.mapper

import groovy.util.logging.Log4j;

import com.guzman.unx.eod.details.domain.EodRecord;
import com.guzman.unx.eod.details.domain.FetchRecordValue;
import com.guzman.unx.eod.details.valueobjects.ITGValuesPositions;
import com.guzman.unx.eod.trades.valueobjects.EMS;

@Log4j
final class ItgRecordMapper {
	private ItgRecordMapper() {} //immutable
	
	
	public static EodRecord get(String[] records, EMS ems) {
		if(records == null || records.size() < 1 || ems == null) {
			log.error("There records are empty and cannot process")
			throw new NullPointerException("The records are empty and cannot process")
		}
		
		String unxOrderId = FetchRecordValue.getString(records, ITGValuesPositions.EMS_ORDER_ID)
		String guzmanClientOrderId = FetchRecordValue.getString(records, ITGValuesPositions.GUZCLORDID)//5
		String originalGuzClientOrderId = FetchRecordValue.getString(records, ITGValuesPositions.ORIGGUZCLORDID)
		String unxClientOrderId = FetchRecordValue.getString(records, ITGValuesPositions.EMSCLORDID)
		String originalUnxClientOrderId = FetchRecordValue.getString(records, ITGValuesPositions.ORIGEMSCLORDID)
		String tradeDate = FetchRecordValue.getString(records, ITGValuesPositions.TRADEDATE)
		String listId = FetchRecordValue.getString(records, ITGValuesPositions.LISTID).replaceAll(" ", "-")//10
		String symbol = FetchRecordValue.getString(records, ITGValuesPositions.SYMBOL)
		String idSource = FetchRecordValue.getString(records, ITGValuesPositions.IDSOURCE)
		String securityId = FetchRecordValue.getString(records, ITGValuesPositions.SECURITYID)
		
		String side = FetchRecordValue.getString(records, ITGValuesPositions.SIDE)
		
		Long shares = FetchRecordValue.getLong(records, ITGValuesPositions.ORDERSHARES)//15
		String orderType = FetchRecordValue.getString(records, ITGValuesPositions.ORDERTYPE)
		String priceClientLimit = FetchRecordValue.getString(records, ITGValuesPositions.PXCLIENTLMT)

		String exchange = FetchRecordValue.getString(records, ITGValuesPositions.PRIMARYEXCHANGE)
		String tif = FetchRecordValue.getString(records, ITGValuesPositions.TIF)//20
		String destId = FetchRecordValue.getString(records, ITGValuesPositions.DESTINATION)
		String clearingBroker = FetchRecordValue.getString(records, ITGValuesPositions.EXECUTINGBROKER)
		String mPid = FetchRecordValue.getString(records, ITGValuesPositions.MPID)
		String algoStrategy = FetchRecordValue.getString(records, ITGValuesPositions.ALGOSTRATEGY)
		String algoParameters = FetchRecordValue.getString(records, ITGValuesPositions.ALGOPARAMETERS)//25
		String unxWaveId = FetchRecordValue.getString(records, ITGValuesPositions.WAVEID)
		
		Long waveShares = FetchRecordValue.getLong(records, ITGValuesPositions.WAVESHARES)
			
		String waveOrderType = FetchRecordValue.getString(records, ITGValuesPositions.WAVEORDERTYPE)
		String waveLimitPrice = FetchRecordValue.getString(records, ITGValuesPositions.WAVELMTPX)
		String waveTif = FetchRecordValue.getString(records, ITGValuesPositions.WAVETIF)
		String unxExecId = FetchRecordValue.getString(records, ITGValuesPositions.EXECID)
		String exchangeRefExecId = FetchRecordValue.getString(records, ITGValuesPositions.EXECREFID)
		
		Long lastShares = FetchRecordValue.getLong(records, ITGValuesPositions.LASTSH)
		Double lastPrice = FetchRecordValue.getDouble(records, ITGValuesPositions.LASTPX)
		
		String orderReceived = FetchRecordValue.getDateFormatted(records, ITGValuesPositions.DATETIME_ORDERRECEIVED)
		
		String dateTimeRouted = FetchRecordValue.getDateFormatted(records,ITGValuesPositions.DATETIME_ROUTED)//35
		String executionTime = FetchRecordValue.getDateFormatted(records,ITGValuesPositions.DATETIME_EXECUTED)
		
		Long tradeId = null
		
		String source = null
		Long sharesTraded = null
		Long sharesAllocated = null
		Long exSystemId = null
		
		
		return new EodRecord(unxOrderId, null, null,
			null, guzmanClientOrderId,
			originalGuzClientOrderId, unxClientOrderId,
			originalUnxClientOrderId, tradeDate,
			listId, symbol, idSource,
			securityId, side,
			shares,
			orderType, priceClientLimit, null,
			null,
			exchange, tif, destId, clearingBroker,
			mPid, algoStrategy, algoParameters,unxWaveId,
			waveShares,
			waveOrderType, waveLimitPrice,waveTif, null,unxExecId, exchangeRefExecId, null,
			lastShares,
			lastPrice,
			orderReceived,
			dateTimeRouted, executionTime,
			tradeId,
			source,
			sharesTraded, sharesAllocated, exSystemId,
			null, ems, null,null)
	}
}
