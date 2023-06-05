package dao;

import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class ReviewDao {
	//조회: 리뷰리스트(관리자)
	public ArrayList<Review> SelectReviewListByPage(int orderNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT order_no orderNo, review_ori_filename reviewOriFilename, review_save_filename reviewSaveFilename, review_filetype reviewFiletype, createdate, updatedate "
					+ "FROM review_img";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		ArrayList<Review> list = new ArrayList<Review>();
		while(rs.next()) {
			Review r = new Review();
			list.add(r);
		}
		return list;
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
		String sql = "SELECT order_no orderNo, review_title reviewTitle, review_content reviewContent, review_check_cnt reviewCheckCnt, createdate, updatedate "
					+ "FROM review WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		stmt.setInt(1, orderNo);
		Review review = null;
		if(rs.next()) {
			review = new Review();
			review.setOrderNo(rs.getInt("orderNo"));
			review.setReviewTitle(rs.getString("reviewTitle"));
			review.setReviewContent(rs.getString("reviewContent"));
			review.setReviewCheckCnt(rs.getInt("reviewCheckCnt"));
			review.setCreatedate(rs.getString("createdate"));
			review.setUpdatedate(rs.getString("updatedate"));
		}
		return review;
	}
	
	//삽입: 리뷰이미지 등록
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
