package com.guzman.unx.eod.service

import groovy.util.logging.Log4j;

import com.guzman.core.properties.utils.PropertiesUtils;
@Log4j
final class MultipleEODFileService {
	private MultipleEODFileService() {} //immutable
	
	public static processAllFiles() {
		def eodService = EodService.getInstance()
		//Get all EOD files, process first domestic, and then the rest
		String location = PropertiesUtils.get("unx.eod.file.location")
		log.debug("processing international transactions")
		new File(location).eachFile { file ->
			if(file.name =~/[0-9]{8}.Executions_[^US]/) {
				log.debug("processing file: ${file.name}") 
				eodService.process(file.name)
			}
			
		}
		log.debug("Processed all files")
	}
}
