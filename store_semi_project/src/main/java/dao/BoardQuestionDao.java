package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;

import vo.*;

public class BoardQuestionDao {
	
	// RESET ANST CODE 콘솔창 글자색, 배경색 지정
		final String RESET = "\u001B[0m";
		final String BLUE ="\u001B[34m";
		final String BG_YELLOW ="\u001B[43m";
		
	/* 조회
	 * 1. 전체 조회 (searchWord.equals(""))
	 * 2. 제목+내용, searchWord (searchWord.equals("") == false && columnName.equals("titleContent"))
	 * 3. 제목, searchWord (searchWord.equals("") == false && columnName.equals("title"))
	 * 4. 내용, searchWord (searchWord.equals("") == false && columnName.equals("content"))
	 * 5. 작성자, searchWord (searchWord.equals("") == false && columnName.equals("id"))
	 
	 * String searchWord : sql = Like ?(searchWord)
	 * String columnName : columnName.equals()
	*/
	
	public ArrayList<BoardQuestion> selectBoardQuestionByPage
	(int beginRow, int rowPerPage, String searchWord, String columnName) throws Exception{
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = null;
		PreparedStatement stmt = null;
		
		if(searchWord.equals("")) { // 1. 전체 조회
			
			sql = "SELECT board_q_no boardQNo, id, board_q_category boardQCategory, board_q_title boardQTitle, "
				+ "board_q_content boardQContent, board_q_check_cnt boardQCheckCnt, createdate, updatedate "
				+ "FROM board_question "
				+ "ORDER BY createdate DESC";
			
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1,beginRow);
			stmt.setInt(2,rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao 1.stmt"+RESET);
		} else if(searchWord.equals("") == false && columnName.equals("titleContent")){ // 2. 제목+내용, searchWord
			
			sql = "SELECT board_q_no boardQNo, id, board_q_category boardQCategory, board_q_title boardQTitle, "
				+ "board_q_content boardQContent, board_q_check_cnt boardQCheckCnt, createdate, updatedate "
				+ "FROM board_question "
				+ "WHERE board_q_title LIKE ? or board_q_content LIKE ? "
				+ "ORDER BY createdate DESC LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			stmt.setString(2, "%"+searchWord+"%");
			stmt.setInt(3, beginRow);
			stmt.setInt(4, rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao 2.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("title")) { // 3. 제목, searchWord
			
			sql = "SELECT board_q_no boardQNo, id, board_q_category boardQCategory, board_q_title boardQTitle, "
				+ "board_q_content boardQContent, board_q_check_cnt boardQCheckCnt, createdate, updatedate "
				+ "FROM board_question "
				+ "WHERE board_q_title LIKE ?"
				+ "ORDER BY createdate DESC LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao 3.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("content")) { // 4. 내용, searchWord
			
			sql = "SELECT board_q_no boardQNo, id, board_q_category boardQCategory, board_q_title boardQTitle, "
				+ "board_q_content boardQContent, board_q_check_cnt boardQCheckCnt, createdate, updatedate "
				+ "FROM board_question "
				+ "WHERE board_q_content LIKE ? "
				+ "ORDER BY createdate DESC LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao 4.stmt"+RESET);
			
		} else if(searchWord.equals("") == false && columnName.equals("id")) { // 5. 작성자, searchWord
			
			sql = "SELECT board_q_no boardQNo, id, board_q_category boardQCategory, board_q_title boardQTitle, "
				+ "board_q_content boardQContent, board_q_check_cnt boardQCheckCnt, createdate, updatedate "
				+ "FROM board_question "
				+ "WHERE id LIKE ? "
				+ "ORDER BY createdate DESC LIMIT ?, ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%"+searchWord+"%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			System.out.println(BG_YELLOW+BLUE+stmt +"<--BoardQuestionDao 5.stmt"+RESET);	
		}
		
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<BoardQuestion> list = new ArrayList<>();
		while(rs.next()) {
			BoardQuestion bq = new BoardQuestion();
			bq.setBoardQNo(rs.getInt("boardQNo"));
			bq.setId(rs.getString("id"));
			bq.setBoardQCategory(rs.getString("boardQCategory"));
			bq.setBoardQTitle(rs.getString("boardQTitle"));
			bq.setBoardQContent(rs.getString("boardQContent"));
			bq.setBoardQCheckCnt(rs.getInt("boardQCheckCnt"));
			bq.setCreatedate(rs.getString("createdate"));
			bq.setUpdatedate(rs.getString("updatedate"));
			list.add(bq);
		}
		
		return list;
	}
	
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
