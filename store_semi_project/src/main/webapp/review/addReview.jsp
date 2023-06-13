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
	/* if(request.getParameter("orderNo") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int orderNo = Integer.parseInt(request.getParameter("orderNo")); */
	int orderNo = 1;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Review</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/review/addReviewAction.jsp" method="post" enctype="multipart/form-data">
	<input type="hidden" name="orderNo" value="<%=orderNo%>">
		<table>
			<tr>
				<th>제목</th>
				<td><input type="text" name="title"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="content"></textarea></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><input type="text" name="id" value="<%=loginId%>" readonly></td>
			</tr>
			<tr>
				<th>이미지첨부</th>
				<td><input type="file" name="img"></td>
			</tr>
		</table>
		<button type="submit">작성하기</button>
	</form>
</body>
</html>