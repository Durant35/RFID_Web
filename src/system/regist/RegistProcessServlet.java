package system.regist;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import system.database.RFIDCardDBHelper;
import system.database.UserDBHelper;
import system.entity.RFIDCard;

public class RegistProcessServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		String processType = request.getParameter("processType");
		if("checkValidate".equals(processType)){
			String code = request.getParameter("code");
			HttpSession session = request.getSession();

			String randCode = (String)session.getAttribute("randCode");// 得到系统生成的验证码
			PrintWriter out = response.getWriter();
			if(randCode.equals(code)){// 验证码输入正确
				out.print("Right");
			}else{
				out.print("Wrong");
			}
			out.flush();
			out.close();
			return;
		}
		else if("modifyPWD".equals(processType)){
			String cardId = request.getParameter("cardId");
			PrintWriter out = response.getWriter();
			if(new UserDBHelper().CheckUserByCardId(cardId)){
				RFIDCard card = new RFIDCardDBHelper().SearchRFIDCardByCardId(cardId);
				if(null == card){
					out.print("notAllow");
				}
				else{
					out.print("ok_"+card.getUser().getUsername());
				}
			}
			else{
				out.print("notExist");
			}
			out.flush();
			out.close();
			return;
		}
		else if("checkCardID".equals(processType)){
			String cardId = request.getParameter("cardId");
			PrintWriter out = response.getWriter();
			if(new UserDBHelper().CheckUserByCardId(cardId)){
				if(null != new RFIDCardDBHelper().SearchRFIDCardByCardId(cardId)){
					out.print("notAllow");
				}
				else{
					out.print("ok");
				}
			}
			else{
				out.print("notExist");
			}
			out.flush();
			out.close();
			return;
		}
		String cardId = request.getParameter("cardId");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String type = "Unknown";
		Timestamp createTime = new Timestamp(new java.util.Date().getTime());
		
		RFIDCard cardInfo = new RFIDCard(cardId, type, username, password, email, createTime);
		
		RFIDCardDBHelper helper = new RFIDCardDBHelper();
		if(helper.saveRFIDCard(cardInfo)){
			request.setAttribute("cardId", cardId);
			request.setAttribute("username", username);
			request.getRequestDispatcher("./regist.jsp?step=2").forward(request, response);
		}
		else{
			request.getRequestDispatcher("./regist.jsp?step=1").forward(request, response);
		}
	}
}
