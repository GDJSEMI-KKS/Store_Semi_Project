package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DBUtil;
import vo.*;

public class AdminQuestionDao {
	
	// 상세 조회(question)
	public Question selectQuestionOne(int questionNo) throws Exception {
		
		// 유효성 검사
		if(questionNo == 0) {
			System.out.println("입력 error");
			return null;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT q_no qNo, product_no productNo, id, q_category qCategory, q_title qTitle, q_content qContent, q_check_cnt qCheckCnt, createdate, updatedate \r\n"
				+ "FROM question WHERE q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, questionNo);
		ResultSet rs = stmt.executeQuery();
		
		Question question = null;
		
		if(rs.next()) {
			question = new Question();
			question.setqNo(rs.getInt("qNo"));
			question.setProductNo(rs.getInt("productNo"));
			question.setId(rs.getString("id"));
			question.setqCategory(rs.getString("qCategory"));
			question.setqTitle(rs.getString("qTitle"));
			question.setqCheckCnt(rs.getInt("qCheckCnt"));
			question.setCreatedate(rs.getString("createdate"));
			question.setUpdatedate(rs.getString("updatedate"));
		}
		return question;
	}
	
	// 삽입(answer)
	public int insertAnswer(Answer answer) throws Exception {
		
		// 유효성 검사
		if(answer == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "INSERT INTO answer(a_no, q_no, id, a_content, createdate, updatedate) VALUES(?, ?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, answer.getaNo());
		stmt.setInt(2, answer.getqNo());
		stmt.setString(3, answer.getId());
		stmt.setString(4, answer.getaContent());
		int row = stmt.executeUpdate();
		
		return row;
	}
	
	// 삽입(board_answer)
	public int insertBoardAnswer(BoardAnswer boardAnswer) throws Exception {
		
		// 유효성 검사
		if(boardAnswer == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql= "INSERT INTO board_answer(board_q_no, id, board_a_content, createdate, updatedate) VALUES(?, ?, ?, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, boardAnswer.getBoardANo());
		stmt.setString(2, boardAnswer.getId());
		stmt.setString(3, boardAnswer.getBoardAContent());
		int row = stmt.executeUpdate();
		
		return row;
	}
	
	// 수정(answer)
	public int updateCategory(Answer answer) throws Exception {
		
		// 유효성 검사
		if(answer == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "UPDATE answer SET id = ?, a_content = ?, updatedate = NOW() WHERE a_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, answer.getId());
		stmt.setString(2, answer.getaContent());
		stmt.setInt(3, answer.getaNo());
		int row = stmt.executeUpdate();
		
		return row;
	}
	
	// 수정(board_answer)
	public int updateBoardAnswer(BoardAnswer boardAnswer) throws Exception {
		
		// 유효성 검사
		if(boardAnswer == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "UPDATE answer SET id = ?, board_a_content = ?, updatedate = NOW() WHERE board_a_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, boardAnswer.getId());
		stmt.setString(2, boardAnswer.getBoardAContent());
		stmt.setInt(3, boardAnswer.getBoardANo());
		int row = stmt.executeUpdate();
		
		return row;
	}
	
	// 삭제(answer)
	public int deleteAnswer(int answerNo) throws Exception {
		
		// 유효성 검사
		if(answerNo == 0) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "DELETE FROM answer WHERE a_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, answerNo);
		int row = stmt.executeUpdate();
		
		return row;
	}
	
	// 삭제(board_answer)
	public int deleteBoardAnswer(int boardAnswerNo) throws Exception {
		
		// 유효성 검사
		if(boardAnswerNo == 0) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "DELETE FROM board_answer WHERE a_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, boardAnswerNo);
		int row = stmt.executeUpdate();
		
		return row;
	}
}
