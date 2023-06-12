package dao;

import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import util.DBUtil;
import vo.*;

public class ProductDao {
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	// 이름별 검색
	public ArrayList<Product> searchProduct(int beginRow, int rowPerPage, String search) throws Exception{
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수 beginRow	<-- ProductDao searchProduct메서드" + RE);
			return null;
		}
		if(search == null) {
			System.out.println(SJ +"잘못된 매개변수 search <-- ProductDao searchProduct메서드" + RE);
			return null;
		}
		
		ArrayList<Product> list = new ArrayList<>();
		Product product = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		/*
		SELECT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate, p.updatedate,
	    pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		FROM product p 
		INNER JOIN product_img pim
		ON p.product_no = pim.product_no
		WHERE p.product_name LIKE ?
		ORDER BY productNo ASC
		LIMIT ?, ?
		 */
		String sql = "SELECT p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_status productStatus, p.product_stock productStock, p.product_info productInfo, p.createdate, p.updatedate,\r\n"
				+ "	    pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		FROM product p \r\n"
				+ "		INNER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		WHERE p.product_name LIKE ?\r\n"
				+ "		ORDER BY productNo ASC\r\n"
				+ "		LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+search+"%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			product = new Product();
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductInfo(rs.getString("productInfo"));
			product.setCreatedate(rs.getString("createdate"));
			product.setUpdatedate(rs.getString("updatedate"));
			list.add(product);	
		}
		return list;
	}
	// 관리자 상품 이미지 삽입
	public int insertProductImg(HttpServletRequest request,ProductImg productImg) throws Exception {
		if(productImg == null) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao insertProductImg메서드" + RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String dir = request.getServletContext().getRealPath("/product/productImg");
		System.out.println(dir);
		int max = 10 * 1024 * 1024; 
		MultipartRequest mRequest = new MultipartRequest((HttpServletRequest) request, dir, max, "utf-8", new DefaultFileRenamePolicy());
		String productFiletype = mRequest.getContentType("boardFile");
		String productOriFilename = mRequest.getOriginalFileName("boardFile");
		String productSaveFileName = mRequest.getFilesystemName("boardFile");
		int productNo = productImg.getProductNo();
		System.out.println(SJ + productFiletype + " <-- insert productFiletype" + RE);
		System.out.println(SJ + productOriFilename + " <-- insert productOriFilename"+ RE);
		System.out.println(SJ + productSaveFileName + " <-- insert productSaveFileName"+ RE);
		System.out.println(SJ + productNo + " <-- insert productNo"+RE);
		/*
		 INSERT INTO product_img(product_no, product_ori_filename, product_save_filename, product_filetype, createdate, updatedate) \r\n"
				+ "VALUES(?, ?, ?, ?, NOW(), NOW())
		 */
		String sql = "INSERT INTO product_img(product_no, product_ori_filename, product_save_filename, product_filetype, createdate, updatedate) \r\n"
				+ "VALUES(?, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productImg.getProductNo());
		stmt.setString(2, productOriFilename);
		stmt.setString(3, productSaveFileName);
		stmt.setString(4, productFiletype);
		row = stmt.executeUpdate(); // board_file 입력
		return row;
	}
	// 관리자 상품 이미지 수정
	public int updateProductImg(HttpServletRequest request, ProductImg productImg) throws Exception {
		if(productImg == null) {
			System.out.println(SJ + "잘못된 매개변수	<-- ProductDao updateProductImg메서드"+RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String dir = request.getServletContext().getRealPath("/upload");
		System.out.println(dir);
		int max = 10 * 1024 * 1024; 
		MultipartRequest mRequest = new MultipartRequest((HttpServletRequest) request, dir, max, "utf-8", new DefaultFileRenamePolicy());
		
		int productNo = Integer.parseInt(mRequest.getParameter("productNo"));
		// 이전 File 삭제, 새로운 File추가 테이블을 수정 
		if(mRequest.getOriginalFileName("boardFile") != null) {
			// 수정할 파일이 있으면
			// JPED 파일 유효성 검사, 아니면 새로 업로드 한 파일을 삭제
			if(mRequest.getContentType("boardFile").equals("application/jpeg") == false) {
				System.out.println(SJ + "JPG파일이 아닙니다"+RE);
				String saveFilename = mRequest.getFilesystemName("boardFile");
				File f = new File(dir+"/"+saveFilename);
				if(f.exists()) {
					f.delete();
					System.out.println(SJ+saveFilename+"파일삭제"+RE);
				}
			} else { 
				// PDF파일이면  
				// 1) 이전 파일(saveFilename) 삭제
				// 2) db수정(update)
				String productFiletype = mRequest.getContentType("boardFile");
				String productOriFilename = mRequest.getOriginalFileName("boardFile");
				String productSaveFileName = mRequest.getFilesystemName("boardFile");
				
				ProductImg file = new ProductImg();
				file.setProductNo(productNo);
				file.setProductFiletype(productFiletype);
				file.setProductOriFilename(productOriFilename);
				file.setProductSaveFileName(productSaveFileName);
				
				// 1) 이전파일 삭제
				String saveFilenameSql = "SELECT product_save_filename FROM product_img WHERE product_no=?";
				PreparedStatement saveFilenameStmt = conn.prepareStatement(saveFilenameSql);
				saveFilenameStmt.setInt(1, file.getProductNo());
				ResultSet saveFilenameRs = saveFilenameStmt.executeQuery();
				String preSaveFilename = "";
				if(saveFilenameRs.next()) {
					preSaveFilename = saveFilenameRs.getString("save_filename");
				}
				File f = new File(dir+"/"+preSaveFilename);
				if(f.exists()) {
					f.delete();
				}
				// 2) 수정된 파일의 정보로 db를 수정
				/*
					UPDATE product_img 
					SET product_ori_filename=?, product_save_filename=? 
					WHERE product_no=?
				*/
				String boardFileSql = "UPDATE product_img SET product_ori_filename=?, product_save_filename=? WHERE product_no=?";
				PreparedStatement boardFileStmt = conn.prepareStatement(boardFileSql);
				boardFileStmt.setString(1, productOriFilename);
				boardFileStmt.setString(2, productSaveFileName);
				boardFileStmt.setInt(3, productNo);
				row = boardFileStmt.executeUpdate();
			}
		}
		
		return row;
	}
	// 관리자 상품 이미지 삭제
	public int deleteProductImg(HttpServletRequest request, ProductImg productImg) throws Exception {
		if(productImg == null) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao deleteProductImg메서드"+RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String dir =  request.getServletContext().getRealPath("/upload");
		System.out.println(SJ +dir+RE);
		int max = 10 * 1024 * 1024; 
		MultipartRequest mRequest = new MultipartRequest((HttpServletRequest) request, dir, max, "utf-8", new DefaultFileRenamePolicy());
		int productNo = Integer.parseInt(mRequest.getParameter("productNo"));
		String productSaveFileName = mRequest.getFilesystemName("boardFile");
		System.out.println(SJ +productSaveFileName + " <-- delete productSaveFileName"+RE);
		System.out.println(SJ +productNo + " <-- delete productNo"+RE);
		if (mRequest.getParameter("productNo") == null){
			
			return 0;
		}
		String saveFilename = mRequest.getParameter("saveFilename");
		
		// 파일 삭제
		
		File f = new File(dir + "/" + saveFilename);
		if (f.exists()){
			f.delete();
			System.out.println(saveFilename + "파일삭제");
		}
		
		String delBoardSql = "DELETE FROM product_img WHERE product_no = ?";
	    PreparedStatement delBoardStmt = conn.prepareStatement(delBoardSql);
	    delBoardStmt.setInt(1, productNo);
		System.out.println(SJ +delBoardStmt + "<--- stmt deleteProductImg"+RE);
		
	    int delRow = delBoardStmt.executeUpdate();
	    
	    if(delRow == 1) {
	    	System.out.println("삭제완료");
	    	return row;
	    } else {
	    	System.out.println("삭제실패");
	    }
		return row;
	}
	// 관리자 상품 상세보기 : 내용 수정
	public int updateProduct(Product product) throws Exception {
		if(product == null) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao updateProduct메서드"+RE);
			return 0;
		}
		
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 저장
		/*
		UPDATE product 
		SET category_name = ?, product_name = ?, product_price = ?, product_status = ?, product_stock = ?, updatedate = NOW()
		WHERE product_no = ?
		 */
		String sql = "UPDATE product \r\n"
				+ "SET category_name = ?, product_name = ?, product_price = ?, product_status = ?, product_stock = ?, updatedate = NOW()\r\n"
				+ "WHERE product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, product.getCategoryName());
		stmt.setString(2, product.getProductName());
		stmt.setInt(3, product.getProductPrice());
		stmt.setString(4, product.getProductStatus());
		stmt.setInt(5, product.getProductStock());
		stmt.setInt(6, product.getProductNo());
		row = stmt.executeUpdate();
		return row;
	}
	// 관리자 상품 삽입
	public int insertProduct(Product product) throws Exception {
		if(product == null) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao insertProduct메서드"+RE);
			return 0;
		}
			
			// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 저장
		/*
		INSERT INTO product (category_name, product_name, product_price, product_status, product_stock, product_info, product_sum_cnt, createdate, updatedate) \r\n"
				+ "VALUES(?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
		 */
		// 물음표 7개
		String sql = "INSERT INTO product (category_name, product_name, product_price, product_status, product_stock, product_info, product_sum_cnt, createdate, updatedate) \r\n"
				+ "VALUES(?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, product.getCategoryName());
		stmt.setString(2, product.getProductName());
		stmt.setInt(3, product.getProductPrice());
		stmt.setString(4, product.getProductStatus());
		stmt.setInt(5, product.getProductStock());
		stmt.setString(5, product.getProductInfo());
		stmt.setInt(6, product.getProductSumCnt());
		row = stmt.executeUpdate();
		return row;
	}
	// 관리자 상품 삭제
	public int deleteProduct(int productNo) throws Exception {
		if(productNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao deleteProduct메서드"+RE);
			return 0;
		}
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 영향받은 행의 수 반환받아 저장
		String sql = "DELETE FROM product WHERE product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		row = stmt.executeUpdate();
		return row;
	}
	// 상품 전체 row
	public int selectProductCnt() throws Exception {
		
		// 반환할 전체 행의 수
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 값 저장
		PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM product");
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
	}
	// =========== product 상세, 수정 폼 ================
	public ArrayList<HashMap<String, Object>> selectProduct(int productNo) throws Exception {
		if(productNo == 0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectProduct메서드"+RE);
			return null;
		}
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
				+ "		WHERE p.product_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, productNo);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			// product 테이블
			m.put("productNo", rs.getInt("productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productInfo",rs.getString("productInfo"));
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			// product_img 테이블
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			// review 테이블
			m.put("orderNo",rs.getInt("orderNo"));
			m.put("reviewTitle",rs.getString("reviewTitle"));
			m.put("reviewContent",rs.getString("reviewContent"));
			m.put("r.createdate",rs.getString("r.createdate"));
			m.put("r.updatedate",rs.getString("r.updatedate"));
			
			m.put("rim.orderno",rs.getInt("rim.orderno"));
			m.put("reviewOriFilename",rs.getString("reviewOriFilename"));
			m.put("reviewSaveFilename",rs.getString("reviewSaveFilename"));
			m.put("reviewFiletype",rs.getString("reviewFiletype"));
			m.put("rim.createdate",rs.getString("rim.createdate"));
			m.put("rim.updatedate",rs.getString("rim.updatedate"));
			list.add(m);
		}
		return list;
	}
	//=================== 리스트 정렬 no, name, price, stock, status, sum_cnt ================
	// 상품 기본 정렬 : 판매량 순
	public  ArrayList<HashMap<String, Object>> selectSumCntByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectSumCntByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT RANK() over(order BY productSumCnt"+" " + orderby + " " + ") ranking,  p.product_no productNo,  product_sum_cnt productSumCnt, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,\r\n"
				+ "		 pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "	     ON p.product_no = pim.product_no\r\n"
				+ "		 LIMIT ?, ?";
		/*
		 SELECT RANK() over(order BY productSumCnt DESC) ranking,  p.product_no productNo,  product_sum_cnt productSumCnt, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
		 pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		 FROM product p
		 LEFT OUTER JOIN product_img pim
	     ON p.product_no = pim.product_no
		 LIMIT ?, ?
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			
			m.put("productNo",rs.getInt("productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productSumCnt",rs.getInt("productSumCnt"));
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			list.add(m);
		}
		return list;
	}
	// 상품 정렬 : No 순
	public  ArrayList<HashMap<String, Object>> selectProductNoByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectProductNoByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "asc";
		} else {
			orderby = "desc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "	 	 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productNo"+" " + orderby + " " + "\r\n"
				+ "		 LIMIT ?, ? ";
		/*
		 SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		 FROM product p
	 	 LEFT OUTER JOIN product_img pim
		 ON p.product_no = pim.product_no
		 ORDER BY productNo "+" " + orderby + " " + "
		 LIMIT ?, ? 
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("p.productNo",rs.getInt("p.productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productSumCnt",rs.getInt("productSumCnt"));
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			list.add(m);
		}
		return list;
	}
	// 상품 정렬 : Name 순
	public ArrayList<HashMap<String, Object>> selectProductNameByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectProductNameByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "asc";
		} else {
			orderby = "desc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productName "+" " + orderby + " " + "\r\n"
				+ "		 LIMIT ?, ? ";
		/*
		 SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
			pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		 FROM product p
		 LEFT OUTER JOIN product_img pim
		 ON p.product_no = pim.product_no
		 ORDER BY productName asc
		 LIMIT ?, ? 
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			
			m.put("p.productNo",rs.getInt("p.productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productSumCnt",rs.getInt("productSumCnt"));
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			list.add(m);
		}
		return list;
	}
	// 상품 정렬 : Price 순
	public 	ArrayList<HashMap<String, Object>> selectProductPrictByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectProductPrictByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productPrice "+" " + orderby + " " + "\r\n"
				+ "		 LIMIT ?, ? ";
		/*
		 SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		 FROM product p
		 LEFT OUTER JOIN product_img pim
		 ON p.product_no = pim.product_no
		 ORDER BY productPrice desc
		 LIMIT ?, ? 
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("p.productNo",rs.getInt("p.productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productSumCnt",rs.getInt("productSumCnt"));
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			list.add(m);
		}
		return list;
	}
	// 상품 정렬 : Stock 순
	public ArrayList<HashMap<String, Object>> selectProductStockByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectProductStockByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productStock "+" " + orderby + " " + "\r\n"
				+ "		 LIMIT ?, ? ";
		/*
		 SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		 FROM product p
		 LEFT OUTER JOIN product_img pim
		 ON p.product_no = pim.product_no
		 ORDER BY productStock desc
		 LIMIT ?, ? 
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("p.productNo",rs.getInt("p.productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productSumCnt",rs.getInt("productSumCnt"));
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			list.add(m);
		}
		return list;
	}
	// 상품 정렬 : Status 순
	public ArrayList<HashMap<String, Object>> selectProductStatusByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectProductStatusByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "asc";
		} else {
			orderby = "desc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productStatus "+" " + orderby + " " + "\r\n"
				+ "		 LIMIT ?, ? ";
		/*
		 SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		 FROM product p
		 LEFT OUTER JOIN product_img pim
		 ON p.product_no = pim.product_no
		 ORDER BY productStatus asc
		 LIMIT ?, ?
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("p.productNo",rs.getInt("p.productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productSumCnt",rs.getInt("productSumCnt"));
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			m.put("pim.createdate",rs.getString("pim.createdate"));
			m.put("pim.updatedate",rs.getString("pim.updatedate"));
			list.add(m);
		}
		return list;
		
	}
	// =============== 전체, 팝, 가요, 클래식 개별 판매순위 desc 출력 ==================
	// 전체 출력
	public ArrayList<HashMap<String, Object>> selectTotalByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectTotalByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT  RANK() over(order BY productSumCnt "+" " + orderby + " " + ") ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype\r\n"
				+ "		FROM product p\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "	 	LIMIT ?, ?";
		/*
		 SELECT  RANK() over(order BY productSumCnt DESC) ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, p.createdate, p.updatedate,
			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype
		FROM product p
		LEFT OUTER JOIN product_img pim
		ON p.product_no = pim.product_no
	 	LIMIT 0, 3
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("p.productNo",rs.getInt("p.productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productSumCnt",rs.getInt("productSumCnt"));
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			list.add(m);
		}
		return list;
		
	}
	// pop 출력
	public ArrayList<HashMap<String, Object>> selectPopByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectPopByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT  RANK() over(order BY productSumCnt "+" " + orderby + " " + ") ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype\r\n"
				+ "		FROM product p\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		WHERE category_name = 'pop'\r\n"
				+ "	 	LIMIT ?, ?";
		/*
		SELECT  RANK() over(order BY productSumCnt DESC) ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype\r\n"
				+ "		FROM product p\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		WHERE category_name = 'pop'\r\n"
				+ "	 	LIMIT ?, ?
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("p.productNo",rs.getInt("p.productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productSumCnt",rs.getInt("productSumCnt"));
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			list.add(m);
		}
		return list;
		
	}
	// kpop 출력
	public ArrayList<HashMap<String, Object>> selectKpopByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectKpopByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "select RANK() over(order BY productSumCnt "+" " + orderby + " " + ") ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype\r\n"
				+ "		FROM product p\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		WHERE category_name = 'kpop'\r\n"
				+ "		LIMIT ?, ?";
		/*
		select RANK() over(order BY productSumCnt DESC) ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, p.createdate, p.updatedate,
			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype
		FROM product p
		LEFT OUTER JOIN product_img pim
		ON p.product_no = pim.product_no
		WHERE category_name = 'kpop'
		LIMIT 0, 4
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("p.productNo",rs.getInt("p.productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productSumCnt",rs.getInt("productSumCnt"));
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			list.add(m);
		}
		return list;
		
	}
	// Classic 출력
	public ArrayList<HashMap<String, Object>> selectClassicByPage(boolean order, int beginRow, int rowPerPage) throws Exception {
		if(rowPerPage ==0) {
			System.out.println(SJ +"잘못된 매개변수	<-- ProductDao selectClassicByPage메서드"+RE);
			return null;
		}
		String orderby = null;
		if(order = true) {
			orderby = "desc";
		} else {
			orderby = "asc";
		}
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT  RANK() over(order BY productSumCnt "+" " + orderby + " " + ") ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, product_sum_cnt productSumCnt, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype\r\n"
				+ "		FROM product p\r\n"
				+ "		LEFT OUTER JOIN product_img pim\r\n"
				+ "		ON p.product_no = pim.product_no\r\n"
				+ "		WHERE category_name = 'classic'\r\n"
				+ "	 	LIMIT ?, ?";
		/*
		 SELECT  RANK() over(order BY productSumCnt DESC) ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, p.createdate, p.updatedate,
			pim.product_no, pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype
		FROM product p
		LEFT OUTER JOIN product_img pim
		ON p.product_no = pim.product_no
		WHERE category_name = 'classic'
	 	LIMIT 0, 3
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("p.productNo",rs.getInt("p.productNo"));
			m.put("categoryName",rs.getString("categoryName"));
			m.put("productName",rs.getString("productName"));
			m.put("productPrice",rs.getInt("productPrice"));
			m.put("productStock",rs.getInt("productStock"));
			m.put("productStatus",rs.getString("productStatus"));
			m.put("productSumCnt",rs.getInt("productSumCnt"));
			m.put("p.createdate",rs.getString("p.createdate"));
			m.put("p.updatedate",rs.getString("p.updatedate"));
			
			m.put("productOriFilename",rs.getString("productOriFilename"));
			m.put("productSaveFilename",rs.getString("productSaveFilename"));
			m.put("productFiletype",rs.getString("productFiletype"));
			list.add(m);
		}
		return list;
		
	}
	// =============== 정렬 끝 ====================
	
	
	
	
}
