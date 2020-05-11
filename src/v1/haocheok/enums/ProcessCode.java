package v1.haocheok.enums;


public enum ProcessCode {

	/**
	 * 通过
	 */
	Adopt("Adopt","6"),
	
	/**
	 * 驳回
	 */
	Reject("Reject","3"),
	
	/**
	 * 撤回
	 */
	Withdraw("Withdraw","-2");
	
	
	private final String value;
	
	private final String reasonPhrase;
	
	
	private ProcessCode(String value, String reasonPhrase) {
		this.value = value;
		this.reasonPhrase = reasonPhrase;
	}
	
	/**
	 * Return the integer value of this status code.
	 */
	public String value() {
		return this.value;
	}
	
	/**
	 * Return the reason phrase of this status code.
	 */
	public String getReasonPhrase() {
		return reasonPhrase;
	}
	
	@Override
	public String toString() {
		return value;
	}
	
}
