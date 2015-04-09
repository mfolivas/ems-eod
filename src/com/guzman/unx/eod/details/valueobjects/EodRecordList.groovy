package com.guzman.unx.eod.details.valueobjects

import com.guzman.core.properties.utils.PropertiesUtils;
import com.guzman.core.validation.Validation;
import com.guzman.unx.eod.details.domain.EodRecord;
import java.text.SimpleDateFormat

final class EodRecordList {
	private static final SimpleDateFormat SECONDS_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
	private EodRecordList() {}
	
	private static PropertiesUtils props = PropertiesUtils.getDefault()
	private static final Integer MAX_STRING_SIZE = Integer.valueOf(props.get("unx.eod.algoparams.string.size"))
	private static final Integer NORMAL_STRING_SIZE = Integer.valueOf(props.get("unx.eod.normal.string.size"))
	
	public static def getList(EodRecord record) {
		/**
		* EMS_Name,EMS_Order_ID,GuzClOrdID,OrigGuzClOrdID,EMSClOrdID,
		* OrigEmsClOrdID,TradeDate,ListID,Symbol,IDsource,
		* SecurityID,Side,Shares,OrderType,PxClientLmt,
		* Pxbenchmark,Exchange,TIF,Destination,ExecutionBroker,
		* MPID,AlgoStrategy,AlgoParameters,WaveID,WaveShares,
		* WaveOrderType,WaveLmtPrx,WaveTIF,ExecID,ExecRefID,
		* LastSh,LastPx,datetime_OrderReceived,datetime_routed,ExecutionTime
		*/
	   def list = []
	   list << record.ems.getName()
	   list << getString(record.unxOrderId)
	   list << getString(record.guzmanClientOrderId)
	   list << getString(record.originalGuzClientOrderId)
	   list << getString(record.unxClientOrderId) //5
	   list << getString(record.originalUnxClientOrderId)
	   list << getString(record.tradeDate)
	   list << getString(record.listId)
	   list << getString(record.symbol)
	   list << getString(record.idSource)	//10
	   list << getString(record.securityId)
	   list << getString(record.side)
	   list << getLong(record.shares)
	   list << getString(record.orderType)
	   list << getString(record.priceClientLimit)//15
	   list << getString(record.priceBenchMark)
	   list << getString(record.exchange)
	   list << getString(record.tif)
	   list << getString(record.destId)
	   list << getString(record.clearingBroker)//20
	   list << getString(record.mPid)
	   list << getString(record.algoStrategy)
	   list << getString(record.algoParameters, MAX_STRING_SIZE)
	   list << getString(record.unxWaveId)
	   list << getLong(record.waveShares)	//25
	   list << getString(record.waveOrderType)
	   list << getString(record.waveLimitPrice)
	   list << getString(record.waveTif)
	   list << getString(record.unxExecId)
	   list << getString(record.unxExecRefId)//30
	   list << getLong(record.lastShares)
	   list << getDouble(record.lastPrice)
	   list << getString(record.orderReceived)
	   list << getString(record.dateTimeRouted)
	   list << getString(record.executionTime)
	   list << getString(record.clientName)
	   list << getString(record.clientNetwork)//37
	   list << getString(record.rawLiquidity)
	   list << getString(record.lastMkt)
	   list << getString(record.lastLiquidity)
	   list << getString(record.currency) //41
	   return list
	}
	
	private static String getString(String value, Integer maxSizeOfString = NORMAL_STRING_SIZE) {
		if(Validation.isEmpty(value) || value.size() <= maxSizeOfString) {
			return Validation.isEmpty(value) ? null : value.trim()
		}
		else {
			return Validation.isEmpty(value) ? null : value.trim().substring(0,maxSizeOfString.intValue())
		}
		
	}
	
	private static String getDouble(Double value) {
		return value == null ? null : value.toString()
	}
	
	private static String getLong(Long value) {
		return value == null ? null : value.toString()
	}
}
