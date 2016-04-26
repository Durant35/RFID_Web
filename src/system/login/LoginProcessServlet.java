package system.login;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import system.database.RFIDCardDBHelper;
import system.entity.RFIDCard;
import system.util.MD5Util;

/**
 *	Login登陆事件处理
 */
public class LoginProcessServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		/* Tomacat源代码问题，此处必须注释掉
		 * 更多参见: http://www.360doc.com/content/14/0511/09/16068204_376593985.shtml 
		 */
		//super.doPost(request, response);
		
		String cardId = request.getParameter("cardId");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String isLogin = request.getParameter("login");
		
		RFIDCardDBHelper helper = new RFIDCardDBHelper();
		RFIDCard info = helper.SearchRFIDCardByCardId(cardId);
		
		response.setContentType("text/xml; charset=UTF-8"); //设置服务器响应类型
        response.setHeader("Cache-Control","no-cache"); //页面不记录缓存
		StringBuffer xml= 
			new StringBuffer("<?xml version=\"1.0\" encoding=\"UTF-8\"?><items>");
		
		if(null == info){
			// 用户不存在 -1
			//System.out.println("卡号不存在");
			xml.append("<code>-1</code>");
			xml.append("<description>卡号不存在,请注册</description>");
		}
		else{
			// 用户存在 需要验证用户名和密码
			if(info.getUser().getUsername().equals(username)){
				String pwd = MD5Util.md5(password);
				
				// 验证成功，进行登陆
				if(info.getUser().getPassword().equals(pwd)){
					if("true".equals(isLogin)){
						request.getRequestDispatcher("./main.jsp").forward(request, response);
						return;
					}
					xml.append("<code>0</code>");
					xml.append("<description>密码正确</description>");
				}
				else{
					// 密码错误 -3
					//System.out.println("密码错误");
					xml.append("<code>-3</code>");
					xml.append("<description>密码错误</description>");
				}
			}
			else{
				// 用户名与卡号不匹配 -2
				//System.out.println("用户名错误");
				xml.append("<code>-2</code>");
				xml.append("<description>用户名错误</description>");
			}
		}
		xml.append("</items>");
		PrintWriter out = response.getWriter();
		out.println(xml.toString()); //返回生成的XML串
		out.flush(); //输出流刷新
		out.close(); //关闭输出流
	}
}
