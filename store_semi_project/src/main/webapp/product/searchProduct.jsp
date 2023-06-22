<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%	
	final String RE = "\u001B[0m"; 
	final String SJ = "\u001B[44m";
	request.setCharacterEncoding("utf-8");
	String search = null;
	if(request.getParameter("search") != null) {
		search = request.getParameter("search");
	} else {
		response.sendRedirect(request.getContextPath()+"/product/productHome.jsp");
		return;	
	}
	
	System.out.println(SJ+search + RE );
	// 객체 생성
	ProductDao pDao = new ProductDao();
	ArrayList<Product> sList = pDao.searchProduct(search);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>
		<a href="<%=request.getContextPath()%>/product/productHome.jsp">
			<button type="button">목록으로</button>
		</a>
	</div>
	<table >
	<h1>"<%=search %>" 검색결과</h1>
		<tr>
			<th >p no.</th>
			<th >카테고리</th>
			<th >이름</th>
			<th >가격</th>
			<th >상태</th>
			<th >재고</th>
			<th >등록일</th>
			<th >수정일</th>
		</tr>
		<%
			for(Product p : sList) {
				// 할인 기간 확인을 위한 변수와 분기
				
		%>
				<tr>
					<td>
						<a href="<%=request.getContextPath()%>/product/productDetail.jsp?p.productNo=<%=p.getProductNo()%>">
							<%=p.getProductNo()%>
						</a>
					</td>
					<td><%=p.getCategoryName()%></td>
					<td><%=p.getProductName()%></td>
					<td><%=p.getProductPrice()%></td>
					<td><%=p.getProductStatus()%></td>
					<td><%=p.getProductStock()%></td>
					<td><%=p.getCreatedate()%></td>
					<td><%=p.getUpdatedate()%></td>
				</tr>
		<%		
			}
		%>
		
	</table>
</body>
</html>