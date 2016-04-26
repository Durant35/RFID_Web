package system.regist;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ValidateCodeMakerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public void service(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		// 首先设置页面不缓存
		response.setHeader("Pragma", "No-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("images/JPEG");
		
		// 定义图片的宽度和高度
		int width = 90, height = 40;
		// 创建一个图像对象
		BufferedImage image = new BufferedImage(width, height,
				BufferedImage.TYPE_INT_RGB);
		// 得到图像的环境对象
		Graphics graphics = image.createGraphics();
		
		Random random = new Random();
		
		// 用随机颜色填充图像背景
		graphics.setColor(getRandColor(180, 250));
		graphics.fillRect(0, 0, width, height);
		for (int i = 0; i < 5; i++) {
			graphics.setColor(getRandColor(50, 100));
			int x = random.nextInt(width);
			int y = random.nextInt(height);
			graphics.drawOval(x, y, 4, 4);
		}
		// 设置字体，下面准备画随机数
		graphics.setFont(new Font("", Font.PLAIN, 28));
		// 随机数字符串 四个0-9随机数
		String sRand = "";
		for (int i = 0; i < 4; i++) {
			// 生成四个数字字符
			String rand = String.valueOf(random.nextInt(10));
			sRand += rand;
			// 生成随机颜色
			graphics.setColor(new Color(20 + random.nextInt(80), 20 + random
					.nextInt(100), 20 + random.nextInt(90)));
			// 将随机数字画在图像上
			graphics.drawString(rand, (17 + random.nextInt(3)) * i + 8, 34);
		
			// 生成干扰线
			for (int k = 0; k < 12; k++) {
				int x = random.nextInt(width);
				int y = random.nextInt(height);
				int xl = random.nextInt(9);
				int yl = random.nextInt(9);
				graphics.drawLine(x, y, x + xl, y + yl);
			}
		}
		
		// 将生成的随机数字字符串写入Session
		HttpSession session = request.getSession();
		session.setAttribute("randCode", sRand);
		// 使图像生效
		graphics.dispose();
		// 输出图像到页面
		ImageIO.write(image, "JPEG", response.getOutputStream());
	}
	
	/**
	 * @param minBound	颜色分量最小值
	 * @param maxBound	颜色分量最大值
	 * @return	产生一个随机的颜色
	 */
	private Color getRandColor(int minBound, int maxBound) {
		Random random = new Random();
		if (maxBound > 255){
			maxBound = 255;
		}
		if (minBound > 255){
			minBound = 255;
		}
		int r = minBound + random.nextInt(maxBound - minBound);
		int g = minBound + random.nextInt(maxBound - minBound);
		int b = minBound + random.nextInt(maxBound - minBound);
		return new Color(r, g, b);
	}
}
