package system.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class UserDBHelper{
	// 驱动全局类名字符串
	private static final String DRIVER = "com.mysql.jdbc.Driver"; 
	// 数据库名
	private static final String DBNAME = "rfid"; 
	// 表名
	private static final String TBNAME = "users"; 
	// JDBC-MySQL连接字符串
	private static final String CONNSTR = "jdbc:mysql://localhost:3306/" + DBNAME; 
	
	Connection conn = null;
	
	public UserDBHelper(){
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

	public boolean CheckUserByCardId(String cardId) {
		boolean isExist = false;
		if(null != this.conn){
			Statement stmt = null;
			ResultSet result = null;
			try {
				// 获取语句对象
				stmt = this.conn.createStatement();
				String sql = "select * from "+ TBNAME + " where UID=\'" + cardId + "\'";
				
				// 传递语句对象，并返回结果
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
	
	// 垃圾回收前释放连接
	@Override
	protected void finalize() throws Throwable {
		if(null != this.conn)
			this.conn.close();
		
		super.finalize();
	}

}
