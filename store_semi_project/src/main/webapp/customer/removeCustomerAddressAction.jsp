<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사: 로그인이 되어있지 않거나 로그인정보가 요청id와 다를 경우 리다이렉션
	/* if(session.getAttribute("loginId") == null){
		response.sendRedirect(KMJ + request.getContextPath()+"/로그인페이지.jsp" + RESET);
		System.out.println(KMJ + "removeCustomerAddressAction 로그인되어있지 않아 리다이렉션" + RESET);
		return;
	}
	String loginId = session.getAttribute(KMJ + "loginId" + " <--removeCustomerAddressAction loginId" + RESET);*/
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("id") + " <--removeCustomerAddressAction param addNo" + RESET);
	System.out.println(KMJ + request.getParameter("addNo") + " <--removeCustomerAddressAction param addNo" + RESET);
	
	String loginId = "user1";
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	if(request.getParameter("id") == null || request.getParameter("addNo") == null){
		response.sendRedirect(KMJ + request.getContextPath()+"customer/addCustomerAddress.jsp?id=" + loginId + RESET);
		return;
	}
	String id = request.getParameter("id");
	int addNo = Integer.parseInt(request.getParameter("addNo"));
	
	System.out.println(KMJ + id + " <--addCustomerAddressAction id" + RESET); 
	System.out.println(KMJ + addNo + " <--addCustomerAddressAction addNo" + RESET); 
	
	//기본주소는 삭제 불가
	AddressDao aDao = new AddressDao();
	Address defaultAdd = aDao.selectDefaultAddress(id);
	if(addNo != defaultAdd.getAddressNo()){
		int row = aDao.deleteAddress(addNo);
		System.out.println(KMJ + row + " <--removeCustomerAddressAction row 삭제성공" + RESET);
	}
	
	response.sendRedirect(request.getContextPath()+"/customer/addCustomerAddress.jsp?id="+id);
%>