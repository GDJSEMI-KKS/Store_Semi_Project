package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import util.DBUtil;
import vo.*;

public class AdminQuestionDao {
	
	// RESET ANST CODE 콘솔창 글자색, 배경색 지정
		final String RESET = "\u001B[0m";
		final String BLUE ="\u001B[34m";
		final String BG_YELLOW ="\u001B[43m";	
		
	/* 조회
	 *  1. 전체 조회 (category == null)
	 *  2. category 별 검색 조회
	 *  String categoryName : 카테고리명
	 */
	
	public ArrayList<HashMap<String, Object>> adminQuestionListByPage(int beginRow, int rowPerPage, String categoryName) throws Exception{
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = null;
		PreparedStatement stmt = null;
		
		if(categoryName.equals("")) {
			
			sql = "SELECT ROW_NUMBER() over(ORDER BY qCreatedate ASC) rnum, qNo, qCategory, qTitle, qCreatedate, aNoCnt "
				+ "FROM "
				+ "(SELECT q.q_no qNo, q.id id, q.q_category qCategory, q.q_title qTitle, q.createdate qCreatedate, COUNT(a.a_no) aNoCnt "
				+ "FROM question q LEFT OUTER JOIN answer a "
				+ "ON q.q_no = a.q_no "
				+ "GROUP BY qNo "
				+ "UNION ALL "
				+ "SELECT bq.board_q_no, bq.id, bq.board_q_category, bq.board_q_title, bq.createdate, COUNT(ba.board_a_no) "
				+ "FROM board_question bq LEFT OUTER JOIN board_answer ba "
				+ "ON bq.board_q_no = ba.board_q_no "
				+ "GROUP BY  bq.board_q_no) qbq "
				+ "ORDER BY rnum DESC LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1,beginRow);
			stmt.setInt(2,rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--AdminQuestionDao 1.stmt"+RESET);
			
		} else {
			
			sql = "SELECT ROW_NUMBER() over(ORDER BY qCreatedate ASC) rnum, qNo, qCategory, qTitle, qCreatedate, aNoCnt "
				+ "FROM "
				+ "(SELECT q.q_no qNo, q.id id, q.q_category qCategory, q.q_title qTitle, q.createdate qCreatedate, COUNT(a.a_no) aNoCnt "
				+ "FROM question q LEFT OUTER JOIN answer a "
				+ "ON q.q_no = a.q_no "
				+ "GROUP BY qNo "
				+ "UNION ALL "
				+ "SELECT bq.board_q_no, bq.id, bq.board_q_category, bq.board_q_title, bq.createdate, COUNT(ba.board_a_no) "
				+ "FROM board_question bq LEFT OUTER JOIN board_answer ba "
				+ "ON bq.board_q_no = ba.board_q_no "
				+ "GROUP BY  bq.board_q_no) qbq "
				+ "WHERE qCategory = ? "
				+ "ORDER BY rnum DESC LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, categoryName);
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--AdminQuestionDao 2.stmt"+RESET);
		}
		
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<HashMap<String,Object>> list = new ArrayList<>();
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<>();
			m.put("rnum", rs.getInt("rnum"));
			m.put("qNo", rs.getInt("qNo"));
			m.put("qCategory", rs.getString("qCategory"));
			m.put("qTitle", rs.getString("qTitle"));
			m.put("qCreatedate", rs.getString("qCreatedate"));
			list.add(m);
		}
		
		return list;
	}
	
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
