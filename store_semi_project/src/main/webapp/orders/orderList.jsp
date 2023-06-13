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
	
	//요청값 유효성 검사
	if(request.getParameter("id") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	int beginRow = (currentPage - 1)*rowPerPage + 1;
	
	//id에 따른 주문목록 출력
	OrdersDao oDao = new OrdersDao();
	ArrayList<HashMap<String, Object>> list = oDao.selectOrderById(loginId, beginRow, rowPerPage);
	System.out.println(KMJ + list.size() + " <--orderList list.size()" + RESET);
	String dir = request.getServletContext().getRealPath("/productImg");
	
	//주문번호별 리뷰 수 (리뷰는 한 주문(상품) 당 1개만 가능) 출력
	ReviewDao rDao = new ReviewDao();
	
	//페이징
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>orderList</title>
</head>
<body>
	<table>
		<%
			for(HashMap<String, Object> m : list){
		%>
		<tr>
			<td><img src="" alt="이미지준비중"></td>
			<td><%=(String)m.get("productName")%></td>
			<td><%=(String)m.get("paymentStatus")%></td>
			<td><%=(String)m.get("deliveryStatus")%></td>
			<td><%=(Integer)m.get("orderCnt") * (Integer)m.get("orderPrice")%></td>
			<td><%=m.get("createdate").toString().substring(0, 11)%></td>
			<%
				if(rDao.selectReviewCntByOrderNo((Integer)m.get("orderNo")) == 0){ //해당 주문번호의 리뷰 수가 0일 경우에는 리뷰작성 출력
			%>
					<td><a href="<%=request.getContextPath()%>/addReview.jsp?orderNo=<%=(Integer)m.get("orderNo")%>">리뷰작성</a></td>
			<%
				} else {
			%>
					<td>&nbsp;</td>
			<%
				}
			%>
		</tr>
		<%
			}
		%>
	</table>
		
</body>
</html>