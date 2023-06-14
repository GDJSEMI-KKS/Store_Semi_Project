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

	/* //관리자가 아닌 경우 홈으로 리다이렉션
	IdListDao iDao = new IdListDao();
	IdList loginLevel = iDao.selectIdListOne(loginId);
	int idLevel = loginLevel.getIdLevel();
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} */
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(request.getParameter("id") + " <--customerOne id" + RESET);
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	/* if(request.getParameter("id") == null || !loginId.equals(request.getParameter("id"))){
		response.sendRedirect(KMJ + request.getContextPath()+"/메인.jsp" + RESET);
		return;
	}
	String id = request.getParameter("id");
	System.out.println(KMJ + id + " <--customerOne id" + RESET); */
	
	String id = "user1";
	
	//고객정보 출력을 위한 dao생성
	CustomerDao cDao = new CustomerDao();
	Customer customer = cDao.selectCustomer(id);

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>customerOne</title>
</head>
<body>
	<table>
		<tr><!-- 1행 -->
			<th>id</th>
			<td><%=customer.getId()%></td>
		</tr>
		<tr><!-- 2행 -->
			<th>이름</th>
			<td><%=customer.getCstmName()%></td>
		</tr>
		<tr><!-- 3행 -->
			<th>주소</th>
			<td><%=customer.getCstmAddress()%></td>
		</tr>
		<tr><!-- 4행 -->
			<th>이메일</th>
			<td><%=customer.getCstmEmail()%></td>
		</tr>
		<tr><!-- 5행 -->
			<th>생일</th>
			<td><%=customer.getCstmBirth()%></td>
		</tr>
		<tr><!-- 6행 -->
			<th>연락처</th>
			<td><%=customer.getCstmPhone()%></td>
		</tr>
		<tr><!-- 7행 -->
			<th>성별</th>
			<td><%=customer.getCstmGender()%></td>
		</tr>
		<tr><!-- 8행 -->
			<th>회원등급</th>
			<td><%=customer.getCstmRank()%></td>
		</tr>
		<tr><!-- 9행 -->
			<th>포인트</th>
			<td><%=customer.getCstmPoint()%><a href="<%=request.getContextPath()%>/customer/pointHistory.jsp">포인트이력확인</a></td>
		</tr>
		<tr><!-- 10행 -->
			<th>총주문금액</th>
			<td><%=customer.getCstmSumPrice()%></td>
		</tr>
	</table>
	<a href="<%=request.getContextPath()%>/customer/modifyCustomer.jsp?id=<%=customer.getId()%>">회원정보수정</a>
	<a href="<%=request.getContextPath()%>/customer/modifyPassword.jsp?id=<%=customer.getId()%>">비밀번호변경</a>
</body>
</html>