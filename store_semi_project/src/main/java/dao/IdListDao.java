package dao;
import java.sql.*;
import util.DBUtil;
import vo.*;

public class IdListDao {

	// 삽입
	// active, id_level DB에서 초기값 설정
	public int insertIdList(IdList idList) throws Exception {
		
		// 유효성 검사
		if(idList == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "INSERT INTO id_list(id, last_pw, createdate) VALUES (?, PASSWORD(?), now())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, idList.getId());
		stmt.setString(2, idList.getLastPw());
		int row = stmt.executeUpdate();
		return row;
	}
	
	// 상세 조회
	public IdList selectIdListOne(String id) throws Exception {
		
		// 유효성 검사
		if(id == null) {
			System.out.println("입력 error");
			return null;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT id, last_pw lastPw, active, createdate, id_level idLevel FROM id_list WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		
		ResultSet rs = stmt.executeQuery();
		IdList idList = null;
		if(rs.next()) {
			idList = new IdList();
			idList.setId(rs.getString("id"));
			idList.setLastPw(rs.getString("lastPw"));
			idList.setActive(rs.getString("active"));
			idList.setCreatedate("createdate");
			idList.setIdLevel(rs.getInt("idLevel"));
		}
		
		return idList;
	}
	
	// 조회(로그인)
	public boolean selectIdListLogin(IdList idList) throws Exception {
		
		// 유효성 검사
		if(idList == null) {
			System.out.println("입력 error");
			return false;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "SELECT id FROM id_list WHERE id = ? and last_pw = PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, idList.getId());
		stmt.setString(2, idList.getLastPw());
		
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			return true;
		}
		return false;
	}
	
	// 수정(last_pw)
	public int updateIdlistLastPw(String id, String lastPw) throws Exception {
		
		// 유효성 검사
		if(id == null || lastPw == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "UPDATE id_list SET last_pw = ? WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, lastPw);
		stmt.setString(2,  id);
		int row = stmt.executeUpdate();
		
		return row;
	}
	
	// 수정(active)
	public int updateIdListActive(String id, String active) throws Exception {
		
		// 유효성 검사
		if(id == null || active == null) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "UPDATE id_list SET active = ? WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, active);
		stmt.setString(2, id);
		int row = stmt.executeUpdate();
		
		return row;
	}
	
	// 수정(id_level)
	public int updateIdListIdLevel(String id, int idLevel) throws Exception {
			
		// 유효성 검사
		if(id == null || idLevel == 0) {
			System.out.println("입력 error");
			return 0;
		}
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = "UPDATE id_list SET id_level = ? WHERE id = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, idLevel);
		stmt.setString(2, id);
		int row = stmt.executeUpdate();
		
		return row;
	}
	
}
