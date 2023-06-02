package vo;

public class IdList {
	private String id;
	private String lastPw;
	private String active;
	private int idLevel;
	private String createdate;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getLastPw() {
		return lastPw;
	}
	public void setLastPw(String lastPw) {
		this.lastPw = lastPw;
	}
	public String getActive() {
		return active;
	}
	public void setActive(String active) {
		this.active = active;
	}
	public int getLevel() {
		return idLevel;
	}
	public void setLevel(int level) {
		this.idLevel = level;
	}
	public String getCreatedate() {
		return createdate;
	}
	public void setCreatedate(String createdate) {
		this.createdate = createdate;
	}
	
	
}
