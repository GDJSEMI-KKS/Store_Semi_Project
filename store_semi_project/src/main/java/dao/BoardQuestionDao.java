package dao;

import util.DBUtil;
import java.sql.*;
import vo.*;

public class BoardQuestionDao {
	
	// 조회
	
	// 상세 조회(board_question)
	public BoardQuestion selectBoardQuestionOne(int boardQuestionNo) throws Exception {
		
		// 유효성 검사
		if(boardQuestionNo == 0) {
			System.out.println("입력 error");
			return null;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT board_q_no boardQNo, id, board_q_category boardQCategory, board_q_title boardQTitle, board_q_content boardQContent, board_q_check_cnt boardQCheckCnt, createdate, updatedate "
				+ "FROM board_question WHERE board_q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, boardQuestionNo);
		ResultSet rs = stmt.executeQuery();
		
		BoardQuestion boardQuestion = null;
		if(rs.next()) {
			boardQuestion = new BoardQuestion();
			boardQuestion.setBoardQNo(rs.getInt("boardQNo"));
			boardQuestion.setId(rs.getString("id"));
			boardQuestion.setBoardQCategory(rs.getString("boardQCategory"));
			boardQuestion.setBoardQTitle(rs.getString("boardQTitle"));
			boardQuestion.setBoardQContent(rs.getString("boardQContent"));
			boardQuestion.setBoardQCheckCnt(rs.getInt("boardQCheckCnt"));
			boardQuestion.setCreatedate(rs.getString("createdate"));
			boardQuestion.setUpdatedate(rs.getString("updatedate"));
		}
		return boardQuestion;
	}
	
	// 삽입
	public int insertBoardQuestion(BoardQuestion boardQuestion) throws Exception {
		
		// 유효성 검사
		if(boardQuestion == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "INSERT INTO board_question(id, board_q_category, board_q_title, board_q_content, board_q_check_cnt, createdate, updatedate) "
				+ "VALUES (?, ?, ?, ?, 0, NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, boardQuestion.getId());
		stmt.setString(2, boardQuestion.getBoardQCategory());
		stmt.setString(3, boardQuestion.getBoardQTitle());
		stmt.setString(4, boardQuestion.getBoardQContent());
		int row = stmt.executeUpdate();
		
		return row;
		
	}
	
	// 수정
	public int updateBoardQuestion(BoardQuestion boardQuestion) throws Exception {
		
		// 유효성 검사
		if(boardQuestion == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE board_question SET board_q_category = ?, board_q_title = ?, board_q_content = ?, updatedate = NOW() "
				+ "WHERE board_q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, boardQuestion.getBoardQCategory());
		stmt.setString(2, boardQuestion.getBoardQTitle());
		stmt.setString(3, boardQuestion.getBoardQContent());
		stmt.setInt(4, boardQuestion.getBoardQNo());
		int row = stmt.executeUpdate();
		
		return row;
	}
	
	// 삭제
	public int deleteBoardQuestion(int boardQuestionNo) throws Exception {
		
		// 유효성 검사
		if(boardQuestionNo == 0) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "DELETE FROM board_question WHERE board_q_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, boardQuestionNo);
		int row = stmt.executeUpdate();
		
		return row;
		
	}
	
}
