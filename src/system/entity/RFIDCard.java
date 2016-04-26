package system.entity;

import java.sql.Timestamp;

/**
 *	用户信息实体类，包括用户个人信息以及卡片信息
 */
public class RFIDCard {
	private String cardId;
	private String type;
	private UserInfo user;
	private Timestamp createTime;
	
	public RFIDCard(String cardId, String type, Timestamp createTime){
		this.cardId = cardId;
		this.type = type;
		this.user = null;
		this.createTime = createTime;
	}
	
	public RFIDCard(String cardId, String type, String username,
				String password, String email, Timestamp createTime){
		this.cardId = cardId;
		this.type = type;
		this.user = new UserInfo(username, password, email);
		this.createTime = createTime;
	}
	
	public String getCardId() {
		return cardId;
	}
	
	public void setCardId(String cardId) {
		this.cardId = cardId;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	public UserInfo getUser() {
		return user;
	}
	
	public void setUser(UserInfo user) {
		this.user = user;
	}
	
	public void setUser(String username, String password, String email) {
		this.user = new UserInfo(username, password, email);
	}
	
	public Timestamp getCreateTime() {
		return createTime;
	}
	
	public void setCreateTime(Timestamp createTime) {
		this.createTime = createTime;
	}
	
	public String toString() {
		return "ID: " + this.cardId + "\n" + 
		       "Card Type: " + this.type + "\n" + 
			   "CreateTime: " + this.createTime + "\n" +
			   this.user.toString();
	}
}
