package com.guzman.unx.eod.trades.valueobjects;

public enum EMS {
	ITG("ITG"), INTERNATIONAL("ITG_INTL"), INSTINET("INSTINET"), INSTINET_INTL("INSTI_INTL");
	private String name;
	private EMS(String name) {
		this.name = name;
	}
	
	String getName() {
		return name;
	}
}
