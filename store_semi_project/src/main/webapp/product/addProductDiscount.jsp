<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
final String RE = "\u001B[0m"; 
final String SJ = "\u001B[44m";
//요청값 유효성 검사
	if(request.getParameter("p.productNo") == null  
		|| request.getParameter("p.productNo").equals("")) {
		// subjectList.jsp으로
		response.sendRedirect(request.getContextPath() + "/product/productList.jsp");
		return;
	}
	// 요청값 변수에 저장
	int productNo = Integer.parseInt(request.getParameter("p.productNo"));
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 할인율 추가 페이지</title>
</head>
<body>
	<div >
		<a href="<%=request.getContextPath()%>/product/productList.jsp">
			<button type="button">목록으로</button>
		</a>
	</div>
	<div class="container">
	<h1>관리자 페이지 : 할인율 추가</h1>
	<form action = "<%=request.getContextPath()%>/product/addProductDiscountAction.jsp" method="post">
		<table>
			
			<tr>
				<th>상품 번호</th>
				<td><input type="text" name="p.productNo" readonly="readonly" value = "<%=productNo%>"></td>
			</tr>
			<tr>
				<th>할인율</th>
				<td><input type="text" name="discountRate"></td>
			</tr>
			<tr>
				<th>할인 시작</th>
				<td><input type="date" name="discountStart"></td>
			</tr>
			<tr>
				<th>할인 종료</th>
				<td><input type="date" name="discountEnd"></td>
			</tr>
		</table>
		<button type="submit">추가</button>
	</form>
	</div>
</body>
</html>