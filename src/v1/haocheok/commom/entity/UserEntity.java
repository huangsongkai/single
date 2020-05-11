package v1.haocheok.commom.entity;

public class UserEntity {

	// 区域id
	private String regionalcode;
	// 用户id
	private String userid;
	// 用户名字
	private String username;
	// 用户角色id
	private String roleid;
	// 用户角色code
	private String rolecode;

	public String getRegionalcode() {
		return regionalcode;
	}

	public void setRegionalcode(String regionalcode) {
		this.regionalcode = regionalcode;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getRoleid() {
		return roleid;
	}

	public void setRoleid(String roleid) {
		this.roleid = roleid;
	}

	public String getRolecode() {
		return rolecode;
	}

	public void setRolecode(String rolecode) {
		this.rolecode = rolecode;
	}

	
}
