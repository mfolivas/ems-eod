/**
 * Guzman and Company Copyrights 2011-2013
 * Created on: Sep 30, 2011
 * Programmer: marcelo
 */
package com.guzman.unx.eod.details.valueobjects

import com.guzman.core.properties.utils.PropertiesUtils;
import com.guzman.unx.eod.details.domain.FileName;
import com.guzman.core.validation.Validation

import java.text.SimpleDateFormat

/**
 * @author marcelo
 * Gets the file name
 */
final class FileNameService {
	private static final PropertiesUtils props = PropertiesUtils.getDefault()
	private static final SimpleDateFormat FORMAT = new SimpleDateFormat("yyyyMMdd")
	private FileNameService() {}
	
	public static String getFileName() {
		return getFileName(new Date())
	}	
	
	public static FileName createFileName(String name){	
		if(Validation.isEmpty(name)) throw new NullPointerException("File Name is Empty !")
		String dir = props.get("unx.eod.file.location")		
		def fileName = new FileName(name, dir)		
		return fileName
	}
}
