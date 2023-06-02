package dao;

import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class OrdersDao {
	//조회: (검색) 일자별, 결제상태별, 배송상태별, 상품별 (정렬) 생성일, 주문번호
	public ArrayList<Orders> SelectOrdersListByPage(int beginRow, int rowPerPage) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT order_no orderNo, id, product_no productNo, order_cnt orderCnt, order_price orderPrice, payment_status paymentStatus, "
				+ "delivery_status deliveryStatus, createdate, updatedate "
				+ "FROM orders LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		ArrayList<Orders> list = new ArrayList<Orders>();
		while(rs.next()) {
			Orders o = new Orders();
			o.setOrderNo(rs.getInt("orderNo"));
			o.setId(rs.getString("id"));
			o.setProductNo(rs.getInt("ProductNo"));
			o.setOrderCnt(rs.getInt("orderCnt"));
			o.setOrderPrice(rs.getInt("orderPrice"));
			o.setPaymentStatus(rs.getString("paymentStatus"));
			o.setDeliveryStatus(rs.getString("deliveryStatus"));
			o.setCreatedate(rs.getString("createdate"));
			o.setUpdatedate(rs.getString("updatedate"));
			list.add(o);
		}
		return list;
	}
	
	//조회: (검색) 일자별, 결제상태별, 배송상태별, 상품별 (정렬) 생성일, 주문번호
	
	
	//삽입: 주문버튼 클릭시 주문번호 생성
	public int insertOrder(Orders order) throws Exception {
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
