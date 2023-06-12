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
	System.out.println(request.getParameter("id") + " <--addCustomerAddress id" + RESET);
	
	//요청값 유효성 검사: 요청값이 null인 경우 메인화면으로 리다이렉션
	/* if(request.getParameter("id") == null || !loginId.equals(request.getParameter("id"))){
		response.sendRedirect(KMJ + request.getContextPath()+"/메인.jsp" + RESET);
		return;
	}
	String id = request.getParameter("id");
	System.out.println(KMJ + id + " <--addCustomerAddress id" + RESET); */
	
	String id = "user1";
	
	//주소정보 출력을 위한 dao생성
	//주소는 10개까지만 추가가 가능하고, 기본 주소는 삭제 불가
	AddressDao aDao = new AddressDao();
	ArrayList<Address> addList = aDao.selectAddressList(id);
	
	//주소 추가는 10개까지만 가능하므로 주소 개수 반환하는 메서드 실행
	int addCnt = aDao.selectAddressCnt(id);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Customer Address</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/customer/addCustomerAddressAction.jsp?id=<%=id%>" method="post">
		<table>
			<tr>
				<th>이름</th>
				<th>주소</th>
				<th>기본값</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
			<%
				for(Address a : addList){
			%>
					<tr>
						<td><%=a.getAddressName()%></td>
						<td><%=a.getAddress()%></td>
			<%
						if(a.getAddressDefault().equals("Y")){
			%>
							<td>기본배송지</td>
			<%
						} else {
			%>
							<td>&nbsp;</td>
			<%
						}
			%>
						<td><a href="<%=request.getContextPath()%>/customer/modifyCustomerAddress.jsp?addNo=<%=a.getAddressNo()%>&id=<%=id%>">수정</a></td>
			<%
						if(a.getAddressDefault().equals("N")){ //기본주소가 아닌 경우에만 삭제 가능
			%>
							<td>
								<a href="<%=request.getContextPath()%>/customer/removeCustomerAddressAction.jsp?addNo=<%=a.getAddressNo()%>&id=<%=id%>">
								삭제
								</a>
							</td>
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
			if(addCnt<10){ //주소는 10개까지만 추가가능하므로 주소가 10개미만일때만 추가입력 폼 출력
			%>
				<tr>
					<td><input type="text" name="addName"></td>
					<td><input type="text" name="add"></td>
					<td><input type="checkbox" name="addDefault"></td>
					<td><button type="submit">추가</button></td>
					<td>&nbsp;</td>
				</tr>
			<%
			}
			%>
		</table>
	</form>
</body>
</html>