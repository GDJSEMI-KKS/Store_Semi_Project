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
		System.out.println(KMJ + "orderSheet 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId" + " <--orderSheet loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} */
	String loginId = "user1"; //test용: 삭제예정
	System.out.println(KMJ + loginId + " <--orderSheet loginId");
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값 유효성 검사
	/* if(request.getParameter("cartNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int cartNo = Integer.parseInt(request.getParameter("cartNo")); */
	int cartNo = 1; //test용: 삭제예정
	System.out.println(KMJ + cartNo + " <--orderSheet cartNo" + RESET);
		
	//주문정보
	CartDao cDao = new CartDao();
	HashMap<String, Object> cart = cDao.selectCartOne(cartNo);
	int totalPrice = (Integer)cart.get("cartCnt") * (Integer)cart.get("productPrice");
	
	//포인트정보
	CustomerDao cstmDao = new CustomerDao();
	Customer customer = cstmDao.selectCustomer(loginId);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Order Sheet</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/orders/orderAction.jsp" method="post">
		<input type="hidden" name="cartNo" value="<%=cartNo%>">
		<input type="hidden" name="id" value="<%=loginId%>">
		<input type="hidden" name="productNo" value="<%=cart.get("productNo")%>">
		<input type="hidden" name="cartCnt" value="<%=cart.get("cartCnt")%>">
		<input type="hidden" name="productPrice" value="<%=cart.get("productPrice")%>">
		<h1>주문/결제</h1>
		<table>
			<tr>
				<th>상품정보</th>
				<th>수량</th>
				<th>상품금액</th>
				<th>결제금액</th>
			</tr>
			<tr>
				<td><%=cart.get("productName")%></td>
				<td><%=cart.get("cartCnt")%></td>
				<td><%=cart.get("productPrice")%></td>
				<td><%=totalPrice%></td>
			</tr>
		</table>
		
		<h2>주문자정보</h2>
		<table>
			<tr>
				<td><%=customer.getCstmAddress()%></td>
				<td><%=customer.getCstmPhone()%></td>
				<td><%=customer.getCstmName()%></td>
			</tr>
		</table>

		<h2>포인트</h2>
		<table>
			<tr>
				<th>현재포인트</th>
				<td><%=customer.getCstmPoint()%></td>
				<th>
					<input type="number" name="usePoint">
				</th>
			</tr>
		</table>
		
		<h2>결제방법</h2>
		<select name="payment">
			<option value="무통장">무통장입금
			<option value="신용카드">신용카드
		</select>
	</form>
</body>
</html>