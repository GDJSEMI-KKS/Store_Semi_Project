package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import util.DBUtil;
import vo.Discount;

public class DiscountDao {
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	// 할인율 삽입
	public int insertDiscount(Discount discount) throws Exception {
		if(discount == null) {
			System.out.println(SJ +"잘못된 매개변수	<-- DiscountDao insertDiscount메서드" + RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "INSERT INTO discount(product_no, discount_start, discount_end, discount_rate, createdate, updatedate) VALUES(?,?,?,?, NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, discount.getProductNo());
		stmt.setString(2, discount.getDiscountStart());
		stmt.setString(3, discount.getDiscountEnd());
		stmt.setDouble(4, discount.getDiscountRate());
		row = stmt.executeUpdate();
		return row;
	}
	// 할인율 수정
	public int updateDiscount(Discount discount) throws Exception {
		if(discount == null) {
			System.out.println(SJ +"잘못된 매개변수	<-- DiscountDao updateDiscount메서드" + RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql ="UPDATE discount SET product_no = ?, discount_start = ?, discount_end = ?, discount_rate = ?, updatedate = NOW() WHERE discount_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, discount.getProductNo());
		stmt.setString(2, discount.getDiscountStart());
		stmt.setString(3, discount.getDiscountEnd());
		stmt.setDouble(4, discount.getDiscountRate());
		stmt.setInt(5, discount.getDiscountNo());
		row = stmt.executeUpdate();
		return row;
	}
	// 할인율 삭제
	public int deleteDiscount(int discountNo) throws Exception {
		if(discountNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- DiscountDao deleteDiscount메서드" + RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 영향받은 행의 수 반환받아 저장
		PreparedStatement stmt = conn.prepareStatement("DELETE FROM discount WHERE discount_no = ?");
		stmt.setInt(1, discountNo);
		row = stmt.executeUpdate();
		return row;
	}
}
