package system.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class UserDBHelper{
	// ����ȫ�������ַ���
	private static final String DRIVER = "com.mysql.jdbc.Driver"; 
	// ���ݿ���
	private static final String DBNAME = "rfid"; 
	// ����
	private static final String TBNAME = "users"; 
	// JDBC-MySQL�����ַ���
	private static final String CONNSTR = "jdbc:mysql://localhost:3306/" + DBNAME; 
	
	Connection conn = null;
	
	public UserDBHelper(){
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

	public boolean CheckUserByCardId(String cardId) {
		boolean isExist = false;
		if(null != this.conn){
			Statement stmt = null;
			ResultSet result = null;
			try {
				// ��ȡ������
				stmt = this.conn.createStatement();
				String sql = "select * from "+ TBNAME + " where UID=\'" + cardId + "\'";
				
				// ���������󣬲����ؽ��
				result = stmt.executeQuery(sql);
				if(result.next()){
					isExist = true;
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
		return isExist;
	}
	
	// ��������ǰ�ͷ�����
	@Override
	protected void finalize() throws Throwable {
		if(null != this.conn)
			this.conn.close();
		
		super.finalize();
	}

}
