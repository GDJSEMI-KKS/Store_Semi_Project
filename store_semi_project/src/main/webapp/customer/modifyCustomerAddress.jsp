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
		System.out.println(KMJ + "modifyCustomer 로그인되어있지 않아 리다이렉션" + RESET);
		return;
	}
	String loginId = session.getAttribute(KMJ + "loginId" + " <--addCustomerAddress loginId" + RESET);*/
	
	//요청값 post방식 인코딩
	request.setCharacterEncoding("utf-8");
	
	//요청값이 넘어오는지 확인하기
	System.out.println(request.getParameter("id") + " <--modifyCustomerAddress param id" + RESET);
	System.out.println(request.getParameter("addNo") + " <--modifyCustomerAddress param addNo" + RESET);

	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	if(request.getParameter("id") == null || request.getParameter("addNo") == null){
		response.sendRedirect(KMJ + request.getContextPath()+"/home.jsp" + RESET);
		return;
	}
	String id = request.getParameter("id");
	int addNo = Integer.parseInt(request.getParameter("addNo"));
	System.out.println(KMJ + id + " <--modifyCustomerAddress id" + RESET); 
	System.out.println(KMJ + id + " <--modifyCustomerAddress id" + RESET); 
	
	//주소정보 출력을 위한 dao생성
	//주소는 10개까지만 추가가 가능하고, 기본 주소는 삭제 불가
	AddressDao aDao = new AddressDao();
	Address address = aDao.selectAddressByOrderNo(addNo);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Modify Customer Address</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/customer/modifyCustomerAddressAction.jsp" method="post">
		<input type=hidden name="id" value="<%=id%>">
		<input type=hidden name="addNo" value="<%=addNo%>">
		<table>
			<tr>
				<th>이름</th>
				<th>주소</th>
				<th>기본값</th>
			</tr>
			<tr>
				<td><input type="text" name="addName" value="<%=address.getAddressName()%>"></td>
				<td><input type="text" name="add" value="<%=address.getAddress()%>"></td>
				<td>
				<%
					if(address.getAddressDefault().equals("Y")){
				%>
						<input type="radio" name="addDefault" value="<%=address.getAddressDefault()%>" checked readonly>
				<%
					} else {
				%>
						<input type="radio" name="addDefault" value="<%=address.getAddressDefault()%>">
				<%
					}
				%>
				</td>
			</tr>
		</table>
		<button type="submit">수정</button>
	</form>
</body>
</html>