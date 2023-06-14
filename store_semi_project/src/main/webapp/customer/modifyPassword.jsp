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
		System.out.println(KMJ + "customerOne 로그인되어있지 않아 리다이렉션" + RESET);
		return;
	}
	String loginId = session.getAttribute(KMJ + "loginId" + " <--customerOne loginId" + RESET);*/
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("id") + " <--modifyPassword param id" + RESET);
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	/* if(request.getParameter("id") == null || !loginId.equals(request.getParameter("id"))){
		response.sendRedirect(KMJ + request.getContextPath()+"/메인.jsp" + RESET);
		return;
	}
	String id = request.getParameter("id");
	System.out.println(KMJ + id + " <--modifyPassword id" + RESET); */
	
	String id = "user1";
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Modify Password</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/customer/modifyPasswordAction.jsp" method="post">
		<input type="hidden" name="id" value="<%=id%>">
		<table>
			<tr>
				<th>새로운 비밀번호</th>
				<td><input type="password" name="newPw">
			</td>
			<tr>
				<th>새로운 비밀번호 확인</th>
				<td><input type="password" name="cnfmNewPw">
			</td>
		</table>
		<button type="submit">수정하기</button>
	</form>
</body>
</html>