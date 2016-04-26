package system.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import system.entity.RFIDCard;

public class RFIDCardDBHelper implements DBHelper {
	// 驱动全局类名字符串
	private static final String DRIVER = "com.mysql.jdbc.Driver"; 
	// 数据库名
	private static final String DBNAME = "rfid"; 
	// 表名
	private static final String TBNAME = "tb_rfidcard"; 
	// JDBC-MySQL连接字符串
	private static final String CONNSTR = "jdbc:mysql://localhost:3306/" + DBNAME; 
	
	Connection conn = null;
	
	public RFIDCardDBHelper(){
		// 注册驱动
		try {
			Class.forName(DRIVER);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		// 通过驱动管理器获取连接
		try {
			this.conn = DriverManager.getConnection(CONNSTR, "root", "chenshj35");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public RFIDCard SearchRFIDCardByCardId(String cardId) {
		RFIDCard card = null;
		if(null != this.conn){
			Statement stmt = null;
			ResultSet result = null;
			try {
				// 获取语句对象
				stmt = this.conn.createStatement();
				String sql = "select * from "+ TBNAME + " where CardId=\'" + cardId + "\'";
				
				// 传递语句对象，并返回结果
				result = stmt.executeQuery(sql);
				if(result.next()){
					String CardType = result.getString("CardType");
					String username = result.getString("username");
					String password = result.getString("password");
					String email = result.getString("Email");
					Timestamp createTime = result.getTimestamp("createTime");
					
					card = new RFIDCard(cardId, CardType, 
							username, password, email, createTime);
				}
				
			} catch (SQLException e) {
				e.printStackTrace();
			} finally{
				if(null != stmt){
					try {
						stmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
				
				if(null != result){
					try {
						result.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
		}
		return card;
	}

	public boolean deleteRFIDCardByCardId(String cardId) {
		int count = 0;
		if(null != this.conn){
			Statement stmt = null;
			try {
				// 获取语句对象
				String sql = "delete from "+ TBNAME + 
					"where CardId=" + cardId;
				stmt = this.conn.createStatement();
				
				// 传递语句对象，并返回结果
				count = stmt.executeUpdate(sql);
			} catch (SQLException e) {
				e.printStackTrace();
			} finally{
				if(null != stmt){
					try {
						stmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
			
		}
		return (count==1);
	}

	public List<RFIDCard> getAllRFIDCards() {
		List<RFIDCard> cards = null;
		
		if(null != this.conn){
			Statement stmt = null;
			ResultSet result = null;
			try {
				// 获取语句对象
				stmt = this.conn.createStatement();
				String sql = "select * from "+ TBNAME;
				
				// 传递语句对象，并返回结果
				result = stmt.executeQuery(sql);
				boolean first = true;
				RFIDCard card = null;
				while(result.next()){
					if(first){
						cards = new ArrayList<RFIDCard>();
						first = false;
					}
					
					String cardId = result.getString("CardId");
					String CardType = result.getString("CardType");
					String username = result.getString("username");
					String password = result.getString("password");
					String email = result.getString("Email");
					if(null == email)
						email = "暂无";
					Timestamp createTime = result.getTimestamp("createTime");
					
					card = new RFIDCard(cardId, CardType, 
							username, password, email, createTime);
					//System.out.println(card.toString());
					cards.add(card);
				}
				//System.out.println(cards.size());
			} catch (SQLException e) {
				e.printStackTrace();
			} finally{
				if(null != stmt){
					try {
						stmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
				
				if(null != result){
					try {
						result.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
			
		}
		return cards;
	}

	public boolean saveRFIDCard(RFIDCard card) {
		int count = 0;
		if(null != this.conn){
			PreparedStatement prestmt = null;
			try {
				// 获取语句对象
				String sql = "insert into "+ TBNAME + 
					"(CardId, username, password, createTime, CardType, Email) values(?, ?, MD5(?), ?, ?, ?)";
				prestmt = this.conn.prepareStatement(sql);
				
				prestmt.setString(1, card.getCardId());
				prestmt.setString(2, card.getUser().getUsername());
				prestmt.setString(3, card.getUser().getPassword());
				prestmt.setTimestamp(4, card.getCreateTime());
				prestmt.setString(5, card.getType());
				prestmt.setString(6, card.getUser().getEmail());
				
				// 传递语句对象，并返回结果
				count = prestmt.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();
			} finally{
				if(null != prestmt){
					try {
						prestmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
			
		}
		return (count == 1);
	}

	public boolean updateRFIDCard(RFIDCard card) {
		int count = 0;
		if(null != this.conn){
			PreparedStatement prestmt = null;
			try {
				// 获取语句对象
				String sql = "update "+ TBNAME + 
					" set username=?, password=MD5(?), createTime=?, CardType=?";
				prestmt = this.conn.prepareStatement(sql);
				
				prestmt.setString(1, card.getUser().getUsername());
				prestmt.setString(2, card.getUser().getPassword());
				prestmt.setTimestamp(3, card.getCreateTime());
				prestmt.setString(4, card.getType());
				
				// 传递语句对象，并返回结果
				count = prestmt.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();
			} finally{
				if(null != prestmt){
					try {
						prestmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
			
		}
		return (count >= 1);
	}
	
	public boolean modifyPWD(String cardId, String newPWD) {
		int count = 0;
		if(null != this.conn){
			PreparedStatement prestmt = null;
			try {
				// 获取语句对象
				String sql = "update "+ TBNAME + " set password=MD5(?) where CardId=?";
				prestmt = this.conn.prepareStatement(sql);
				prestmt.setString(1, newPWD);
				prestmt.setString(2, cardId);
				count = prestmt.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();
			} finally{
				if(null != prestmt){
					try {
						prestmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
			
		}
		return (count >= 1);
	}
	
	public boolean modifyEmail(String cardId, String newEmail) {
		int count = 0;
		if(null != this.conn){
			PreparedStatement prestmt = null;
			try {
				// 获取语句对象
				String sql = "update "+ TBNAME + " set Email=? where CardId=?";
				prestmt = this.conn.prepareStatement(sql);
				prestmt.setString(1, newEmail);
				prestmt.setString(2, cardId);
				count = prestmt.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();
			} finally{
				if(null != prestmt){
					try {
						prestmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
			
		}
		return (count >= 1);
	}
	
	// 垃圾回收前释放连接
	@Override
	protected void finalize() throws Throwable {
		if(null != this.conn)
			this.conn.close();
		
		super.finalize();
	}

}
