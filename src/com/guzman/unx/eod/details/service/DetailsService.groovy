/**
 * Guzman and Company Copyrights 2011-2013
 * Created on: Sep 30, 2011
 * Programmer: marcelo
 */
package com.guzman.unx.eod.details.service
import com.guzman.core.validation.Validation;
import com.guzman.unx.eod.details.repository.DetailsRepository
import com.guzman.unx.eod.details.valueobjects.FileService
import com.guzman.unx.eod.trades.valueobjects.EMS;

import groovy.util.logging.Log4j;
/**
 * @author marcelo
 * Gets a file and uploads it into the database
 */

@Log4j
final class DetailsService {
	private final DetailsRepository detailsRepository
	private DetailsService() {
		this.detailsRepository = new DetailsRepository()
	}
	
	
	public static DetailsService valueOf() {
		return new DetailsService()
	}
	
	public boolean process(String location, Date date, EMS ems) {
		if(Validation.isEmpty(location)) {
			throw new NullPointerException("The file location cannot be null")
		}
		log.debug("About to start processing the file with EMS: ${ems}")
		def records = FileService.getAllRecords(location, ems)
		if(Validation.isEmpty(records)) {
			log.warn "The file ${location} does not contain any records using EMS: ${ems}"
			return true
		}
		if(!FileService.doAllRecordsHaveASourceName(records)) {
			log.error("One of the records do not have a basket name in file: ${location}")
			throw new IllegalArgumentException("One of the records do not have a basket name in path ${location}")
		}
		detailsRepository.insert(records, date)
		return true
	}
	
	public def getAllUnknownDestinations(Date date, EMS ems) {
		return detailsRepository.getNonExistingDestinations(date, ems)
	}
}
