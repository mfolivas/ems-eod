package com.guzman.unx.eod.details.service.mapper

import com.guzman.unx.eod.details.domain.ClientInfo;
import com.guzman.unx.eod.details.domain.EodRecord
import com.guzman.unx.eod.details.domain.FetchRecordValue;
import com.guzman.unx.eod.trades.valueobjects.EMS;

import static com.guzman.unx.eod.details.valueobjects.InstinetValuePosition.*

public final class InstinetRecordMapper {
	private InstinetRecordMapper() {} // immutable
	
	public static EodRecord get(String[] records, EMS ems) {
		String clientName = FetchRecordValue.getInstinetString(records, CLIENT_NAME)
		String clientNetwork = FetchRecordValue.getInstinetString(records, CLIENT_NETWORK)
		ClientInfo clientInfo = ClientInfo.valueOf(clientName, clientNetwork)
		
		String orderId = FetchRecordValue.getInstinetString(records, EMS_ORDER_ID) 
		String clientOrderId = FetchRecordValue.getInstinetString(records, CLORDID) //the ClOrdID sent by client's OMS
		String originalClientOrderId = FetchRecordValue.getInstinetString(records, ORIGCLORDID)
		String instinetClientOrderId = FetchRecordValue.getInstinetString(records, EMSCLORID)
		String originalEmsClientOrderId = FetchRecordValue.getInstinetString(records, ORIG_EMS_CLORDID)
		String tradeDate = FetchRecordValue.getInstinetString(records, TRADEDATE)
		String listId = FetchRecordValue.getInstinetString(records, LISTID)
		if(listId.size() > 50){
			listId = listId.substring(0,49)
		}
		//No US
		String symbol = FetchRecordValue.getInstinetString(records, SYMBOL).replace(" US", "")
		String idSource = FetchRecordValue.getInstinetString(records, ID_SOURCE)
		String securityId = FetchRecordValue.getInstinetString(records, SECURITY_ID)
		String side = FetchRecordValue.getInstinetString(records, SIDE)
		String exchange = FetchRecordValue.getInstinetString(records, PRIMARY_EXCHANGE)
		Long shares = FetchRecordValue.getInstinetLong(records, CLIENT_SHARES)
		String orderType = FetchRecordValue.getInstinetString(records, CLIENT_ORDER_TYPE)
		String priceClientLimit = FetchRecordValue.getInstinetString(records, CLIENT_LMT_PX)
		String tif = FetchRecordValue.getInstinetString(records, CLIENT_TIF)
		String destId = FetchRecordValue.getInstinetString(records, DESTINATION)
		String clearingBroker = FetchRecordValue.getInstinetString(records, EXEC_BROKER)
		String mPid = FetchRecordValue.getInstinetString(records, MPID)
		String algoStrategy = FetchRecordValue.getInstinetString(records, ALGO_STRATEGY)
		String algoParameters = FetchRecordValue.getInstinetString(records, ALGO_PARAMETERS)
		String waveId = FetchRecordValue.getInstinetString(records, WAVE_ID)
		Long waveShares = FetchRecordValue.getInstinetLong(records, WAVE_SHARES)
		String waveOrderType = FetchRecordValue.getInstinetString(records, WAVE_ORDER_TYPE)
		String waveLimitPrice = FetchRecordValue.getInstinetString(records, WAVE_LMT_PX)
		String waveTif = FetchRecordValue.getInstinetString(records, WAVE_TIF)
		String execId = FetchRecordValue.getInstinetString(records, EXEC_ID)
		Long lastShares = FetchRecordValue.getInstinetLong(records, LASTSH)
		Double lastPrice = FetchRecordValue.getInstinetDouble(records, LASTPX)
		
		
		String orderReceived = FetchRecordValue.getInstinetDateFormatted(records, DATETIME_ORDER_RECEIVED)
		String dateTimeRouted = FetchRecordValue.getInstinetDateFormatted(records, DATETIME_ROUTED)
		String executionTime = FetchRecordValue.getInstinetDateFormatted(records, DATETIME_EXECUTED)

		String rawLiquidity = FetchRecordValue.getInstinetString(records, RAW_LIQUIDITY)
		String lastMkt = FetchRecordValue.getInstinetString(records, LAST_MKT)
		String lastLiquidity = FetchRecordValue.getInstinetString(records, LAST_LIQUIDITY)
		String currency = FetchRecordValue.getInstinetString(records, CURRENCY)

		return new EodRecord(orderId, null, null,
			null, clientOrderId,
			originalClientOrderId, instinetClientOrderId,
			originalEmsClientOrderId, tradeDate,
			listId, symbol, idSource,
			securityId, side,
			shares,
			orderType, priceClientLimit, null,
			null,
			exchange, tif, destId, clearingBroker,
			mPid, algoStrategy, algoParameters,waveId,
			waveShares,
			waveOrderType, waveLimitPrice,waveTif, null,execId, null, null,
			lastShares,
			lastPrice,
			orderReceived,
			dateTimeRouted, executionTime,
			null,
			null,
			null, null, null,
			null, ems, clientInfo.clientName, clientInfo.clientNetwork,
				rawLiquidity, lastMkt, lastLiquidity, currency
		)
	}
}
