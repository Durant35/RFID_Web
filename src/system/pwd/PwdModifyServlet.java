package system.pwd;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import system.database.RFIDCardDBHelper;

public class PwdModifyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		String cardId = request.getParameter("cardId");
		String newPWD = request.getParameter("newPWD");
		//System.out.println(cardId);
		//System.out.println(newPWD);
		PrintWriter out = response.getWriter();
		if(new RFIDCardDBHelper().modifyPWD(cardId, newPWD)){
			out.print("Success"); 
		}
		else{
			out.print("Fail");
		}
		out.flush();
		out.close();
	}
}
