<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//요청값 잘 들어오는지 확인
	System.out.println(KMJ + request.getParameter("cartCnt") + " <--modifyCartCnt param cartCnt" + RESET);
	System.out.println(KMJ + request.getParameter("cartNo") + " <--modifyCartCnt param cartNo" + RESET);
	
	if(request.getParameter("cartNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		System.out.println("modifyCartCnt에서 리다이렉션");
		return;
	} else if (request.getParameter("cartNo") == null){
		response.sendRedirect(request.getContextPath()+"/cart/cart.jsp");
		System.out.println("modifyCartCnt에서 리다이렉션");
		return;
	}
	int cartCnt = Integer.parseInt(request.getParameter("cartCnt"));
	int cartNo = Integer.parseInt(request.getParameter("cartNo"));
	Cart cart = new Cart();
	cart.setCartCnt(cartCnt);
	cart.setCartNo(cartNo);
	
	//주문수량 업데이트
	CartDao cDao = new CartDao();
	int row = cDao.updateCartCnt(cart);
	if(row == 1){
		System.out.println(KMJ + row + " <--modifyCartCnt row 수량변경 성공");
	} else {
		System.out.println(KMJ + row + " <--modifyCartCnt row 수량변경 실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/cart/cart.jsp");
%>