package dao;

import java.sql.*;
import vo.*;
import util.*;

public class ReviewAnswerDao {
	//조회: 리뷰번호별 답변
	public ReviewAnswer SelectReviewAnswerOne(int reviewNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT review_no reviewNo, review_a_content reviewAContent, createdate, updatedate "
				+ "FROM review_answer "
				+ "WHERE review_no = ?;";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		stmt.setInt(1, reviewNo);
		ReviewAnswer rAnswer = null;
		if(rs.next()) {
			rAnswer = new ReviewAnswer();
			rAnswer.setReviewNo(reviewNo);
			rAnswer.setReviewAContent(sql);
			rAnswer.setCreatedate(sql);
			rAnswer.setUpdatedate(sql);
		}
		return rAnswer;
	}
	
	//조회: 리뷰번호별 답변 수 (1이상이면 답변 완료로 처리)
	public int SelectReviewAnswerCnt(int reviewNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT COUNT(*) cnt FROM review_answer WHERE review_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, reviewNo);
		ResultSet rs = stmt.executeQuery();
		int row = 0;
		if(rs.next()) {
			row = rs.getInt("cnt");
		}
		return row;
	}
	
	//삽입: 리뷰답변
	public int insertReviewAnswer(ReviewAnswer rAnswer) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO review_answer (review_no, review_a_content, createdate, updatedate) "
				+ "VALUES (?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, rAnswer.getReviewNo());
		stmt.setString(2, rAnswer.getReviewAContent());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 리뷰수정
	public int updateReviewAnswer(ReviewAnswer review) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE review_answer SET review_title = ?, review_a_content = ?, review_check_cnt =?, updatedate = NOW() WHERE order_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);

		int row = stmt.executeUpdate();
		return row;
	}
	
	//삭제: 리뷰답변 삭제
	public int deleteReviewAnswer(int reviewNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "DELETE FROM review_answer WHERE review_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, reviewNo);		
		int row = stmt.executeUpdate();
		return row;
	}
}
