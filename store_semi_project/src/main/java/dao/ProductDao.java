package dao;

import java.io.*;
import java.sql.*;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import util.DBUtil;
import vo.*;

public class ProductDao {
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	// 관리자 상품 이미지 삽입
	public int insertProductImg(ProductImg productImg) throws Exception {
		ProductImg request = new ProductImg();
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String dir = ((HttpServletRequest) request).getServletContext().getRealPath("/upload");
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
		stmt.setString(2, productImg.getProductOriFilename());
		stmt.setString(3, productImg.getProductSaveFileName());
		stmt.setString(4, productImg.getProductFiletype());
		row = stmt.executeUpdate(); // board_file 입력
		return row;
	}
	// 관리자 상품 이미지 수정
	public int updateProductImg(ProductImg productImg) throws Exception {
		ProductImg request = new ProductImg();
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String dir = ((HttpServletRequest) request).getServletContext().getRealPath("/upload");
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
				boardFileStmt.setString(1, productImg.getProductOriFilename());
				boardFileStmt.setString(2, productImg.getProductSaveFileName());
				boardFileStmt.setInt(3, productImg.getProductNo());
				row = boardFileStmt.executeUpdate();
			}
		}
		
		return row;
	}
	// 관리자 상품 이미지 삭제
	public int deleteProductImg(ProductImg productImg) throws Exception {
		ProductImg request = new ProductImg();
		// sql 실행시 영향받은 행의 수 
		int row = 0;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String dir = ((HttpServletRequest) request).getServletContext().getRealPath("/upload");
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
	//=================== 리스트 정렬 no, name, price, stock, status, sum_cnt ================
	// 상품 기본 정렬 : 판매량 순
	public HashMap<Object, Object> selectSumCntByPage(int beginRow, int rowPerPage) throws Exception {
		Product product = null;
		ProductImg productImg = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT RANK() over(order BY productSumCnt DESC) ranking,  p.product_no productNo,  product_sum_cnt productSumCnt, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,\r\n"
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
		HashMap<Object, Object> hm = new HashMap<>();
		while(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			product.setProductNo(rs.getInt("p.productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("p.createdate"));
			product.setUpdatedate(rs.getString("p.updatedate"));
			
			productImg.setProductOriFilename(rs.getString("productOriFilename"));
			productImg.setProductSaveFileName(rs.getString("productSaveFilename"));
			productImg.setProductFiletype(rs.getString("productFiletype"));
			productImg.setCreatedate(rs.getString("pim.createdate"));
			productImg.setUpdatedate(rs.getString("pim.updatedate"));
			
			hm.put("product", product);
			hm.put("productImg", productImg);
		}
		return hm;
	}
	// 상품 정렬 : No 순
	public HashMap<Object, Object> selectProductNoByPage(int beginRow, int rowPerPage) throws Exception {
		Product product = null;
		ProductImg productImg = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,\r\n"
				+ "				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "	 	 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productNo asc\r\n"
				+ "		 LIMIT ?, ? ";
		/*
		 SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,
				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate
		 FROM product p
	 	 LEFT OUTER JOIN product_img pim
		 ON p.product_no = pim.product_no
		 ORDER BY productNo asc
		 LIMIT ?, ? 
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		HashMap<Object, Object> hm = new HashMap<>();
		while(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			product.setProductNo(rs.getInt("p.productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("p.createdate"));
			product.setUpdatedate(rs.getString("p.updatedate"));
			
			productImg.setProductOriFilename(rs.getString("productOriFilename"));
			productImg.setProductSaveFileName(rs.getString("productSaveFilename"));
			productImg.setProductFiletype(rs.getString("productFiletype"));
			productImg.setCreatedate(rs.getString("pim.createdate"));
			productImg.setUpdatedate(rs.getString("pim.updatedate"));
			
			hm.put("product", product);
			hm.put("productImg", productImg);	
		}
		return hm;
	}
	// 상품 정렬 : Name 순
	public HashMap<Object, Object> selectProductNameByPage(int beginRow, int rowPerPage) throws Exception {
		Product product = null;
		ProductImg productImg = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,\r\n"
				+ "			pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productName asc\r\n"
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
		
		HashMap<Object, Object> hm = new HashMap<>();
		while(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			product.setProductNo(rs.getInt("p.productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("p.createdate"));
			product.setUpdatedate(rs.getString("p.updatedate"));
			
			productImg.setProductOriFilename(rs.getString("productOriFilename"));
			productImg.setProductSaveFileName(rs.getString("productSaveFilename"));
			productImg.setProductFiletype(rs.getString("productFiletype"));
			productImg.setCreatedate(rs.getString("pim.createdate"));
			productImg.setUpdatedate(rs.getString("pim.updatedate"));
			
			hm.put("product", product);
			hm.put("productImg", productImg);	
		}
		return hm;
	}
	// 상품 정렬 : Price 순
	public HashMap<Object, Object> selectProductPrictByPage(int beginRow, int rowPerPage) throws Exception {
		Product product = null;
		ProductImg productImg = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,\r\n"
				+ "				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productPrice desc\r\n"
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
		HashMap<Object, Object> hm = new HashMap<>();
		while(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			product.setProductNo(rs.getInt("p.productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("p.createdate"));
			product.setUpdatedate(rs.getString("p.updatedate"));
			
			productImg.setProductOriFilename(rs.getString("productOriFilename"));
			productImg.setProductSaveFileName(rs.getString("productSaveFilename"));
			productImg.setProductFiletype(rs.getString("productFiletype"));
			productImg.setCreatedate(rs.getString("pim.createdate"));
			productImg.setUpdatedate(rs.getString("pim.updatedate"));
			
			hm.put("product", product);
			hm.put("productImg", productImg);	
		}
		return hm;
	}
	// 상품 정렬 : Stock 순
	public HashMap<Object, Object> selectProductStockByPage(int beginRow, int rowPerPage) throws Exception {
		Product product = null;
		ProductImg productImg = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,\r\n"
				+ "				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productStock desc\r\n"
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
		HashMap<Object, Object> hm = new HashMap<>();
		while(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			product.setProductNo(rs.getInt("p.productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("p.createdate"));
			product.setUpdatedate(rs.getString("p.updatedate"));
			
			productImg.setProductOriFilename(rs.getString("productOriFilename"));
			productImg.setProductSaveFileName(rs.getString("productSaveFilename"));
			productImg.setProductFiletype(rs.getString("productFiletype"));
			productImg.setCreatedate(rs.getString("pim.createdate"));
			productImg.setUpdatedate(rs.getString("pim.updatedate"));
			
			hm.put("product", product);
			hm.put("productImg", productImg);	
		}
		return hm;
	}
	// 상품 정렬 : Status 순
	public HashMap<Object, Object> selectProductStatusByPage(int beginRow, int rowPerPage) throws Exception {
		Product product = null;
		ProductImg productImg = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT p.product_no productNo, category_name categoryName, product_name productName, product_price productPrice, product_stock productStock, product_status productStatus, p.createdate, p.updatedate,\r\n"
				+ "				pim.product_ori_filename productOriFilename, pim.product_save_filename productSaveFilename, pim.product_filetype productFiletype, pim.createdate, pim.updatedate\r\n"
				+ "		 FROM product p\r\n"
				+ "		 LEFT OUTER JOIN product_img pim\r\n"
				+ "		 ON p.product_no = pim.product_no\r\n"
				+ "		 ORDER BY productStatus asc\r\n"
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
		HashMap<Object, Object> hm = new HashMap<>();
		while(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			product.setProductNo(rs.getInt("p.productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("p.createdate"));
			product.setUpdatedate(rs.getString("p.updatedate"));
			
			productImg.setProductOriFilename(rs.getString("productOriFilename"));
			productImg.setProductSaveFileName(rs.getString("productSaveFilename"));
			productImg.setProductFiletype(rs.getString("productFiletype"));
			productImg.setCreatedate(rs.getString("pim.createdate"));
			productImg.setUpdatedate(rs.getString("pim.updatedate"));
			
			hm.put("product", product);
			hm.put("productImg", productImg);	
		}
		return hm;
		
	}
	// =============== 전체, 팝, 가요, 클래식 개별 판매순위 desc 출력 ==================
	// 전체 출력
	public HashMap<Object, Object> selectTotalByPage(int beginRow, int rowPerPage) throws Exception {
		Product product = null;
		ProductImg productImg = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT  RANK() over(order BY productSumCnt DESC) ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, p.createdate, p.updatedate,\r\n"
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
		HashMap<Object, Object> hm = new HashMap<>();
		while(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			product.setProductNo(rs.getInt("p.productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("p.createdate"));
			product.setUpdatedate(rs.getString("p.updatedate"));
			
			productImg.setProductOriFilename(rs.getString("productOriFilename"));
			productImg.setProductSaveFileName(rs.getString("productSaveFilename"));
			productImg.setProductFiletype(rs.getString("productFiletype"));
			productImg.setCreatedate(rs.getString("pim.createdate"));
			productImg.setUpdatedate(rs.getString("pim.updatedate"));
			
			hm.put("product", product);
			hm.put("productImg", productImg);	
		}
		return hm;
		
	}
	// pop 출력
	public HashMap<Object, Object> selectPopByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환값
		Product product = null;
		ProductImg productImg = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT  RANK() over(order BY productSumCnt DESC) ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, p.createdate, p.updatedate,\r\n"
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
		HashMap<Object, Object> hm = new HashMap<>();
		while(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("t.createdate"));
			product.setUpdatedate(rs.getString("t.updatedate"));
			
			productImg.setProductOriFilename(rs.getString("productOriFilename"));
			productImg.setProductSaveFileName(rs.getString("productSaveFilename"));
			productImg.setProductFiletype(rs.getString("productFiletype"));
			
			hm.put("product", product);
			hm.put("productImg", productImg);
		}
		return hm;
		
	}
	// kpop 출력
	public HashMap<Object, Object> selectKpopByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환값
		Product product = null;
		ProductImg productImg = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "select RANK() over(order BY productSumCnt DESC) ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, p.createdate, p.updatedate,\r\n"
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
		HashMap<Object, Object> hm = new HashMap<>();
		while(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("t.createdate"));
			product.setUpdatedate(rs.getString("t.updatedate"));
			
			productImg.setProductOriFilename(rs.getString("productOriFilename"));
			productImg.setProductSaveFileName(rs.getString("productSaveFilename"));
			productImg.setProductFiletype(rs.getString("productFiletype"));
			
			hm.put("product", product);
			hm.put("productImg", productImg);
		}
		return hm;
		
	}
	// Classic 출력
	public HashMap<Object, Object> selectClassicByPage(int beginRow, int rowPerPage) throws Exception {
		// 반환값
		Product product = null;
		ProductImg productImg = null;
		// db 접속
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		// sql 전송 후 결과셋 반환받아 리스트에 저장
		String sql = "SELECT  RANK() over(order BY productSumCnt DESC) ranking, p.product_sum_cnt productSumCnt, p.product_no productNo, p.category_name categoryName, p.product_name productName, p.product_price productPrice, p.product_stock productStock, p.product_status productStatus, p.createdate, p.updatedate,\r\n"
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
		HashMap<Object, Object> hm = new HashMap<>();
		while(rs.next()) {
			product = new Product();
			productImg = new ProductImg();
			
			product.setProductNo(rs.getInt("productNo"));
			product.setCategoryName(rs.getString("categoryName"));
			product.setProductName(rs.getString("productName"));
			product.setProductPrice(rs.getInt("productPrice"));
			product.setProductStock(rs.getInt("productStock"));
			product.setProductStatus(rs.getString("productStatus"));
			product.setProductSumCnt(rs.getInt("productSumCnt"));
			product.setCreatedate(rs.getString("t.createdate"));
			product.setUpdatedate(rs.getString("t.updatedate"));
			
			productImg.setProductOriFilename(rs.getString("productOriFilename"));
			productImg.setProductSaveFileName(rs.getString("productSaveFilename"));
			productImg.setProductFiletype(rs.getString("productFiletype"));
			
			hm.put("product", product);
			hm.put("productImg", productImg);
		}
		return hm;
		
	}
	// =============== 정렬 끝 ====================
	
	
	
	
}
