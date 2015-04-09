package com.guzman.unx.eod.details.valueobjects
/**
 * Guzman and Company Copyrights 2011-2013
 * Created on: Sep 30, 2011
 * Programmer: marcelo
 */
import org.apache.log4j.Logger;

import com.guzman.core.validation.Validation;
import com.guzman.core.properties.utils.PropertiesUtils;
import com.guzman.unx.eod.details.domain.EodRecord;
import com.guzman.unx.eod.trades.valueobjects.EMS

import groovy.util.logging.Log4j;

/**
 * @author marcelo
 * Gets the file and upload them as an object
 */
class FileServiceITG {
	private static PropertiesUtils props = PropertiesUtils.getDefault()
	private static final String DELIMITER = props.get("itg.eod.split.delimiter")	
	private static final Logger log = Logger.getLogger(FileServiceITG.class)
	private static final String BASIC_DELIMETER = ",";
	private static final int TOTAL_COLUMNS = Integer.parseInt(props.getAt("itg.eod.totalcolumns"))
	private FileService(){

	} //immutable

	public static List<EodRecord> getAllRecords(String fileLocation, EMS ems) {
		List<EodRecord> records = new ArrayList<EodRecord>()
		int counter = 0
		try {
			BufferedReader br = new BufferedReader(new FileReader(fileLocation));
			String line = null;
			
			while ((line = br.readLine()) != null) {
				if(shouldSkip(line)) {
					continue
				}
				if(!line.contains(BASIC_DELIMETER)) {
					throw new IllegalArgumentException("There is an error with the file ${fileLocation}. The delimeter is not \\|")
				}
				
				String[] record = line.split(DELIMITER)

				if(record.size() != TOTAL_COLUMNS) {
					log.error("The records per line should be ${TOTAL_COLUMNS} and instead there are " + record.size() +".1The application cannot be processed!"+
						"\nThe error happened in position: " + counter +" for line: \n" + line)
					throw new IllegalArgumentException("The records per line should be ${TOTAL_COLUMNS} and instead there are " + record.size() +"\n.The application cannot be processed!")
				}
				records.add(EodRecord.valueOf(record, ems));
				counter++
			}
			br.close();
			return records
		} catch (IOException e) {
			log.error("There was an error processing the file: " + fileLocation, e)
			throw new IllegalArgumentException("There was an error when trying to process the file" + fileLocation, e)
		}
	}
	
	public static boolean shouldSkip(String line) {
		boolean shouldSkip = false
		if(Validation.isNotEmpty(line)) {
			shouldSkip = line =~ /(ems_name|ClientName|\,\,\,\,)/
		}
		return shouldSkip
	}
}
