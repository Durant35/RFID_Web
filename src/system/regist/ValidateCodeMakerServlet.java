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
		// ��������ҳ�治����
		response.setHeader("Pragma", "No-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expires", 0);
		response.setContentType("images/JPEG");
		
		// ����ͼƬ�Ŀ�Ⱥ͸߶�
		int width = 90, height = 40;
		// ����һ��ͼ�����
		BufferedImage image = new BufferedImage(width, height,
				BufferedImage.TYPE_INT_RGB);
		// �õ�ͼ��Ļ�������
		Graphics graphics = image.createGraphics();
		
		Random random = new Random();
		
		// �������ɫ���ͼ�񱳾�
		graphics.setColor(getRandColor(180, 250));
		graphics.fillRect(0, 0, width, height);
		for (int i = 0; i < 5; i++) {
			graphics.setColor(getRandColor(50, 100));
			int x = random.nextInt(width);
			int y = random.nextInt(height);
			graphics.drawOval(x, y, 4, 4);
		}
		// �������壬����׼���������
		graphics.setFont(new Font("", Font.PLAIN, 28));
		// ������ַ��� �ĸ�0-9�����
		String sRand = "";
		for (int i = 0; i < 4; i++) {
			// �����ĸ������ַ�
			String rand = String.valueOf(random.nextInt(10));
			sRand += rand;
			// ���������ɫ
			graphics.setColor(new Color(20 + random.nextInt(80), 20 + random
					.nextInt(100), 20 + random.nextInt(90)));
			// ��������ֻ���ͼ����
			graphics.drawString(rand, (17 + random.nextInt(3)) * i + 8, 34);
		
			// ���ɸ�����
			for (int k = 0; k < 12; k++) {
				int x = random.nextInt(width);
				int y = random.nextInt(height);
				int xl = random.nextInt(9);
				int yl = random.nextInt(9);
				graphics.drawLine(x, y, x + xl, y + yl);
			}
		}
		
		// �����ɵ���������ַ���д��Session
		HttpSession session = request.getSession();
		session.setAttribute("randCode", sRand);
		// ʹͼ����Ч
		graphics.dispose();
		// ���ͼ��ҳ��
		ImageIO.write(image, "JPEG", response.getOutputStream());
	}
	
	/**
	 * @param minBound	��ɫ������Сֵ
	 * @param maxBound	��ɫ�������ֵ
	 * @return	����һ���������ɫ
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
