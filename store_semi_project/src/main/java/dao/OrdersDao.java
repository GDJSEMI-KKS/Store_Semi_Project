package dao;

import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class OrdersDao {
	//조회: 전체 조회(검색은 없고 생성일 내림차순 정렬이 기본으로 되어 있음)
	public ArrayList<HashMap<String, Object>> SelectOrdersListByPage(int beginRow, int rowPerPage) throws Exception {
		//매개변수 유효성 검사: beginRow가 0미만이거나 rowPerPage가 0이하이면 각각 0, 10으로 함
		if(beginRow < 0 || rowPerPage <=0) {
			beginRow = 0;
			rowPerPage = 10;
		}
		
		//DB접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT o.order_no orderNo, o.id, p.category_name category, o.product_no productNo, o.order_cnt orderCnt, o.order_price orderPrice, o.payment_status paymentStatus, "
				+ "o.delivery_status deliveryStatus, o.createdate createdate, o.updatedate updatedate "
				+ "FROM orders o INNER JOIN product p"
				+ "ON o.product_no = p.product_no "
				+ "ORDER BY createdate DESC "
				+ "LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("orderNo", rs.getInt("orderNo"));
			m.put("id", rs.getString("id"));
			m.put("category",rs.getString("category"));
			m.put("productNo", rs.getInt("productNo"));
			m.put("orderCnt", rs.getInt("orderCnt"));
			m.put("orderPrice", rs.getInt("orderPrice"));
			m.put("paymentStatus", rs.getString("paymentStatus"));
			m.put("deliveryStatus", rs.getString("deliveryStatus"));
			m.put("createdate", rs.getString("createdate"));
			m.put("updatedate", rs.getString("updatedate"));
			list.add(m);
		}
		return list;
	}
	
	//조회: (검색) 일자별, 결제상태별, 배송상태별, 상품별 (정렬) 생성일, 주문번호
	public ArrayList<HashMap<String, Object>> SelectOrdersListBySearch(HashMap<String, Object> search, String col, boolean order, int beginRow, int rowPerPage) throws Exception {
		//매개변수 유효성 검사
		if(search == null || col == null) {
			System.out.println("잘못된 매개변수	<-- OrdersDao SelectOrdersListBySearch메서드");
			return null;
		}
		
		//boolean으로 들어온 order매개변수 값에 따라 String orderby에 값 저장하기
		String orderby = null;
		if(order = true) {
			orderby = "asc";
		} else {
			orderby = "desc";
		}
		
		//HashMap으로 들어온 매개변수 search값을 나누어 변수에 저장하기
		String searchPaymentStatus = null;
		String searchDeliveryStatus = null;
		String searchCategoryName = null;
		if(search.get("paymentStatus") instanceof String && search.get("deliveryStatus") instanceof String && search.get("categoryName") instanceof String) {
			searchPaymentStatus = (String)search.get("paymentStatus");
			searchDeliveryStatus = (String)search.get("deliveryStatus");
			searchCategoryName = (String)search.get("categoryName");
		} 
		
		String[] searchCreatedateArr = null;
		//search의 createdate키의값이 String인 경우와 String[]인 경우
		if(search.get("createdate") instanceof String[]) {
			searchCreatedateArr = (String[])search.get("createdate");
		}
		
		//DB접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT o.order_no orderNo, o.id, p.category_name category, o.product_no productNo, o.order_cnt orderCnt, o.order_price orderPrice, o.payment_status paymentStatus, "
				+ "o.delivery_status deliveryStatus, o.createdate, o.updatedate "
				+ "FROM orders o INNER JOIN product p"
				+ "ON o.product_no = p.product_no "
				+ "WHERE o.createdate "; 
		if(search.get("createdate").equals("oneWeek")) {
			sql += "BETWEEN DATE_ADD(NOW(), INTERVAL -1 WEEK ) AND NOW() ";
		} else if (search.get("createdate").equals("oneMonth")) {
			sql += "BETWEEN DATE_ADD(NOW(), INTERVAL -1 MONTH ) AND NOW() ";
		} else if (search.get("createdate").equals("oneYear")) {
			sql += "BETWEEN DATE_ADD(NOW(), INTERVAL -1 YEAR ) AND NOW() ";
		} else if (search.get("createdate").equals("self")) {
			sql += "BETWEEN " + searchCreatedateArr[0] + " AND " + searchCreatedateArr[1] + " ";
		}
		sql += "AND o.payment_status = ? AND o.delivery_status = ? AND p.category_name = ? "
				+ "ORDER BY " + col + " " + orderby + " "
				+ "LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, searchPaymentStatus);
		stmt.setString(2, searchDeliveryStatus);
		stmt.setString(3, searchCategoryName);
		stmt.setInt(4, beginRow);
		stmt.setInt(5, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		
		//리턴타입인 ArrayList<HashMap<String, Object>>에 저장한다
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("orderNo", rs.getInt("orderNo"));
			m.put("id", rs.getString("id"));
			m.put("category",rs.getString("category"));
			m.put("productNo", rs.getInt("productNo"));
			m.put("orderCnt", rs.getInt("orderCnt"));
			m.put("orderPrice", rs.getInt("orderPrice"));
			m.put("paymentStatus", rs.getString("paymentStatus"));
			m.put("deliveryStatus", rs.getString("deliveryStatus"));
			m.put("createdate", rs.getString("createdate"));
			m.put("updatedate", rs.getString("updatedate"));
			list.add(m);
		}
		return list;
	}
	
	
	//삽입: 주문버튼 클릭시 주문번호 생성
	public int insertOrder(Orders order) throws Exception {
		//매개변수 유효성 검사
		if(order == null) {
			System.out.println("잘못된 매개변수	<-- OrdersDao insertOrder메서드");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO orders (product_no, id, payment_status, deliver_status, order_cnt, order_price, createdate, updatedate) "
				+ "VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, order.getProductNo());
		stmt.setString(2, order.getId());
		stmt.setString(3, order.getPaymentStatus());
		stmt.setString(4, order.getDeliveryStatus());
		stmt.setInt(5, order.getOrderCnt());
		stmt.setInt(6, order.getOrderPrice());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 배송상태, 결제상태 수정
	public int updateOrder(Orders order) throws Exception {
		//매개변수 유효성 검사
		if(order == null) {
			System.out.println("잘못된 매개변수	<-- OrdersDao updateOrder메서드");
			return 0;
		}
		
		//DB접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE orders SET payment_status = ?, delivery_status = ?, updatedate = NOW() WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, order.getPaymentStatus());
		stmt.setString(2, order.getDeliveryStatus());
		stmt.setInt(3, order.getOrderNo());		
		int row = stmt.executeUpdate();
		return row;
	}
}
