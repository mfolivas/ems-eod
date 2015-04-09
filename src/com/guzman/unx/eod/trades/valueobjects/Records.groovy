package com.guzman.unx.eod.trades.valueobjects

import com.guzman.core.validation.Validation;

final class Records {
	private Records() {}//immutable
	
	public static String getRecordsWithSqlFormat(def map) {
		if(Validation.isEmpty(map)) {
			throw new NullPointerException("The map cannot be null")
		}
		String output = ""
		def keys = map.keySet()
		keys.eachWithIndex { obj, i ->
			if(i == 0) {
				output += "'${obj}'"
			}
			else {
				output += ",'${obj}'"
			}
		}
		return output
	}
	
	public static String getSqlWithRecordOmmittedPopulated(String sql, def map, String replace) {
		if(Validation.isEmpty(sql) || Validation.isEmpty(map) || Validation.isEmpty(replace)) {
			throw new IllegalArgumentException("The sql and the map cannot be null")
		}
		def records = getRecordsWithSqlFormat(map)
		return sql.replaceAll(replace, records)
	}
}
