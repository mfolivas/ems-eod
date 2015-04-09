/**
 * Guzman and Company Copyrights 2011-2013
 * Created on: Oct 12, 2011
 * Programmer: marcelo
 */
package com.guzman.unx.eod.main

import org.apache.log4j.Logger
import org.apache.log4j.xml.DOMConfigurator

import com.guzman.unx.eod.service.EodService
import com.guzman.unx.eod.service.MultipleEODFileService;
import com.guzman.core.validation.Validation
/**
 * @author marcelo
 * Application reads a CSV file and stores it into the database.
 */
class EodServiceMain {
	private static final Logger log = Logger.getLogger(EodServiceMain.class)
	static main(args) {
		//Load the configuration file for the logger
		String logPropertiesFile = "conf/log4j.xml";
		DOMConfigurator.configure(logPropertiesFile);
		log.debug("Loaded the log4j configurationfiles")
		//Validate that there is a file name as a parameter
		if(Validation.isEmpty(args)){
			log.debug("------------------------------- LODING EOD FILE INTO THE DB -------------------------------")
			MultipleEODFileService.processAllFiles()
			log.debug("------------------------------- LOADING EOD FINISHED -------------------------------")		
		}
		else {
			String fileName = args[0]
			def service = EodService.getInstance()
			log.debug("------------------------------- LODING EOD FILE INTO THE DB -------------------------------")
			service.process(fileName)
			service.validateUnknownDestinations(fileName)
			log.debug("------------------------------- LOADING EOD FINISHED -------------------------------")
		}
		
	}

}
