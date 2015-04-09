package com.guzman.unx.eod.details.service.mapper

import groovy.util.logging.Log4j;

import com.guzman.core.validation.Validation;
import com.guzman.unx.eod.details.domain.EodRecord;
import com.guzman.unx.eod.trades.valueobjects.EMS;

@Log4j
final class RecordMapperFactory {
	private RecordMapperFactory() {} //immutable

	public static EodRecord valueOf (String[] records, EMS ems) {
		if(Validation.isEmpty(records) || ems == null) {
			log.error("There records are empty and cannot process")
			throw new IllegalArgumentException("Records and EMS type cannot be empty")
		}

		switch(ems) {
			case EMS.ITG: return ItgRecordMapper.get(records, ems)
			case EMS.INTERNATIONAL: return ItgRecordMapper.get(records, ems)
			case EMS.INSTINET: return InstinetRecordMapper.get(records, ems)
			case EMS.INSTINET_INTL: return InstinetRecordMapper.get(records, ems)
			default: throw new IllegalArgumentException("The record is not valid. EMS can only be from ITG or Instinet - " + ems)
		}
	}
}
