package system.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Java��ϢժҪ�㷨 MD5������
 */
public class MD5Util {
  /**
   * ���ı�ִ md5ժҪ����, ���㷨�� mysql,JavaScript���ɵ�md5ժҪ���й�һ���ԶԱ�.
   * @param �����ı� plainText
   * @return MD5�����ı�(����ֵ�е���ĸΪСд)
   */
  public static String md5(String plainText) {
    if(null == plainText) {
      plainText = "";
    }
    
    String MD5Str = "";
    try {
      // JDK 6 ֧������6����ϢժҪ�㷨�������ִ�Сд
      // md5,sha(sha-1),md2,sha-256,sha-384,sha-512
      MessageDigest md = MessageDigest.getInstance("MD5");
      md.update(plainText.getBytes());
      
      byte b[] = md.digest();
      int i;
 
      StringBuilder builder = new StringBuilder(32);
      for(int offset = 0; offset < b.length; offset++){
    	  i = b[offset];
    	  if (i < 0)
    		  i += 256;
    	  if (i < 16)
    		  builder.append("0");
    	  builder.append(Integer.toHexString(i));
      }
      MD5Str = builder.toString();
    }catch(NoSuchAlgorithmException e){
    	e.printStackTrace();
    }
    return MD5Str;
  }
  
}
