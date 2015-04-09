package test.com.guzman.unx.eod.details.valueobjects;

import static org.junit.Assert.*;

import org.junit.Test;

import com.guzman.unx.eod.details.domain.EodRecord;
import com.guzman.unx.eod.trades.valueobjects.EMS;

class EodRecordListTest {
	
	@Test
	public void should_keep_hundred_characters_in_algo_parameter() {
		String line = "TIAA-CREF (G754),Instinet,!1130405005590026,10405005567373D1,10405005567373D1,10405005590026D1,10405005590026D1,20130408,1130405005567374,HUB/B US,1,443510201,2,NYQ,160,ATC,0.0000,ATC,G-GSACHSALGOS,GSET,GZML,SOR,,,160,ATC,0.0000,DAY,171931907,160,94.4400,20130408-12:49:11,20130408-12:50:45,20130408-16:02:37"
		String[] records = line.split(",")
		def rec = EodRecord.valueOf(records, EMS.INSTINET)
		String[] list = rec.getList()
		String clientName = list[35]
		String clientNetwork = list[36]
		println clientName
		println clientNetwork
	}

	@Test
	public void should_have_the_extra_four_fields_at_the_end() {
		String line = "AJO,,!1150326005822743,153951111-201503270096,153951111-201503270096,10326005822743D1,10326005822743D1,20150327,AJO1,CBL US,1,124830100,2,NYQ,4700,1,0.0000,DAY,G-TRADEWARE42BNHUB,DS01,GZML,Guzman Market Trader (via Tradeware),,,4700,,0.0000,DAY,170556549,100,19.4900,20150327-10:24:48,20150327-10:25:18,20150327-10:27:22,,DBAX,,USD"
		String[] records = line.split(",")
		def rec = EodRecord.valueOf(records, EMS.INSTINET)
		String[] list = rec.getList()

		println rec.clientNetwork

		String rawLiquidity = list[37]
		assert rawLiquidity == null
		assert rec.rawLiquidity == ""
		String lastMkt = list[38]
		assert lastMkt == "DBAX"
		assert lastMkt == rec.lastMkt

		String lastLiquidity = list[39]
		assert lastLiquidity == null
		assert rec.lastLiquidity == ""

		String currency = list[40]
		assert currency == "USD"
		assert currency == rec.currency
	}

	@Test
	public void should_have_the_extra_four_fields_at_the_end_for_international() {
		String line = "AJO,,!1150326005822743,153951111-201503270096,153951111-201503270096,10326005822743D1,10326005822743D1,20150327,AJO1,CBL US,1,124830100,2,NYQ,4700,1,0.0000,DAY,G-TRADEWARE42BNHUB,DS01,GZML,Guzman Market Trader (via Tradeware),,,4700,,0.0000,DAY,170556549,100,19.4900,20150327-10:24:48,20150327-10:25:18,20150327-10:27:22,,DBAX,,USD"
		String[] records = line.split(",")
		def rec = EodRecord.valueOf(records, EMS.INSTINET_INTL)
		String[] list = rec.getList()

		println rec.clientNetwork

		String rawLiquidity = list[37]
		assert rawLiquidity == null
		assert rec.rawLiquidity == ""
		String lastMkt = list[38]
		assert lastMkt == "DBAX"
		assert lastMkt == rec.lastMkt

		String lastLiquidity = list[39]
		assert lastLiquidity == null
		assert rec.lastLiquidity == ""

		String currency = list[40]
		assert currency == "USD"
		assert currency == rec.currency
	}
}
