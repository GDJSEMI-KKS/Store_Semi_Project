<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="dao.*" %>
<%@ page import ="util.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	//ANSI코드
	final String KMJ = "\u001B[42m";
	final String RESET = "\u001B[0m";
	
	//로그인 세션 유효성 검사: 로그인이 되어있지 않거나 주문한 id와 로그인 id가 다를경우 장바구니로 리다이렉션
	if(session.getAttribute("loginId") == null && !session.getAttribute("loginId").equals(request.getParameter("id"))){
		response.sendRedirect(request.getContextPath()+"/로그인페이지.jsp");
		System.out.println(KMJ + "orderAction 리다이렉션" + RESET);
		return;
	}
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기: productNo, id, orderCnt, orderPrice, payment, usePoint
	System.out.println(request.getParameter("productNo") + " <--orderAction param productNo" + RESET);
	System.out.println(request.getParameter("id") + " <--orderAction param id" + RESET);
	System.out.println(request.getParameter("orderCnt") + " <--orderAction param orderCnt" + RESET);
	System.out.println(request.getParameter("orderPrice") + " <--orderAction param orderPrice" + RESET);
	System.out.println(request.getParameter("payment") + " <--orderAction param payment" + RESET);
	System.out.println(request.getParameter("usePoint") + " <--orderAction param usePoint" + RESET);
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션 (요청값은 payment제외하고 readonly로 넘어오고 payment는 radio타입으로 넘어오므로 공백 고려안함)
	if(request.getParameter("productNo") == null || request.getParameter("id") == null
		|| request.getParameter("orderCnt") == null || request.getParameter("orderPrice") == null
		|| request.getParameter("payment") == null || request.getParameter("usePoint") == null){
		response.sendRedirect(KMJ + request.getContextPath()+"/메인.jsp" + RESET);
		return;
	}
	int productNo = Integer.parseInt(request.getParameter("productNo"));
	String id = request.getParameter("id");
	int orderCnt = Integer.parseInt(request.getParameter("orderCnt"));
	int orderPrice = Integer.parseInt(request.getParameter("orderPrice"));
	String payment = request.getParameter("payment");
	int usePoint = Integer.parseInt("usePoint");
	String paymentStatus = "결제완료";
	if(payment.equals("무통장입금")){
		paymentStatus = "결제대기";
	}
	String deliveryStatus = "발송준비";
	
	//orders DB에 저장하기 위하여 Orders타입으로 묶기
	Orders order = new Orders();
	order.setProductNo(productNo);
	order.setId(id);
	order.setPaymentStatus(paymentStatus); //무통장입금 선택시에는 결제대기로 바꾸기
	order.setDeliveryStatus(deliveryStatus);
	order.setOrderCnt(orderCnt);
	order.setOrderPrice(orderPrice);
	//주문DB 저장 후 orderNo받아오기
	OrdersDao oDao = new OrdersDao();
	int orderNo = oDao.insertOrder(order);
	System.out.println(KMJ + orderNo + " <--ordersAction orderNo" + RESET);
	
	//포인트이력DB 업데이트
	PointHistoryDao pDao = new PointHistoryDao();
	//사용한 포인트가 0보다 클 경우에는 포인트 -로 삽입
	if(usePoint > 0){
		PointHistory pMinus = new PointHistory();
		String pointPm = "-";
		pMinus.setOrderNo(orderNo);
		pMinus.setPoint(usePoint);
		pMinus.setPointPm(pointPm);
		int pMinusRow = pDao.insertPointHistory(pMinus);
		if(pMinusRow != 1){
			System.out.println(KMJ + pMinusRow + " <--ordersAction pMinusRow 입력실패" + RESET);
		} else {
			System.out.println(KMJ + pMinusRow + " <--ordersAction pMinusRow 입력성공" + RESET);
		}
	}
	//id의 등급에 따라 주문금액의 3%, 5%, 10% 적립 
	CustomerDao cDao = new CustomerDao();
	String rank = cDao.selectCustomer(id).getCstmRank();
	int point = 0;
	if(rank.equals("bronze")){
		point = (int)(orderPrice * 0.03);
	} else if(rank.equals("silver")){
		point = (int)(orderPrice * 0.05);
	} else {
		point = (int)(orderPrice * 0.1);
	}
	PointHistory pPlus = new PointHistory();
	String pointPm = "+";
	pPlus.setOrderNo(orderNo);
	pPlus.setPoint(point);
	pPlus.setPointPm(pointPm);
	int pPlusRow = pDao.insertPointHistory(pPlus);
	System.out.println(KMJ + pPlusRow + " <--ordersAction pMinusRow" + RESET);
	if(pPlusRow != 1){
		System.out.println(KMJ + pPlusRow + " <--ordersAction pPlusRow 입력실패" + RESET);
	} else {
		System.out.println(KMJ + pPlusRow + " <--ordersAction pPlusRow 입력성공" + RESET);
	}
	
	//포인트 합계 업데이트
	int sumPointRow = cDao.updatePoint(id);
	if(sumPointRow != 1){
		System.out.println(KMJ + sumPointRow + " <--ordersAction sumPointRow 입력실패" + RESET);
	} else {
		System.out.println(KMJ + sumPointRow + " <--ordersAction sumPointRow 입력성공" + RESET);
	}
	//주문금액 합계 업데이트
	int sumPriceRow = cDao.updateSumPrice(id);
	if(sumPriceRow != 1){
		System.out.println(KMJ + sumPriceRow + " <--ordersAction sumPriceRow 입력실패" + RESET);
	} else {
		System.out.println(KMJ + sumPriceRow + " <--ordersAction sumPriceRow 입력성공" + RESET);
	}
	
	response.sendRedirect(request.getContextPath()+"/주문완료페이지.jsp?orderNo="+orderNo);

%>