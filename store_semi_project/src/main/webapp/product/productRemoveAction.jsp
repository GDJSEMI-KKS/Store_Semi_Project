<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<!-- 관리자 상품 삭제 -->
<% 	
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	System.out.println(SJ+ "productRemoveAction 시작" + RE);
	//요청값 유효성 검사
	if(request.getParameter("p.productNo") == null  
		|| request.getParameter("p.productNo").equals("")) {
		// subjectList.jsp으로
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	// 요청값 변수에 저장
	int productNo = Integer.parseInt(request.getParameter("p.productNo"));
	
	// sql 메서드들이 있는 클래스의 객체 생성
	ProductDao pDao = new ProductDao();
	// 과목 삭제 메서드 실행
	int row = pDao.deleteProduct(productNo);
	
	if(row == 1){
		System.out.println(SJ + "과목 삭제 성공" + RE);
	}
	// subjectList.jsp으로
	response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
%>