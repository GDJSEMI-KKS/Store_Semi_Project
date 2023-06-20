<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	request.setCharacterEncoding("utf-8");
	
	
	// 아이디 레벨 검사 
	/*
	IdListDao iDao = new IdListDao();
	IdList idList = new IdList();
	int idLevel = idList.getIdLevel();
	System.out.println(SJ+ idLevel +"addQuestion idLevel"+ RE );
	
	//로그인 유효성 검사 : 로그아웃 상태면 어드민 홈으로
	if(session.getAttribute("loginId") == null ||
			idLevel == 1 || idLevel == 2){
		response.sendRedirect(request.getContextPath()+"/product/productDetail.jsp");
		System.out.println(SJ + "addQuestion 계정 확인" + RE);
		return;
	}
	*/
	if(request.getParameter("p.productNo") == null  
			|| request.getParameter("p.productNo").equals("")) {
			// subjectList.jsp으로
			response.sendRedirect(request.getContextPath() + "/product/productDetail.jsp");
			return;
		}
	String id = request.getParameter("id");
	id= "user2";
	int productNo = Integer.parseInt(request.getParameter("p.productNo"));
	System.out.println(SJ+productNo +"<--addQuestion productNo"+ RE );
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 문의 입력</title>
</head>
<body>
	<div >
		<a href="<%=request.getContextPath()%>/product/productList.jsp">
			<button type="button">목록으로</button>
		</a>
	</div>
	<div class="container">
	<h1>상품 페이지 : 문의추가</h1>
	<form action = "<%=request.getContextPath()%>/question/addQuestionAction.jsp" method="post">
		<table>
			
			<tr>
				<th>p no.</th>
				<td><input type="text" name="productNo" value = "<%=productNo%>" readonly="readonly"></td>
			</tr>
			<tr>
				<th>id</th>
				<td><input type="text" name="id" value = "<%=id%>" readonly="readonly"></td>
			</tr>
			<tr>
				<th>문의 카테고리</th>
				<td><input type="text" name="qCategory"></td>
			</tr>
			<tr>
				<th>문의 제목</th>
				<td><input type="text" name="qTitle"></td>
			</tr>
			<tr>
				<th>문의 내용</th>
				<td><input type="text" name="qContent"></td>
			</tr>
		</table>
		<button type="submit">추가</button>
	</form>
	</div>
</body>
</html>