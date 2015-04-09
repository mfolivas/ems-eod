/**
 * Guzman and Company Copyright (c) 2012-2013.
 */
package com.guzman.unx.eod.details.domain

import com.guzman.core.validation.Validation;
import com.guzman.unx.eod.trades.valueobjects.EMS
import groovy.transform.Immutable
/**
 * @author marcelo
 * Generates the filename attributes (EMS, path, and actual name of the file)
 */

@Immutable
final class FileName {
	String name, path
	
	public EMS getEms() {
		if(Validation.isEmpty(name)) {
			throw new NullPointerException("The name of the file cannot be null")
		}
		if (name =~ /[0-9]{8}.Executions_US_1/) {
			return EMS.ITG
		}
		else if(name =~ /[0-9]{8}.Executions_[^U][^S]_1/) {
			return EMS.INTERNATIONAL
		}
		else if(name =~ /ClientEODTradeDetail_Guzman_US_[0-9]{8}.csv/) {
			return EMS.INSTINET
		}
		else if(name =~ /ClientEODTradeDetail_Guzman_INTL_[0-9]{8}.csv/) {
			return EMS.INSTINET_INTL
		}
		else{
			throw new IllegalArgumentException("Invalid file with the name: ${name}" )
		}
		
	}
	
	public String getFileNameWithPath() {
		return path + name
	}
}
