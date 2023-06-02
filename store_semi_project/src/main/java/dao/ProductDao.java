package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

import util.DBUtil;
import vo.*;

public class ProductDao {
	// =========== product 상세, 수정 폼 ================
	public HashMap<Object, Object> selectProduct(int productNo) throws Exception {
		
		
		Product product = null;
		Review review = null;
		ProductImg productImg = null;
		ReviewImg reviewImg = null;
		
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 저장
		/*
		SELECT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate, p.updatedate, 
		r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, r.createdate, r.updatedate, 
		pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate,
		rim.review_ori_filename reviewOriFilename, rim.review_save_filename reviewSaveFilename, rim.review_filetype reviewFiletype, rim.createdate, rim.updatedate
		FROM product p
		LEFT OUTER JOIN product_img pim
		ON p.product_no = pim.product_no
		LEFT OUTER JOIN orders o 
		ON p.product_no = o.product_no
		LEFT OUTER JOIN review r
		ON p.product_no = o.product_no
		LEFT OUTER JOIN review_img rim
		ON r.order_no = rim.order_no
		WHERE p.product_no = ?
		LIMIT ?, ?
		 */
		String sql = "SELECT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate, p.updatedate, \r\n"
				+ "		r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, r.createdate, r.updatedate, \r\n"
				+ "		pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate,\r\n"
				+ "		rim.review_ori_filename reviewOriFilename, rim.review_save_filename reviewSaveFilename, rim.review_filetype reviewFiletype, rim.createdate, rim.updatedate\r\n"
				+ "		FROM product p\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		LEFT OUTER JOIN orders o \r\n"
				+ "		ON p.product_no = o.product_no\r\n"
				+ "		LEFT OUTER JOIN review r\r\n"
				+ "		ON p.product_no = o.product_no\r\n"
				+ "		LEFT OUTER JOIN review_img rim\r\n"
				+ "		ON r.order_no = rim.order_no\r\n"
				+ "		WHERE p.product_no = ?\r\n"
				+ "		LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		ResultSet rs = stmt.executeQuery();
		HashMap<Object, Object> hm = new HashMap<>();
		if(rs.next()) {
			product = new Product();
			review = new Review();
			productImg = new ProductImg();
			reviewImg = new ReviewImg();
			// product 테이블
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductInfo(rs.getString("productInfo"));
			product.setProductInfo(rs.getString("productInfo"));
			product.setProductInfo(rs.getString("productInfo"));
			product.setProductInfo(rs.getString("productInfo"));
			product.setCreatedate(rs.getString("p.createdate"));
			product.setUpdatedate(rs.getString("p.updatedate"));
			// product_img 테이블
			productImg.setProductOriFilename(rs.getString("productOriFilename"));
			productImg.setProductSaveFileName(rs.getString("productSaveFilename"));
			productImg.setProductFiletype(rs.getString("productFiletype"));
			productImg.setCreatedate(rs.getString("pim.createdate"));
			productImg.setUpdatedate(rs.getString("pim.updatedate"));
			// review 테이블
			review.setOrderNo(rs.getInt("orderNo"));
			review.setReviewTitle(rs.getString("reviewTitle"));
			review.setReviewContent(rs.getString("reviewContent"));
			review.setReviewTitle(rs.getString("reviewTitle"));
			review.setCreatedate(rs.getString("r.createdate"));
			review.setUpdatedate(rs.getString("r.updatedate"));
			
			reviewImg.setOrderNo(rs.getInt("rim.orderno"));
			reviewImg.setReviewOriFilename(rs.getString("reviewOriFilename"));
			reviewImg.setReviewSaveFilename(rs.getString("reviewSaveFilename"));
			reviewImg.setReviewFiletype(rs.getString("reviewFiletype"));
			reviewImg.setCreatedate(rs.getString("r.createdate"));
			reviewImg.setUpdatedate(rs.getString("r.updatedate"));
			hm.put("product", product);
			hm.put("review", review);
			hm.put("productImg", productImg);
			hm.put("reviewImg", reviewImg);
			
		}
		return hm;
	}
	
