package system.database;

import java.util.List;

import system.entity.RFIDCard;

/**
 * 数据库辅助类CURD接口定义
 */
public interface DBHelper {	
	/**
	 * 插入新用户
	 * @return 是否插入成功
	 */
	public abstract boolean saveRFIDCard(RFIDCard card);

	/**
	 * 根据cardId删除用户
	 * @return 删除的记录数
	 */
	public abstract boolean deleteRFIDCardByCardId(String cardId);

	/**
	 * 更新用户信息 通过card.cardId进行唯一标识
	 * @return 是否更新成功
	 */
	public abstract boolean updateRFIDCard(RFIDCard card);
	
	/**
	 * 根据卡号获取用户信息 包括卡片信息及用户个人信息
	 * @return 用户信息
	 */
	public abstract RFIDCard SearchRFIDCardByCardId(String CardId);

	/**
	 * 获取所有的用户信息 包括卡片信息及用户个人信息
	 * @return RFIDCard信息列表
	 */
	public abstract List<RFIDCard> getAllRFIDCards();
}
