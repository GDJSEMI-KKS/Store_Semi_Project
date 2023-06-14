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
	*/
	/* //요청값 post방식 인코딩
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
	
	//관리자정보 출력
	EmployeesDao eDao = new EmployeesDao();
	Employees employee = eDao.selectEmployee(id);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin One</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/admin_customer/modifyAdminLvAction.jsp" method="post">
		<input type="hidden" name="id" value="<%=id%>">
		<input type="hidden" name="name" value="<%=employee.getEmpName()%>">
		<input type="hidden" name="idLevel" value="0">
		<table>
			<tr>
				<th>아이디</th>
				<td><%=employee.getId()%></td>
			</tr>
			<tr>
				<th>이름</th>
				<td><%=employee.getEmpName()%></td>
			</tr>
			<tr>
				<th>등급</th>
				<td><%=employee.getEmpLevel() %></td>
			</tr>
			<%
				//관리자등급이 2인 경우에는 관리자등급을 변경할 수 있는 권한 주기
				if(employee.getEmpLevel().equals("2")){
			%>
					<tr>
						<th>관리자권한삭제</th>
						<td>
							<button type="submit">권한회수</button>
						</td>
					</tr>
			<%
				}
			%>
			<tr>
				<th>가입일</th>
				<td><%=employee.getCreatedate()%></td>
			</tr>
			<tr>
				<th>수정일</th>
				<td><%=employee.getUpdatedate()%></td>
			</tr>
		</table>
	</form>
</body>
</html>