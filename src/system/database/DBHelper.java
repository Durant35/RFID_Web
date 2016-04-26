package system.database;

import java.util.List;

import system.entity.RFIDCard;

/**
 * ���ݿ⸨����CURD�ӿڶ���
 */
public interface DBHelper {	
	/**
	 * �������û�
	 * @return �Ƿ����ɹ�
	 */
	public abstract boolean saveRFIDCard(RFIDCard card);

	/**
	 * ����cardIdɾ���û�
	 * @return ɾ���ļ�¼��
	 */
	public abstract boolean deleteRFIDCardByCardId(String cardId);

	/**
	 * �����û���Ϣ ͨ��card.cardId����Ψһ��ʶ
	 * @return �Ƿ���³ɹ�
	 */
	public abstract boolean updateRFIDCard(RFIDCard card);
	
	/**
	 * ���ݿ��Ż�ȡ�û���Ϣ ������Ƭ��Ϣ���û�������Ϣ
	 * @return �û���Ϣ
	 */
	public abstract RFIDCard SearchRFIDCardByCardId(String CardId);

	/**
	 * ��ȡ���е��û���Ϣ ������Ƭ��Ϣ���û�������Ϣ
	 * @return RFIDCard��Ϣ�б�
	 */
	public abstract List<RFIDCard> getAllRFIDCards();
}
