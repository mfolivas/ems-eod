package com.guzman.unx.eod.details.domain

import com.guzman.core.validation.Validation;

import groovy.transform.Immutable

@Immutable
final class ClientInfo {
	String clientName, clientNetwork
	
	public static ClientInfo valueOf(String clientName, clientNetwork) {
		if(Validation.isEmpty(clientName)) {
			throw new IllegalArgumentException("The clientName cannot be empty")
		}
		return new ClientInfo(clientName, clientNetwork)
	}
}
