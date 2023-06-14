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
		System.out.println(KMJ + "ordersAction 로그인 필요" + RESET);
		return;
	}
	Object o = session.getAttribute("loginId" + " <--ordersAction loginId");
	String loginId = "";
	if(o instanceof String){
		loginId = (String)o;
	} 
	
	//관리자가 아닌 경우 홈으로 리다이렉션
	IdListDao iDao = new IdListDao();
	IdList loginLevel = iDao.selectIdListOne(loginId);
	int idLevel = loginLevel.getIdLevel();
	if(idLevel == 0){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(KMJ + request.getParameter("id") + " <--adminMemberOne param id" + RESET);
		
	//요청값 유효성 검사
	if(request.getParameter("reviewNo") == null){
		response.sendRedirect(request.getContextPath()+"/admin_customer/adminCustomerList.jsp");
		return;
	}
	String id = request.getParameter("id");
	System.out.println(KMJ + id + " <-adminMemberOne id" + RESET); */
	
	String id = "user3";

	//관리자인지 회원인지 확인
	EmployeesDao eDao = new EmployeesDao();
	Employees emp = eDao.selectEmployee(id);
	
	//id확인 후 관리자인 경우 관리자 상세페이지로 리다이렉션
	if(emp != null){ 
		response.sendRedirect(request.getContextPath()+"/admin_customer/adminOne.jsp");
		return;
	}
	
	//회원정보 출력
	CustomerDao cDao = new CustomerDao();
	Customer customer = cDao.selectCustomer(id);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Customer One</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/admin_customer/modifyAdminCustomerLvAction.jsp" method="post">
		<input type="hidden" name="id" value="<%=id%>">
		<input type="hidden" name="name" value="<%=customer.getCstmName()%>">
		<input type="hidden" name="idLevel" value="1">
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
			<%
				if(emp == null){
			%>
					<tr>
						<th>관리자권한부여</th>
						<td>
							<button type="submit">권한주기</button>
						</td>
					</tr>
			<%
				}
			%>
			<tr><!-- 9행 -->
				<th>포인트</th>
				<td><%=customer.getCstmPoint()%></td>
			</tr>
			<tr><!-- 10행 -->
				<th>총주문금액</th>
				<td><%=customer.getCstmSumPrice()%></td>
			</tr>
		</table>
	</form>
</body>
</html>