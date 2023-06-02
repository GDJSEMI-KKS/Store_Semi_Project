package dao;

import java.sql.*;
import vo.*;
import util.*;

public class PwHistoryDao {
	//조회: id별 비밀번호이력의 수
	public int selectPwHistoryCnt(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT COUNT(*) FROM pw_history WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->int
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
		}
						
	//삽입: 비밀번호 이력추가
	public int insertEmployee(PwHistory pwHistory) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO pw_history (id, pw, createdate) "
				+ "VALUES (?, PASSWORD(?), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, pwHistory.getId());
		stmt.setString(2, pwHistory.getPw());
		stmt.setString(3, pwHistory.getCreatedate());
		int row = stmt.executeUpdate();
		return row;
	}
			
	//삭제: 가장 오래된 pw이력 삭제
	public int deletePwHistory(String id) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "DELETE FROM pw_history WHERE id = ? and createdate = (SELECT MIN(createdate) pwNo FROM pw_history group by id having id = ?);";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		stmt.setString(2, id);
		int row = stmt.executeUpdate();
		return row;
	}
}
