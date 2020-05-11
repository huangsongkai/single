package v1.haocheok.commom.entity;

public class InfoEntity {

	private String UUID;
	private String token;
	private String USERID;
	private String DID;
	private String Mdels;
	private String NetMode;
	private String ChannelId;
	private String ip;
	private String GPS;
	private String GPSLocal;
	private long TimeStart;
	private String AppKeyType;
	private String RequestJson;

	public InfoEntity(String UUID, String token, String USERID, String DID,
			String Mdels, String NetMode, String ChannelId, String ip,
			String GPS, String GPSLocal, String AppKeyType, long TimeStart,
			String RequestJson) {
		super();
		this.UUID = UUID;
		this.token = token;
		this.USERID = USERID;
		this.DID = DID;
		this.Mdels = Mdels;
		this.NetMode = NetMode;
		this.ChannelId = ChannelId;
		this.ip = ip;
		this.GPS = GPS;
		this.GPSLocal = GPSLocal;
		this.TimeStart = TimeStart;
		this.AppKeyType = AppKeyType;
		this.RequestJson = RequestJson;
	}

	public String getRequestJson() {
		return RequestJson;
	}

	public void setRequestJson(String requestJson) {
		RequestJson = requestJson;
	}

	public String getAppKeyType() {
		return AppKeyType;
	}

	public void setAppKeyType(String appKeyType) {
		AppKeyType = appKeyType;
	}

	public String getUUID() {
		return UUID;
	}

	public void setUUID(String uUID) {
		UUID = uUID;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getUSERID() {
		return USERID;
	}

	public void setUSERID(String uSERID) {
		USERID = uSERID;
	}

	public String getDID() {
		return DID;
	}

	public void setDID(String dID) {
		DID = dID;
	}

	public String getMdels() {
		return Mdels;
	}

	public void setMdels(String mdels) {
		Mdels = mdels;
	}

	public String getNetMode() {
		return NetMode;
	}

	public void setNetMode(String netMode) {
		NetMode = netMode;
	}

	public String getChannelId() {
		return ChannelId;
	}

	public void setChannelId(String channelId) {
		ChannelId = channelId;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getGPS() {
		return GPS;
	}

	public void setGPS(String gPS) {
		GPS = gPS;
	}

	public String getGPSLocal() {
		return GPSLocal;
	}

	public void setGPSLocal(String gPSLocal) {
		GPSLocal = gPSLocal;
	}

	public long getTimeStart() {
		return TimeStart;
	}

	public void setTimeStart(long timeStart) {
		TimeStart = timeStart;
	}

}
