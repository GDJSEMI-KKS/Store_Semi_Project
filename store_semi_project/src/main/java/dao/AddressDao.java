package dao;

import java.util.*;
import java.sql.*;
import vo.*;
import util.*;

public class AddressDao {
	//조회: 전체 목록 조회(주소는 10개까지만 추가 가능, 생성일 내림차순)
	public ArrayList<Address> selectAddressListByPage() throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "SELECT address_no addressNo, id, address_name addressName, address, address_default addressDefault, address_last_date addressLastDate, createdate, updatedate "
						+"FROM address ORDER BY addressLastDate DESC";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->ArrayList
		ArrayList<Address> list = new ArrayList<Address>();
		while(rs.next()) {
			Address a = new Address();
			a.setAddressNo(rs.getInt("addressNo"));
			a.setId(rs.getString("id"));
			a.setAddressName(rs.getString("addressName"));
			a.setAddressDefault(rs.getString("addressDefault"));
			a.setAddressLastDate(rs.getString("addressLastDate"));
			a.setCreatedate(rs.getString("createdate"));
			a.setUpdatedate(rs.getString("updatedate"));
			list.add(a);
		}
		return list;
	}
	
	//조회: 행의 수 리턴
	public int selectAddressCnt() throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT COUNT(*) FROM address";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->int
		int row = 0;
		if(rs.next()) {
			row = rs.getInt(1);
		}
		return row;
		}
		
	//조회: 주소이름에 따라 주소 리턴
	public Address selectAddressName(String addressName) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT address_no addressNo, id, address_name, addressName, address, address_default addressDefault address_last_date addressLastDate, createdate, updatedate "
						+"from address where address_name = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, addressName);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->Address
		Address address = new Address();
		if(rs.next()) {
			address.setAddressNo(rs.getInt("addressNo"));
			address.setAddressName(rs.getString("addressName"));
			address.setAddress(rs.getString("address"));
			address.setAddressDefault(rs.getString("addressDefault"));
			address.setAddressLastDate(rs.getString("addressLastDate"));
			address.setCreatedate(rs.getString("createdate"));
			address.setUpdatedate(rs.getString("updatedate"));
		}
		return address; 
	}
	
	//조회: 기본주소 리턴
	public Address selectAddressDefault() throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "SELECT address_no addressNo, id, address_name, addressName, address, address_default addressDefault address_last_date addressLastDate, createdate, updatedate "
						+"from address where address_default = 'Y'";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		//ResultSet->Address
		Address address = new Address();
		if(rs.next()) {
			address.setAddressNo(rs.getInt("addressNo"));
			address.setAddressName(rs.getString("addressName"));
			address.setAddress(rs.getString("address"));
			address.setAddressDefault(rs.getString("addressDefault"));
			address.setAddressLastDate(rs.getString("addressLastDate"));
			address.setCreatedate(rs.getString("createdate"));
			address.setUpdatedate(rs.getString("updatedate"));
		}
		return address; 
	}
	
	//삽입: 주소 데이터 추가
	public int insertAddress(Address add) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement 
		String sql = "INSERT INTO address(id, address_name, address, address_default, address_last_date, createdate, updatedate) VALUES(?, ?, ?, ?, NOW(), NOW(), NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, add.getId());
		stmt.setString(2, add.getAddressName());
		stmt.setString(3, add.getAddress());
		stmt.setString(4, add.getAddressDefault());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정
	public int updateAddress(Address address) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE address SET address_name = ?, address = ?, address_default = ?, updatedate = NOW() where address_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, address.getAddressName());
		stmt.setString(2, address.getAddress());
		stmt.setString(3, address.getAddressDefault());
		stmt.setString(4, address.getAddressLastDate());
		stmt.setInt(4, address.getAddressNo());
		int row = stmt.executeUpdate();
		return row;
	}
	
	//수정: 주문이 완료되면 최근 사용 날짜 업데이트
	public int updateAddressDate(int addressNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "UPDATE address SET address_last_date = NOW(), updatedate = NOW() where address_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, addressNo);
		int row = stmt.executeUpdate();
		return row;
	}
	
	//삭제
	public int deleteAddress(int addressNo) throws Exception {
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		//PreparedStatement
		String sql = "DELETE FROM address WHERE address_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, addressNo);
		int row = stmt.executeUpdate();
		return row;
	}
	
	
}
