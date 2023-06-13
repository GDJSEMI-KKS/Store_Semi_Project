<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	/* //로그인 유효성 검사
	if(session.getAttribute("loginId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println(KMJ + "orderConfirm 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId" + " <--orderConfirm loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} */
	String loginId = "user1"; //test용: 삭제예정
	System.out.println(KMJ + loginId + " <--ordersAction loginId");
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값 유효성 검사: orderNo가 null인 경우 메인페이지로 리다이렉션
	if(request.getParameter("orderNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	
	//orders 정보 불러오기
	OrdersDao oDao = new OrdersDao();
	Orders order = oDao.selectOrderOne(orderNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Order Confirmation Page</title>
</head>
<body>
<%=order.getOrderNo()%>주문이 완료되었습니다
<a href="">주문내역확인</a>
</body>
</html>