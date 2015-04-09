package com.guzman.unx.eod.details.valueobjects
/**
 * Guzman and Company Copyrights 2011-2013
 * Created on: Sep 30, 2011
 * Programmer: marcelo
 */
import groovy.util.logging.Log4j;

import java.util.List;

import com.guzman.core.validation.Validation;
import com.guzman.unx.eod.details.domain.EodRecord;
import com.guzman.unx.eod.trades.valueobjects.EMS


/**
 * @author marcelo
 * Gets the file and upload them as an object
 */
@Log4j
class FileService {
	
	private FileService(){

	} //immutable

	public static List<EodRecord> getAllRecords(String fileLocation, EMS ems) {
		
				
		
		switch(ems){
			case ems.INTERNATIONAL: 
				FileServiceITG.getAllRecords( fileLocation, ems)
				break;
			case ems.ITG:
				FileServiceITG.getAllRecords( fileLocation, ems)
				break;
			case ems.INSTINET:
				FileServiceITG.getAllRecords( fileLocation, ems)
				break;
			case ems.INSTINET_INTL:
				FileServiceITG.getAllRecords(fileLocation, ems)
				break;
			default: 
				throw new IllegalArgumentException("Invalid EMS !")
			
		}
		
	}
	
	public static boolean doAllRecordsHaveASourceName(List<EodRecord> records) {
		boolean isValid = true
		records.find{ record ->
			if(record != null && Validation.isEmpty(record.listId)) {
				log.error("This record do not have a listId (basket name): " + record)
				isValid = false
				return true
			}
		}
		return isValid
	}
		
}
