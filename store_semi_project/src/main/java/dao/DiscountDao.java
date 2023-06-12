package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DBUtil;
import vo.Discount;

public class DiscountDao {
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	// 할인율 조회
	public Discount selectDiscount(int discountNo) throws Exception {
		if(discountNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- DiscountDao selectDiscount메서드" + RE);
			return null;
		}
	Discount discount = null;
	// db 접속
	DBUtil dbUtil = new DBUtil();
	Connection conn = dbUtil.getConnection();
	// sql 전송 후 결과셋 반환받아 저장
	/*
	SELECT discount_no discountNo, product_no productNo, discount_start discountStart, discount_end discountEnd, discount_rate discountRate, createdate, updatedate
	FROM discount
	WHERE discount_no = ?
	 */
	String sql = "SELECT discount_no discountNo, product_no productNo, discount_start discountStart, discount_end discountEnd, discount_rate discountRate, createdate, updatedate\r\n"
			+ "	FROM discount\r\n"
			+ "	WHERE discount_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, discountNo);
	ResultSet rs = stmt.executeQuery();
	if(rs.next()) {
		discount = new Discount();
		discount.setDiscountNo(rs.getInt("discountNo"));
		discount.setProductNo(rs.getInt("productNo"));
		discount.setDiscountStart(rs.getString("discountStart"));
		discount.setDiscountEnd(rs.getString("discountEnd"));
		discount.setDiscountRate(rs.getDouble("discountRate"));
		discount.setCreatedate(rs.getString("createdate"));
		discount.setUpdatedate(rs.getString("updatedate"));
	}
	return discount;
	}
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