	public ArrayList<Product> selectProductByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환할 리스트
		ArrayList<Product> list = new ArrayList<>();
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate\r\n"
				+ "		 FROM product \r\n"
				+ "		 ORDER BY productNo desc\r\n"
				+ "		 LIMIT ?, ?";
		/*
		 SELECT product_sum_cnt productSumCnt, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate
		 FROM product 
		 ORDER BY productSumCnt desc
		 LIMIT ?, ?
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Product product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
	}
	//=================== 리스트 정렬 no, name, price, stock, status, sum_cnt ================
	public ArrayList<Product> selectSumCntByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환할 리스트
		ArrayList<Product> list = new ArrayList<>();
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate\r\n"
				+ "		 FROM product \r\n"
				+ "		 ORDER BY productNo desc\r\n"
				+ "		 LIMIT ?, ?";
		/*
		 SELECT product_sum_cnt productSumCnt, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate
		 FROM product 
		 ORDER BY productSumCnt desc
		 LIMIT ?, ?
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Product product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
	}
	
	public ArrayList<Product> selectProductNoByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환할 리스트
		ArrayList<Product> list = new ArrayList<>();
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate\r\n"
				+ "		 FROM product \r\n"
				+ "		 ORDER BY productNo asc\r\n"
				+ "		 LIMIT ?, ?";
		/*
		 SELECT product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate
		 FROM product 
		 ORDER BY productNo asc
		 LIMIT ?, ?
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Product product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
	}
	public ArrayList<Product> selectProductNameByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환할 리스트
		ArrayList<Product> list = new ArrayList<>();
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate\r\n"
				+ "		 FROM product \r\n"
				+ "		 ORDER BY productName asc\r\n"
				+ "		 LIMIT ?, ?";
		/*
		 SELECT product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate
		 FROM product 
		 ORDER BY productName asc
		 LIMIT ?, ?
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Product product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
	}
	public ArrayList<Product> selectProductPrictByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환할 리스트
		ArrayList<Product> list = new ArrayList<>();
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate\r\n"
				+ "		 FROM product \r\n"
				+ "		 ORDER BY productPrice asc\r\n"
				+ "		 LIMIT ?, ?";
		/*
		 SELECT product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate
		 FROM product 
		 ORDER BY productName asc
		 LIMIT ?, ?
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Product product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
	}
	public ArrayList<Product> selectProductStockByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환할 리스트
		ArrayList<Product> list = new ArrayList<>();
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate\r\n"
				+ "		 FROM product \r\n"
				+ "		 ORDER BY productStock asc\r\n"
				+ "		 LIMIT ?, ?";
		/*
		 SELECT product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate
		 FROM product 
		 ORDER BY productName asc
		 LIMIT ?, ?
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Product product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
	}
	public ArrayList<Product> selectProductStatusByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환할 리스트
		ArrayList<Product> list = new ArrayList<>();
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate\r\n"
				+ "		 FROM product \r\n"
				+ "		 ORDER BY productStock asc\r\n"
				+ "		 LIMIT ?, ?";
		/*
		 SELECT product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate
		 FROM product 
		 ORDER BY productName asc
		 LIMIT ?, ?
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Product product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
		
	}
	// =============== 전체, 팝, 가요, 클래식 개별 판매순위 desc 출력 ==================
	public ArrayList<Product> selectTotalByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환할 리스트
		ArrayList<Product> list = new ArrayList<>();
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT ROWNUM productSumCnt, productNo, categoryName, productName, productPrice, productStock, productStatus, createdate, updatedate\r\n"
				+ "		 FROM \r\n"
				+ "			(SELECT @ROWNUM := @ROWNUM + 1 AS ROWNUM, product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate\r\n"
				+ "		 	FROM product, (SELECT @ROWNUM := 0) TMP\r\n"
				+ "		 	ORDER BY productSumCnt desc\r\n"
				+ "		 	LIMIT ?, ?) t\r\n"
				+ "		ORDER BY t.ROWNUM ASC";
		/*
		 SELECT ROWNUM productSumCnt, productNo, categoryName, productName, productPrice, productStock, productStatus, createdate, updatedate
		 FROM 
			(SELECT @ROWNUM := @ROWNUM + 1 AS ROWNUM, product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate
		 	FROM product, (SELECT @ROWNUM := 0) TMP
		 	ORDER BY productSumCnt desc
		 	LIMIT 0, 3) t
		ORDER BY t.ROWNUM ASC
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Product product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
		
	}
	public ArrayList<Product> selectPopByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환할 리스트
		ArrayList<Product> list = new ArrayList<>();
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT ROWNUM productSumCnt, productNo, categoryName, productName, productPrice, productStock, productStatus, createdate, updatedate\r\n"
				+ "		 FROM \r\n"
				+ "			(SELECT @ROWNUM := @ROWNUM + 1 AS ROWNUM, product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate\r\n"
				+ "		 	FROM product, (SELECT @ROWNUM := 0) TMP\r\n"
				+ "		 	WHERE category_name = 'pop'\r\n"
				+ "		 	ORDER BY productSumCnt desc\r\n"
				+ "	 		LIMIT ?, ?) t\r\n"
				+ "		ORDER BY t.ROWNUM ASC";
		/*
		 SELECT ROWNUM productSumCnt, productNo, categoryName, productName, productPrice, productStock, productStatus, createdate, updatedate
		 FROM 
			(SELECT @ROWNUM := @ROWNUM + 1 AS ROWNUM, product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate
		 	FROM product, (SELECT @ROWNUM := 0) TMP
		 	WHERE category_name = 'pop'
		 	ORDER BY productSumCnt desc
	 		LIMIT 0, 3) t
		ORDER BY t.ROWNUM ASC
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Product product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
		
	}
	public ArrayList<Product> selectKpopByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환할 리스트
		ArrayList<Product> list = new ArrayList<>();
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT ROWNUM productSumCnt, productNo, categoryName, productName, productPrice, productStock, productStatus, createdate, updatedate\r\n"
				+ "		 FROM \r\n"
				+ "			(SELECT @ROWNUM := @ROWNUM + 1 AS ROWNUM, product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate\r\n"
				+ "		 	FROM product, (SELECT @ROWNUM := 0) TMP\r\n"
				+ "		 	WHERE category_name = 'kpop'\r\n"
				+ "		 	ORDER BY productSumCnt desc\r\n"
				+ "	 		LIMIT ?, ?) t\r\n"
				+ "		ORDER BY t.ROWNUM ASC";
		/*
		SELECT ROWNUM productSumCnt, productNo, categoryName, productName, productPrice, productStock, productStatus, createdate, updatedate
		 FROM 
			(SELECT @ROWNUM := @ROWNUM + 1 AS ROWNUM, product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate
		 	FROM product, (SELECT @ROWNUM := 0) TMP
		 	WHERE category_name = 'kpop'
		 	ORDER BY productSumCnt desc
	 		LIMIT 0, 3) t
		ORDER BY t.ROWNUM ASC
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Product product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
		
	}
	public ArrayList<Product> selectClassicByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환할 리스트
		ArrayList<Product> list = new ArrayList<>();
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT ROWNUM productSumCnt, productNo, categoryName, productName, productPrice, productStock, productStatus, createdate, updatedate\r\n"
				+ "		 FROM \r\n"
				+ "			(SELECT @ROWNUM := @ROWNUM + 1 AS ROWNUM, product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate\r\n"
				+ "		 	FROM product, (SELECT @ROWNUM := 0) TMP\r\n"
				+ "		 	WHERE category_name = 'classic'\r\n"
				+ "		 	ORDER BY productSumCnt desc\r\n"
				+ "	 		LIMIT ?, ?) t\r\n"
				+ "		ORDER BY t.ROWNUM ASC";
		/*
		 SELECT ROWNUM productSumCnt, productNo, categoryName, productName, productPrice, productStock, productStatus, createdate, updatedate
		 FROM 
			(SELECT @ROWNUM := @ROWNUM + 1 AS ROWNUM, product_sum_cnt productSumCnt, product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, createdate, updatedate
		 	FROM product, (SELECT @ROWNUM := 0) TMP
		 	WHERE category_name = 'classic'
		 	ORDER BY productSumCnt desc
	 		LIMIT 0, 3) t
		ORDER BY t.ROWNUM ASC
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			Product product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
		
	}
	// =============== 정렬 끝 ====================
	
	
	
	
}
