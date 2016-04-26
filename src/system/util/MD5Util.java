package system.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Java消息摘要算法 MD5工具类
 */
public class MD5Util {
  /**
   * 对文本执 md5摘要加密, 此算法与 mysql,JavaScript生成的md5摘要进行过一致性对比.
   * @param 明码文本 plainText
   * @return MD5加密文本(返回值中的字母为小写)
   */
  public static String md5(String plainText) {
    if(null == plainText) {
      plainText = "";
    }
    
    String MD5Str = "";
    try {
      // JDK 6 支持以下6种消息摘要算法，不区分大小写
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
