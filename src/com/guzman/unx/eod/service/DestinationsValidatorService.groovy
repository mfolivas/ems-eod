package com.guzman.unx.eod.service

import org.apache.log4j.Logger

import com.guzman.unx.eod.details.service.DetailsService
import com.guzman.unx.eod.details.valueobjects.FileNameService


class DestinationsValidatorService {
	private final DetailsService detailService
	private static Logger log = Logger.getLogger(DestinationsValidatorService.class)
	
	/**
	 * Check that all the destinations have a valid name in our broker table
	 * @param date
	 * @param filename
	 */
	public static void validateThatAllRecordsHaveADestiantions(Date date, String filename) {
		log.debug "Validating that all destinations are valid"
		def file = FileNameService.createFileName(filename)
		def detailService = DetailsService.valueOf()
		def records = detailService.getAllUnknownDestinations(date, file.getEms())
		if(records == null || records.isEmpty()) {
			log.debug "All records have valid destination id"
		}
		else {
			log.error "There are unknow destinations in date ${date}. The destinations and the total are: " + records
		}
	}
}
