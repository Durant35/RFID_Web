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
 *	Login��½�¼�����
 */
public class LoginProcessServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		/* TomacatԴ�������⣬�˴�����ע�͵�
		 * ����μ�: http://www.360doc.com/content/14/0511/09/16068204_376593985.shtml 
		 */
		//super.doPost(request, response);
		
		String cardId = request.getParameter("cardId");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String isLogin = request.getParameter("login");
		
		RFIDCardDBHelper helper = new RFIDCardDBHelper();
		RFIDCard info = helper.SearchRFIDCardByCardId(cardId);
		
		response.setContentType("text/xml; charset=UTF-8"); //���÷�������Ӧ����
        response.setHeader("Cache-Control","no-cache"); //ҳ�治��¼����
		StringBuffer xml= 
			new StringBuffer("<?xml version=\"1.0\" encoding=\"UTF-8\"?><items>");
		
		if(null == info){
			// �û������� -1
			//System.out.println("���Ų�����");
			xml.append("<code>-1</code>");
			xml.append("<description>���Ų�����,��ע��</description>");
		}
		else{
			// �û����� ��Ҫ��֤�û���������
			if(info.getUser().getUsername().equals(username)){
				String pwd = MD5Util.md5(password);
				
				// ��֤�ɹ������е�½
				if(info.getUser().getPassword().equals(pwd)){
					if("true".equals(isLogin)){
						request.getRequestDispatcher("./main.jsp").forward(request, response);
						return;
					}
					xml.append("<code>0</code>");
					xml.append("<description>������ȷ</description>");
				}
				else{
					// ������� -3
					//System.out.println("�������");
					xml.append("<code>-3</code>");
					xml.append("<description>�������</description>");
				}
			}
			else{
				// �û����뿨�Ų�ƥ�� -2
				//System.out.println("�û�������");
				xml.append("<code>-2</code>");
				xml.append("<description>�û�������</description>");
			}
		}
		xml.append("</items>");
		PrintWriter out = response.getWriter();
		out.println(xml.toString()); //�������ɵ�XML��
		out.flush(); //�����ˢ��
		out.close(); //�ر������
	}
}
