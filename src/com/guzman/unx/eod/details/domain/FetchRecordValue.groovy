/**
 * Guzman and Company Copyrights 2011-2013
 * Created on: Oct 3, 2011
 * Programmer: marcelo
 */
package com.guzman.unx.eod.details.domain

import java.text.ParseException
import java.text.SimpleDateFormat

import com.guzman.core.validation.Validation
import com.guzman.unx.eod.details.valueobjects.ITGValuesPositions
import com.guzman.unx.eod.details.valueobjects.InstinetValuePosition;

/**
 * @author marcelo
 * Retrieves records from the array
 */
final class FetchRecordValue {
	private static final SimpleDateFormat incomingFormat = new SimpleDateFormat("yyyyMMdd-HH:mm:ss")
	private static final SimpleDateFormat outGoingFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
	private FetchRecordValue() {

	}

	public static String getString(String[] records, ITGValuesPositions position) {
		if(Validation.isNotEmpty(records) && records.size() >= position.ordinal() +1) {
			return records[position.ordinal()].trim()
		}
		return null
	}
	
	public static Double getDouble(String[] records, ITGValuesPositions position) {
		if(Validation.isNotEmpty(records) && Validation.isNotEmpty(getString(records, position))) {
			return Double.valueOf(getString(records, position))
		}
		return null
	}

	
	public static Long getLong(String[] records, ITGValuesPositions position) {
		if(Validation.isNotEmpty(records) && Validation.isNotEmpty(getString(records, position))) {
			return Long.valueOf(getString(records, position))
		}
		return null
	}


	public static String getDateFormatted(String[] records, ITGValuesPositions position) {
		String incomingDate = null
		try {
			if(Validation.isNotEmpty(records) && Validation.isNotEmpty(getString(records, position))) {
				incomingDate = getString(records, position)
				def date = incomingFormat.parse(incomingDate)
				return outGoingFormat.format(date)
			}
		} catch (ParseException parseException) {
			throw new IllegalArgumentException("The following date could not be converted: ${incomingDate} located in the record: " + records + " for the record: " + position + " located in position: " + (position.ordinal() +1), parseException)
		}
		return null
	}
	
	
	public static String getInstinetString(String[] records, InstinetValuePosition position) {
		if(Validation.isNotEmpty(records) && records.size() >= position.ordinal() +1) {
			return records[position.ordinal()].trim()
		}
		return null
	}
	
	public static Double getInstinetDouble(String[] records, InstinetValuePosition position) {
		if(Validation.isNotEmpty(records) && Validation.isNotEmpty(getInstinetString(records, position))) {
			return Double.valueOf(getInstinetString(records, position))
		}
		return null
	}

	
	public static Long getInstinetLong(String[] records, InstinetValuePosition position) {
		if(Validation.isNotEmpty(records) && Validation.isNotEmpty(getInstinetString(records, position))) {
			return Long.valueOf(getInstinetString(records, position))
		}
		return null
	}
	
	public static String getInstinetDateFormatted(String[] records, InstinetValuePosition position) {
		String incomingDate = null
		try {
			if(Validation.isNotEmpty(records) && Validation.isNotEmpty(getInstinetString(records, position))) {
				incomingDate = getInstinetString(records, position)
				def date = incomingFormat.parse(incomingDate)
				return outGoingFormat.format(date)
			}
		} catch (ParseException parseException) {
			throw new IllegalArgumentException("The following date could not be converted: ${incomingDate} located in the record: " + records + " for the record: " + position + " located in position: " + (position.ordinal() +1), parseException)
		}
		return null
	}
}
