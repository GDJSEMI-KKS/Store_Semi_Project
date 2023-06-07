package dao;

import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class ReviewDao {
	//조회: 리뷰리스트(관리자) - 답변여부에 따라 분기
	public ArrayList<HashMap<String, Object>> SelectReviewListByPage(int beginRow, int rowPerPage, String answer) throws Exception {
		if(answer == null) {
			answer = "all";
		}
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		//답변여부에 따라 검색
		String sql = "";
		if(answer.equals("all")) {
			sql = "SELECT r.review_no reviewNo, r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, r.review_check_cnt reviewCheckCnt, "
					+ "a.cnt cnt, r.createdate createdate, r.updatedate updatedate "
					+ "FROM review r INNER JOIN (SELECT review_no, COUNT(*) cnt FROM review_answer GROUP BY review_no) a "
					+ "ON r.review_no = a.review_no ";
		} else if(answer.equals("true")) { //답변이 없는 데이터만 조회
			sql = "SELECT r.review_no reviewNo, r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, r.review_check_cnt reviewCheckCnt, "
					+ "a.cnt cnt, r.createdate createdate, r.updatedate updatedate "
					+ "FROM review r INNER JOIN (SELECT review_no, COUNT(*) cnt FROM review_answer GROUP BY review_no) a "
					+ "ON r.review_no = a.review_no "
					+ "WHERE a.cnt = 0";
		} else { //답변이 있는 데이터만 조회
			sql = "SELECT r.review_no reviewNo, r.order_no orderNo, r.review_title reviewTitle, r.review_content reviewContent, r.review_check_cnt reviewCheckCnt, "
					+ "a.cnt cnt, r.createdate createdate, r.updatedate updatedate "
					+ "FROM review r INNER JOIN (SELECT review_no, COUNT(*) cnt FROM review_answer GROUP BY review_no) a "
					+ "ON r.review_no = a.review_no "
					+ "WHERE a.cnt > 0";
		}
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			list.add(m);
			m.put("reviewNo", rs.getInt("reviewNo"));
			m.put("orderNo", rs.getInt("orderNo"));
			m.put("reviewTitle", rs.getString("reviewTitle"));
			m.put("reviewContent", rs.getString("reviewContent"));
			m.put("reviewCheckCnt", rs.getInt("reviewCheckCnt"));
			m.put("cnt", rs.getInt("cnt"));
			m.put("createdate", rs.getString("createdate"));
			m.put("updatedate", rs.getString("updatedate"));
			list.add(m);
		}
		return list;
	}
	
	//조회: 리뷰리스트 행의 수 조회
	public int SelectReviewCnt(int beginRow, int rowPerPage, String answer) throws Exception {
		if(answer == null) {
			answer = "all";
		}
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		//답변여부에 따라 검색
		String sql = "";
		if(answer.equals("all")) {
			sql = "SELECT COUNT(*) cnt "
					+ "FROM review r INNER JOIN (SELECT review_no, COUNT(*) cnt FROM review_answer GROUP BY review_no) a "
					+ "ON r.review_no = a.review_no ";
		} else if(answer.equals("true")) { //답변이 없는 데이터만 조회
			sql = "SELECT COUNT(*) cnt "
					+ "FROM review r INNER JOIN (SELECT review_no, COUNT(*) cnt FROM review_answer GROUP BY review_no) a "
					+ "ON r.review_no = a.review_no "
					+ "WHERE a.cnt = 0";
		} else { //답변이 있는 데이터만 조회
			sql = "SELECT COUNT(*) cnt "
					+ "FROM review r INNER JOIN (SELECT review_no, COUNT(*) cnt FROM review_answer GROUP BY review_no) a "
					+ "ON r.review_no = a.review_no "
					+ "WHERE a.cnt > 0";
		}
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
	}
	
	//조회: Id별 리뷰
	public Review SelectReviewById(int id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT order_no orderNo, review_title reviewTitle, review_content reviewContent, review_check_cnt reviewCheckCnt, createdate, updatedate "
				+ "FROM review WHERE order_no IN (SELECT order_no orderNo FROM orders WHERE id = ?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		stmt.setInt(1, id);
		Review review = null;
		if(rs.next()) {
			review = new Review();
			review.setReviewNo(rs.getInt("reviewNo"));
			review.setOrderNo(rs.getInt("orderNo"));
			review.setReviewTitle(rs.getString("reviewTitle"));
			review.setReviewContent(rs.getString("reviewContent"));
			review.setReviewCheckCnt(rs.getInt("reviewCheckCnt"));
			review.setCreatedate(rs.getString("createdate"));
			review.setUpdatedate(rs.getString("updatedate"));
		}
		return review;
	}
	
	//조회: 주문번호별 리뷰
	public Review SelectReviewOne(int orderNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT review_no reviewNo, order_no orderNo, review_title reviewTitle, review_content reviewContent, review_check_cnt reviewCheckCnt, createdate, updatedate "
					+ "FROM review WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		stmt.setInt(1, orderNo);
		Review review = null;
		if(rs.next()) {
			review = new Review();
			review.setReviewNo(rs.getInt("reviewNo"));
			review.setOrderNo(rs.getInt("orderNo"));
			review.setReviewTitle(rs.getString("reviewTitle"));
			review.setReviewContent(rs.getString("reviewContent"));
			review.setReviewCheckCnt(rs.getInt("reviewCheckCnt"));
			review.setCreatedate(rs.getString("createdate"));
			review.setUpdatedate(rs.getString("updatedate"));
		}
		return review;
	}
	
	//삽입: 리뷰 등록
	public int insertReview(Review review) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO review (order_no, review_title, review_content, review_check_cnt, createdate, updatedate) "
				+ "VALUES (?, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, review.getOrderNo());
		stmt.setString(2, review.getReviewTitle());
		stmt.setString(3, review.getReviewContent());
		stmt.setInt(4, review.getReviewCheckCnt());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 리뷰수정
	public int updateReview(Review review) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE review SET review_title = ?, review_content = ?, review_check_cnt =?, updatedate = NOW() WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, review.getReviewTitle());
		stmt.setString(2, review.getReviewContent());
		stmt.setInt(3, review.getReviewCheckCnt());
		stmt.setInt(4, review.getOrderNo());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 클릭시 조회수 수정
	public int updateReviewCheckCnt(int orderNo, int checkCnt) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE review SET review_check_cnt =?, updatedate = NOW() WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);
		stmt.setInt(2, checkCnt);
		int row = stmt.executeUpdate();
		return row;
	}
	
	//삭제: 리뷰삭제
	public int deleteReview(int orderNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "DELETE FROM review WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);		
		int row = stmt.executeUpdate();
		return row;
	}
}
