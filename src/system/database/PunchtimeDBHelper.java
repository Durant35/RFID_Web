package system.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class PunchtimeDBHelper{
	// ����ȫ�������ַ���
	private static final String DRIVER = "com.mysql.jdbc.Driver"; 
	// ���ݿ���
	private static final String DBNAME = "rfid"; 
	// ����
	private static final String TBNAME = "timerecords"; 
	// JDBC-MySQL�����ַ���
	private static final String CONNSTR = "jdbc:mysql://localhost:3306/" + DBNAME;
	
	public static final int PAGE_SIZE = 8;
	
	Connection conn = null;
	
	public PunchtimeDBHelper(){
		// ע������
		try {
			Class.forName(DRIVER);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		// ͨ��������������ȡ����
		try {
			this.conn = DriverManager.getConnection(CONNSTR, "root", "chenshj35");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public ArrayList<String> getTimeRecordsByCardId(String cardId) {
		ArrayList<String> timeRecords = null;
		if(null != this.conn){
			Statement stmt = null;
			ResultSet result = null;
			try {
				// ��ȡ������
				stmt = this.conn.createStatement();
				String sql = "select * from "+ TBNAME + " where UID=\'" + cardId + "\'";
				
				// ���������󣬲����ؽ��
				result = stmt.executeQuery(sql);
				boolean first = true;
				while(result.next()){
					if(first){
						timeRecords = new ArrayList<String>();
						first = false;
					}
					
					String punchTime = result.getString("punchTime");
					timeRecords.add(punchTime);
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
		return timeRecords;
	}
	
	public ArrayList<String> getTimeRecordsByPage(String cardId, int pageNum){
		ArrayList<String> timeRecords = null;
		if(null != this.conn){
			PreparedStatement prestmt = null;
			ResultSet result = null;
			try {
				// ��ȡ������
				String sql = "select * from "+ TBNAME 
					+ " where UID=? order by punchTime desc limit ?,?";
				prestmt = this.conn.prepareStatement(sql);
				
				prestmt.setString(1, cardId);
				prestmt.setInt(2, (pageNum-1)*PAGE_SIZE);
				prestmt.setInt(3, PAGE_SIZE);
				
				// ���������󣬲����ؽ��
				result = prestmt.executeQuery();
				boolean first = true;
				while(result.next()){
					if(first){
						timeRecords = new ArrayList<String>();
						first = false;
					}
					
					String punchTime = result.getString("punchTime");
					timeRecords.add(punchTime);
				}
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
				if(null != result){
					try {
						result.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
		}
		return timeRecords;
	}
	
	public int getCountByCardId(String cardId){
		int count = 0;
		if(null != this.conn){
			Statement stmt = null;
			ResultSet result = null;
			try {
				// ��ȡ������
				stmt = this.conn.createStatement();
				String sql = "select count(*) from "+ TBNAME + " where UID=\'" + cardId + "\'";
				
				// ���������󣬲����ؽ��
				result = stmt.executeQuery(sql);
				if(result.next()){
					count = result.getInt(1);
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
		return count;
	}
	
	// ��������ǰ�ͷ�����
	@Override
	protected void finalize() throws Throwable {
		if(null != this.conn)
			this.conn.close();
		
		super.finalize();
	}

}
