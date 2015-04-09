package test.com.guzman.unx.eod.details.domain;

import static org.junit.Assert.*;

import org.junit.Test;

import com.guzman.unx.eod.details.domain.ClientInfo;

class ClientInfoTest {

	@Test(expected=IllegalArgumentException.class)
	public void should_return_an_error() {
		ClientInfo.valueOf(null, "")
	}
	
	@Test
	public void should_return_a_valid_client_info() {
		String clientName = "TIAA-CREF (G754)"
		String clientNetwork = "Instinet"
		def clientInfo = ClientInfo.valueOf(clientName, clientNetwork)
		assert clientName == clientInfo.clientName
		assert clientNetwork == clientInfo.clientNetwork
		assert clientInfo == ClientInfo.valueOf(clientName, clientNetwork)
	}
}
