package com.guzman.unx.eod.service

import groovy.util.logging.Log4j

import com.guzman.core.date.utils.DateUtils
import com.guzman.core.properties.utils.PropertiesUtils
import com.guzman.unx.eod.details.service.DetailsService
import com.guzman.unx.eod.details.valueobjects.FileNameService
import com.guzman.unx.eod.trades.repository.SummaryRepository

/**
 * Services takes care of checking if file exists, populating the database
 * @author marcelo
 *
 */
@Log4j
final class EodService {
	private final SummaryRepository summaryRepository
	private final DetailsService detailService
	private PropertiesUtils props = PropertiesUtils.getDefault()
	
	private EodService() {
		this.summaryRepository = new SummaryRepository()
		this.detailService = DetailsService.valueOf()
	} 
	
	public static EodService getInstance() {
		return new EodService()
	}
	
	public boolean process(String date, String fileName) {
		log.debug("About to process the EOD for the trade date: " + date)
		def datetime = DateUtils.getDateTime(date)
		def incomingDate = datetime.toDate()
		return process(incomingDate, fileName)
	}
	
	public boolean process(String fileName) {
		return process(new Date(), fileName)
	}
	
	public void validateUnknownDestinations(String fileName) {
		validateUnknownDestinations(new Date(), fileName)
	}
	
	public void validateUnknownDestinations(Date date, String fileName) {
		String dateFormatted = DateUtils.getDate(date)
		DestinationsValidatorService.validateThatAllRecordsHaveADestiantions(dateFormatted, fileName)
	}
	
	
	public boolean process(Date date, String fileName) {
		log.debug("Started processing file with name: " + fileName)
		def file = FileNameService.createFileName(fileName)
		String fileWithFullPath = file.getFileNameWithPath()
		log.debug("Using the following file: " + fileWithFullPath + " and the file has been identified as: " + file.getEms())
		boolean processed = detailService.process(fileWithFullPath, date, file.getEms())
		if(!processed) {
			log.error("There was a problem when processing the records in the table details - tbltradesdetail")
			throw new IllegalArgumentException("There was an error processing the records in tbltradesdetail")
		}
		processed = summaryRepository.insert(date, file.getEms())
		log.debug("Finished processing the " + file.getEms() + " upload")
		return processed
	}
}
