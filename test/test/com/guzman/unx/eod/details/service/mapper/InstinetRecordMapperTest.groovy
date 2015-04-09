package test.com.guzman.unx.eod.details.service.mapper;

import static org.junit.Assert.*;

import org.junit.Test;

import com.guzman.unx.eod.details.service.mapper.InstinetRecordMapper;
import com.guzman.unx.eod.trades.valueobjects.EMS;

class InstinetRecordMapperTest {

	@Test
	public void should_remove_the_long_listid_and_just_keep_a_short_version() {
		String line = "Guzman & Company,Manual,!1130418000740879,B57hFN:5,B57hFN:5,10418000740879D1,10418000740879D1,20130419,Guzman & Company [andrew.buchner] @ 04/19/13 09:35:43,SABA US,1,784932600,2,PNK,100,,8.2300,DAY,D-H375,STXG,GZML,SmartRouter,,,100,,8.2200,DAY,120092023,100,8.2200,20130419-09:16:59,20130419-09:36:04,20130419-09:37:06"
		String[] records = line.split(",")
		String longListId = "Guzman & Company [andrew.buchner] @ 04/19/13 09:35:43"
		assert longListId.size() > 50
		def emsRecord = InstinetRecordMapper.get(records, EMS.INSTINET)
		assert emsRecord.listId.size() <= 50
		assert longListId != emsRecord.listId
	}
}
