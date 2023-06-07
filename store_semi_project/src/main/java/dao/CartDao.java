package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import util.DBUtil;
import vo.Cart;

public class CartDao {
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	
	// cartList 
	public ArrayList<HashMap<String, Object>> selectCartListByPage(Cart cart) throws Exception {
		
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
		SELECT  RANK() over(order BY cartNo asc) 번호, cart_no cartNo, c.product_no cartProductNo, c.id cartId, cart_cnt cartCnt, c.createdate cartCreatedate, c.updatedate cartUpdatedate,
			p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate proCreatedate, p.updatedate proUpdatedate,
			pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate pimCreatedate, pim.updatedate pimUpdatedate,
			cstm.id cstmId, cstm_name cstmName, cstm_address cstmAddress, cstm_point cstmPoint
		FROM cart c
		LEFT OUTER JOIN product p 
		ON p.product_no = c.product_no
		LEFT OUTER JOIN product_img pim
		ON p.product_no = pim.product_no
		LEFT OUTER JOIN customer cstm
		ON c.id = cstm.id
		WHERE c.id = ?
		ORDER BY c.cart_no ASC
		 */
		String sql = "SELECT  RANK() over(order BY cartNo asc) 번호, cart_no cartNo, c.product_no cartProductNo, c.id cartId, cart_cnt cartCnt, c.createdate cartCreatedate, c.updatedate cartUpdatedate,\r\n"
				+ "			p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate proCreatedate, p.updatedate proUpdatedate,\r\n"
				+ "			pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate pimCreatedate, pim.updatedate pimUpdatedate,\r\n"
				+ "			cstm.id cstmId, cstm_name cstmName, cstm_address cstmAddress, cstm_point cstmPoint\r\n"
				+ "		FROM cart c\r\n"
				+ "		LEFT OUTER JOIN product p \r\n"
				+ "		ON p.product_no = c.product_no\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		LEFT OUTER JOIN customer cstm\r\n"
				+ "		ON c.id = cstm.id\r\n"
				+ "		WHERE c.id = ?\r\n"
				+ "		ORDER BY c.cart_no ASC";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, cart.getId());
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			// cart 테이블
			m.put("cartNo",rs.getInt("cartNo"));
			m.put("cartProductNo",rs.getInt("cartProductNo"));
			m.put("cartId",rs.getString("cartId"));
			m.put("cartCnt",rs.getInt("cartCnt"));
			m.put("cartCreatedate",rs.getString("cartCreatedate"));
			m.put("cartUpdatedate",rs.getString("cartUpdatedate"));
			
			// product 테이블
			m.put("productNo",rs.getInt("productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productInfo",rs.getString("productInfo"));
			m.put("proCreatedate",rs.getString("proCreatedate"));
			m.put("proUpdatedate",rs.getString("proUpdatedate"));
			
			// product_img 테이블
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pimCreatedate",rs.getString("pimCreatedate"));
			m.put("pimUpdatedate",rs.getString("pimUpdatedate"));
			
			// customer 테이블
			m.put("cstmId",rs.getString("cstmId"));
			m.put("cstmName",rs.getString("cstmName"));
			m.put("cstmAddress",rs.getString("cstmAddress"));
			m.put("cstmPoint",rs.getString("cstmPoint"));
			list.add(m);
		}
		return list;
	}
}
