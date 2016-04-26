package system.main;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import system.database.PunchtimeDBHelper;
import system.database.RFIDCardDBHelper;

public class MainProcessServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		String type = request.getParameter("mainType");
		if("punchTime".equals(type)){
			String cardId = request.getParameter("cardId");
			int pageNum = Integer.parseInt(request.getParameter("pageNum"));
			//System.out.println(cardId);
			//System.out.println(pageNum);
			response.setContentType("text/xml; charset=UTF-8"); //设置服务器响应类型
	        response.setHeader("Cache-Control","no-cache"); //页面不记录缓存
			StringBuffer xml= 
				new StringBuffer("<?xml version=\"1.0\" encoding=\"UTF-8\"?><items>");
			
			PunchtimeDBHelper helper = new PunchtimeDBHelper();
			// 获取打卡时间记录总数
			int count = helper.getCountByCardId(cardId);
			xml.append("<Count>");
			xml.append(count+"");
			xml.append("</Count>");
			xml.append("<Size>");
			xml.append(PunchtimeDBHelper.PAGE_SIZE+"");
			xml.append("</Size>");
			xml.append("<pageNum>");
			xml.append(pageNum+"");
			xml.append("</pageNum>");
			
			ArrayList<String> timeRecords = helper.getTimeRecordsByPage(cardId, pageNum);
			
			if(null != timeRecords){
				for(String punchTime : timeRecords){
					xml.append("<record>");
					xml.append(punchTime);
					xml.append("</record>");
				}
			}
			xml.append("</items>");
			PrintWriter out = response.getWriter();
			out.println(xml.toString()); //返回生成的XML串
			out.flush(); //输出流刷新
			out.close(); //关闭输出流
			return;
		}
		else if("modifyEmail".equals(type)){
			PrintWriter out = response.getWriter();
			
			String email = request.getParameter("email");
			String cardId = request.getParameter("cardId");
			//System.out.println("email="+email);
			//System.out.println("cardId="+cardId);
			if(new RFIDCardDBHelper().modifyEmail(cardId, email)){
				out.print("Success");
			}
			else{
				out.print("Fail");
			}
			out.flush();
			out.close();
		}
	}
}
